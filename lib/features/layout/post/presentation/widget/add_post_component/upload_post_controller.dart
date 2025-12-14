import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../core/service/main_service/presentation/controller/main_cubit/main_cubit.dart'
    show MainCubit;
import '../../../../../../core/utils/enums/upload_place.dart';
import '../../community/controller/community_cubit.dart';
import '../../controller/post_cubit.dart';
import 'upload_post_animations.dart';
import 'upload_post_dialogs.dart';
import 'upload_post_snackbars.dart';

class UploadPostController {
  final TickerProvider vsync;
  final String petID;
  final String name;
  final String image;

  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;
  final FocusNode textFocusNode = FocusNode();
  final TextEditingController textContentEditingController =
      TextEditingController();

  bool isLoading = false;
  late UploadPostAnimations animations;
  late UploadPostDialogs dialogs;
  late UploadPostSnackbars snackbars;

  UploadPostController({
    required this.vsync,
    required this.petID,
    required this.name,
    required this.image,
  }) {
    animations = UploadPostAnimations(this);
    dialogs = UploadPostDialogs(this);
    snackbars = UploadPostSnackbars(this);
  }

  void initialize() {
    animations.initializeAnimations();
    _autoFocusTextField();
  }

  void dispose() {
    animationController.dispose();
    textFocusNode.dispose();
    textContentEditingController.dispose();
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
      snackbars.showSuccessAndNavigate(context);
    }
  }

  void setState(VoidCallback callback) {
    callback();
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

  void clearAllMedia(CommunityCubit cubit) {
    cubit.clearAllMedia();
    setState(() {});
  }

  Future<void> handlePostSubmit(
    BuildContext context,
    CommunityCubit cubit,
  ) async {
    final content = textContentEditingController.text.trim();

    // Validation
    if (content.isEmpty && cubit.mediaFiles.isEmpty) {
      return dialogs.showValidationDialog(
        context,
        'Missing Content',
        'Please write something or add media!',
        'يرجى كتابة شيء أو إضافة وسائط!',
      );
    }


    if (content.length >= 1000) {
      return dialogs.showValidationDialog(
        context,
        'Content Too Long',
        'Post text cannot exceed 1000 characters.',
        'لا يمكن أن يتجاوز نص المنشور 1000 حرف.',
      );
    }

    for (final file in cubit.mediaFiles) {
      final sizeMB = file.lengthSync() / (1024 * 1024);
      if (sizeMB >= 10) {
        return dialogs.showValidationDialog(
          context,
          'File Too Large',
          'File size cannot exceed 10MB.',
          'لا يمكن أن يتجاوز حجم الملف 10 ميجابايت.',
        );
      }
    }

    // Submit logic
    final postCubit = PostCubit.get(context);
    final mainCubit = MainCubit.get(context);

    if (cubit.mediaFiles.isEmpty) {
      // Text-only post
      return await postCubit.createPostWithMultipleMedia(
        petId: petID,
        title: '',
        content: content,
        postSocialMedias: [],
      );
    } else {
      // Post with multiple media
      return await _uploadMultipleMediaAndCreatePost(
        context: context,
        cubit: cubit,
        postCubit: postCubit,
        mainCubit: mainCubit,
        text: '',
        content: content,
      );
    }
  }

  Future<void> _uploadMultipleMediaAndCreatePost({
    required BuildContext context,
    required CommunityCubit cubit,
    required PostCubit postCubit,
    required MainCubit mainCubit,
    required String text,
    required String content,
  }) async {
    setState(() => isLoading = true);

    try {
      List<Map<String, String?>> postSocialMedias = [];

      for (int i = 0; i < cubit.mediaFiles.length; i++) {
        final file = cubit.mediaFiles[i];
        final isImage = cubit.mediaTypes[i] == 'image';

        if (isImage) {
          await mainCubit.getGlobalImage(file, UploadPlace.postImages);
          final imageUrl = mainCubit.modelImage?.data ?? '';

          if (imageUrl.isEmpty) {
            throw Exception('Failed to upload image');
          }

          postSocialMedias.add({'image': imageUrl, 'video': null});
        } else {
          await mainCubit.getGlobalVideo(file, UploadPlace.postVideos);
          final videoUrl = mainCubit.modelImage?.data ?? '';

          if (videoUrl.isEmpty) {
            throw Exception('Failed to upload video');
          }

          postSocialMedias.add({'image': null, 'video': videoUrl});
        }
      }

      await postCubit.createPostWithMultipleMedia(
        petId: petID,
        title: text,
        content: content,
        postSocialMedias: postSocialMedias,
      );
    } catch (e) {
      snackbars.showErrorSnackBar(context, 'Failed to upload media: $e');
      setState(() => isLoading = false);
    }
  }

  void handleClose(BuildContext context, CommunityCubit cubit) {
    final hasContent =
        textContentEditingController.text.trim().isNotEmpty ||
        cubit.mediaFiles.isNotEmpty;

    if (hasContent) {
      dialogs.showDiscardDialog(context);
    } else {
      Navigator.pop(context);
    }
  }

  Future<bool> onWillPop(BuildContext context, CommunityCubit cubit) async {
    final hasContent =
        textContentEditingController.text.trim().isNotEmpty ||
        cubit.mediaFiles.isNotEmpty;

    if (hasContent) {
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
}
