import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../core/service/main_service/presentation/controller/main_cubit/main_cubit.dart';
import '../../../../../../core/utils/enums/upload_place.dart';
import '../../../domain/entities/post_entity.dart';
import '../../community/controller/community_cubit.dart';
import '../../controller/post_cubit.dart';
import '../add_post_component/upload_post_animations.dart';
import '../add_post_component/upload_post_dialogs.dart';
import '../add_post_component/upload_post_snackbars.dart';


class EditPostController {
  final TickerProvider vsync;
  final PostEntity postEntity;
  final String petID;
  final String name;
  final String image;

  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;
  final FocusNode textFocusNode = FocusNode();
  final TextEditingController textContentEditingController = TextEditingController();
  final TextEditingController textTitleEditingController = TextEditingController();

  bool isLoading = false;
  late UploadPostAnimations animations;
  late UploadPostDialogs dialogs;
  late UploadPostSnackbars snackbars;

  // Track existing media (from network)
  final List<ExistingMediaItem> existingMedia = [];

  EditPostController({
    required this.vsync,
    required this.postEntity,
    required this.petID,
    required this.name,
    required this.image,
  }) {
    animations = UploadPostAnimations(this as dynamic);
    dialogs = UploadPostDialogs(this as dynamic);
    snackbars = UploadPostSnackbars(this as dynamic);
    _initializeData();
  }

  void _initializeData() {
    // Load existing content
    textContentEditingController.text = postEntity.content ?? '';
    textTitleEditingController.text = postEntity.title ?? '';

    // Load existing media
    if (postEntity.postSocialMedia != null) {
      for (var media in postEntity.postSocialMedia!) {
        if (media.imagePath?.isNotEmpty ?? false) {
          existingMedia.add(
            ExistingMediaItem(
              id: media.id ?? '',
              path: media.imagePath!,
              type: 'image',
            ),
          );
        }
        if (media.videoPath?.isNotEmpty ?? false) {
          existingMedia.add(
            ExistingMediaItem(
              id: media.id ?? '',
              path: media.videoPath!,
              type: 'video',
            ),
          );
        }
      }
    }
  }

  void initialize() {
    animations.initializeAnimations();
    _autoFocusTextField();
  }

  void dispose() {
    animationController.dispose();
    textFocusNode.dispose();
    textContentEditingController.dispose();
    textTitleEditingController.dispose();
  }

  void _autoFocusTextField() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        textFocusNode.requestFocus();
      });
    });
  }

  void handlePostStateChanges(BuildContext context, PostState state) {
    if (state is CreatePostLoadingState) {
      setState(() => isLoading = true);
    } else {
      setState(() => isLoading = false);
    }

    if (state is CreatePostErrorState) {
      snackbars.showErrorSnackBar(context, state.message);
    }

    if (state is CreatePostSuccessState) {
      _showUpdateSuccessAndNavigate(context);
    }
  }

  void _showUpdateSuccessAndNavigate(BuildContext context) {
    snackbars.showSuccessAndNavigate(context);
    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pop(context);
      Navigator.pop(context); // Pop twice to go back to feed
    });
  }

  void setState(VoidCallback callback) {
    callback();
  }

  // Remove existing media
  void removeExistingMedia(int index) {
    existingMedia.removeAt(index);
    setState(() {});
  }

  // Media handling methods
  Future<void> pickMultipleImages(
      CommunityCubit cubit,
      BuildContext context,
      ) async {
    try {
      await cubit.pickMultipleImages(source: ImageSource.gallery);
      setState(() {});
    } catch (e) {
      snackbars.showErrorSnackBar(context, 'Failed to pick images: $e');
    }
  }

  Future<void> pickMultipleVideos(
      CommunityCubit cubit,
      BuildContext context,
      ) async {
    try {
      await cubit.pickMultipleVideos(source: ImageSource.gallery);
      setState(() {});
    } catch (e) {
      snackbars.showErrorSnackBar(context, 'Failed to pick videos: $e');
    }
  }

  void clearAllNewMedia(CommunityCubit cubit) {
    cubit.clearAllMedia();
    setState(() {});
  }

  void clearAllMedia(CommunityCubit cubit) {
    cubit.clearAllMedia();
    existingMedia.clear();
    setState(() {});
  }

  Future<void> handlePostUpdate(
      BuildContext context,
      CommunityCubit cubit,
      ) async {
    final content = textContentEditingController.text.trim();

    // Validation
    if (content.isEmpty && cubit.mediaFiles.isEmpty && existingMedia.isEmpty) {
      return dialogs.showValidationDialog(
        context,
        'Missing Content',
        'Please write something or add media!',
        'يرجى كتابة شيء أو إضافة وسائط!',
      );
    }

    if (content.length > 1000) {
      return dialogs.showValidationDialog(
        context,
        'Content Too Long',
        'Post text cannot exceed 1000 characters.',
        'لا يمكن أن يتجاوز نص المنشور 1000 حرف.',
      );
    }

    // Check file sizes for new media
    for (final file in cubit.mediaFiles) {
      final sizeMB = file.lengthSync() / (1024 * 1024);
      if (sizeMB > 15) {
        return dialogs.showValidationDialog(
          context,
          'File Too Large',
          'File size cannot exceed 15MB.',
          'لا يمكن أن يتجاوز حجم الملف 15 ميجابايت.',
        );
      }
    }

    // Update post
    final postCubit = PostCubit.get(context);
    final mainCubit = MainCubit.get(context);

    await _uploadAndUpdatePost(
      context: context,
      cubit: cubit,
      postCubit: postCubit,
      mainCubit: mainCubit,
      title: textTitleEditingController.text.trim(),
      content: content,
    );
  }

  Future<void> _uploadAndUpdatePost({
    required BuildContext context,
    required CommunityCubit cubit,
    required PostCubit postCubit,
    required MainCubit mainCubit,
    required String title,
    required String content,
  }) async {
    setState(() => isLoading = true);

    try {
      List<Map<String, String?>> postSocialMedias = [];

      // Add existing media (keep network media)
      for (var media in existingMedia) {
        postSocialMedias.add({
          'id': media.id,
          'ImagePath': media.type == 'image' ? media.path : null,
          'VideoPath': media.type == 'video' ? media.path : null,
        });
      }

      // Upload new media
      for (int i = 0; i < cubit.mediaFiles.length; i++) {
        final file = cubit.mediaFiles[i];
        final isImage = cubit.mediaTypes[i] == 'image';

        if (isImage) {
          await mainCubit.getGlobalImage(file, UploadPlace.postImages);
          final imageUrl = mainCubit.modelImage?.data ?? '';

          if (imageUrl.isEmpty) {
            throw Exception('Failed to upload image');
          }

          postSocialMedias.add({'ImagePath': imageUrl, 'VideoPath': null});
        } else {
          await mainCubit.getGlobalVideo(file, UploadPlace.postVideos);
          final videoUrl = mainCubit.modelImage?.data ?? '';

          if (videoUrl.isEmpty) {
            throw Exception('Failed to upload video');
          }

          postSocialMedias.add({'ImagePath': null, 'VideoPath': videoUrl});
        }
      }

      // Call update API
      await postCubit.updatePostWithMultipleMedia(
        petId: petID,
        id: postEntity.postId!,
        title: title,
        content: content,
        postSocialMedias: postSocialMedias,
      );
    } catch (e) {
      snackbars.showErrorSnackBar(context, 'Failed to update post: $e');
      setState(() => isLoading = false);
    }
  }

  void handleClose(BuildContext context, CommunityCubit cubit) {
    final hasChanges = _hasContentChanged() || cubit.mediaFiles.isNotEmpty;

    if (hasChanges) {
      dialogs.showDiscardDialog(context);
    } else {
      Navigator.pop(context);
    }
  }

  bool _hasContentChanged() {
    return textContentEditingController.text.trim() != (postEntity.content ?? '') ||
        textTitleEditingController.text.trim() != (postEntity.title ?? '') ||
        existingMedia.length != (postEntity.postSocialMedia?.length ?? 0);
  }

  Future<bool> onWillPop(BuildContext context, CommunityCubit cubit) async {
    final hasChanges = _hasContentChanged() || cubit.mediaFiles.isNotEmpty;

    if (hasChanges) {
      final shouldPop = await dialogs.showDiscardDialog(context);
      return shouldPop ?? false;
    }
    return true;
  }

  TextDirection getTextDirection(String text) {
    if (text.isEmpty) return TextDirection.ltr;
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text) ? TextDirection.rtl : TextDirection.ltr;
  }

  int getTotalMediaCount(CommunityCubit cubit) {
    return existingMedia.length + cubit.mediaFiles.length;
  }
}

// Model for existing media
class ExistingMediaItem {
  final String id;
  final String path;
  final String type; // 'image' or 'video'

  ExistingMediaItem({
    required this.id,
    required this.path,
    required this.type,
  });
}
