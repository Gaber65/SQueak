// lib/features/stories/presentation/widgets/chat_messages/create_story_modal.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import '../../controllers/story_cubit.dart';
import '../../controllers/story_state.dart';
import '../common/app_strings.dart';

class CreateStoryModal extends StatefulWidget {
  const CreateStoryModal({super.key, required this.petId});

  final String petId;

  @override
  State<CreateStoryModal> createState() => _CreateStoryModalState();
}

class _CreateStoryModalState extends State<CreateStoryModal> {
  File? _selectedFile;
  bool _isPosting = false;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null && mounted) {
      setState(() => _selectedFile = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = StoryCubit.get(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BlocConsumer<StoryCubit, StoryState>(
      listener: (context, state) {
        if (state.status.index == StoryStatus.error.index) {
          setState(() => _isPosting = true);
          errorToast(context, state.errorMessage!);
        }
        if (state.status.index == StoryStatus.success.index) {
          setState(() => _isPosting = false);
          successToast(context, AppStrings.storyPostedSuccess(context));
          Navigator.pop(context);
        }
        if (state.status.index == StoryStatus.creating.index) {
          setState(() => _isPosting = true);
        }
      },
      builder: (context, state) {
        return AnimatedPadding(
          padding: EdgeInsets.only(bottom: bottomInset),
          duration: const Duration(milliseconds: 200),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Header
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Create Story",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// Upload Button
                  InkWell(
                    onTap: _pickImage,
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.camera_alt_outlined),
                          const SizedBox(width: 8),
                          Text(AppStrings.tapToAddPhoto(context)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// 9:16 Preview
                  if (_selectedFile != null)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: AspectRatio(
                        aspectRatio: 9 / 16,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_selectedFile!, fit: BoxFit.cover),
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  /// Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed:
                              _isPosting
                                  ? null
                                  : () {
                                    setState(() => _selectedFile = null);
                                    Navigator.pop(context);
                                  },
                          child: Text(AppStrings.cancelStory(context)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              (_selectedFile == null || _isPosting)
                                  ? null
                                  : () async {
                                    setState(() => _isPosting = true);
                                    MainCubit.get(context)
                                        .getGlobalImage(
                                          _selectedFile!,
                                          UploadPlace.storyImages,
                                        )
                                        .then((value) async {
                                          await cubit.createStory(
                                            petId: widget.petId,
                                            image:
                                                MainCubit.get(
                                                  context,
                                                ).modelImage!.data,
                                          );
                                        });

                                    if (!mounted) return;

                                    setState(() => _isPosting = false);

                                    if (cubit.state.status ==
                                        StoryStatus.creating) {
                                      Navigator.pop(context);
                                    }
                                  },
                          child:
                              _isPosting
                                  ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : Text(AppStrings.postStory(context)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
