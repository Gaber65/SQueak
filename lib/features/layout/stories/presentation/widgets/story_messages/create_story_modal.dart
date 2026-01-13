// lib/features/stories/presentation/widgets/chat_messages/create_story_modal.dart
import 'dart:io';
import 'dart:async';
import 'dart:ui' as ui;
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
      final file = File(picked.path);
      final valid = await _validateImageFile(file);
      if (!valid) return;

      setState(() => _selectedFile = file);
    }
  }

  Future<void> _pickFromCamera() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked != null && mounted) {
      final file = File(picked.path);
      final valid = await _validateImageFile(file);
      if (!valid) return;

      setState(() => _selectedFile = file);
    }
  }

  Future<bool> _validateImageFile(File file) async {
    try {
      final length = await file.length();

      if (length == 0) {
        errorToast(context, 'Selected image is empty or corrupted.');
        return false;
      }

      final sizeInMB = length / (1024 * 1024);
      if (sizeInMB > 10) {
        errorToast(context, 'Image is too large. Max size is 10 MB.');
        return false;
      }

      // Try to decode the image bytes to ensure it's a valid image
      final bytes = await file.readAsBytes();
      final completer = Completer<bool>();

      ui.decodeImageFromList(bytes, (ui.Image img) {
        completer.complete(true);
      });

      // Add a timeout to avoid hanging on bad files.
      final decoded = await completer.future.timeout(const Duration(seconds: 3), onTimeout: () {
        return false;
      });

      if (!decoded) {
        errorToast(context, 'Selected image appears to be corrupted.');
        return false;
      }

      return true;
    } catch (e) {
      errorToast(context, 'Selected image is corrupted or unreadable.');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = StoryCubit.get(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BlocConsumer<StoryCubit, StoryState>(
      listener: (context, state) {
        if (state.status.index == StoryStatus.error.index) {
          setState(() => _isPosting = false);
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
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Drag Handle
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                         S.of(context).createStory,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, size: 24),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _buildPickerButton(
                          icon: Icons.photo_library_rounded,
                          label: S.of(context).gallery,
                          onTap: _pickImage,
                          gradient: LinearGradient(
                            colors: [
                              Colors.purple.shade400,
                              Colors.purple.shade600,
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildPickerButton(
                          icon: Icons.camera_alt_rounded,
                          label: S.of(context).camera,
                          onTap: _pickFromCamera,
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade400,
                              Colors.blue.shade600,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  if (_selectedFile != null)
                    Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.65,
                          margin: const EdgeInsets.only(bottom: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              _selectedFile!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: IconButton(
                            onPressed: () => setState(() => _selectedFile = null),
                            icon: const Icon(Icons.close, color: Colors.white),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black.withOpacity(0.6),
                              padding: const EdgeInsets.all(8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                  /// Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isPosting ? null : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                          ),
                          child: Text(
                            AppStrings.cancelStory(context),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (_selectedFile == null || _isPosting)
                              ? null
                              : () async {
                                  setState(() => _isPosting = true);
                                  
                                  try {
                                    await MainCubit.get(context).getGlobalImage(
                                      _selectedFile!,
                                      UploadPlace.storyImages,
                                    );
                                    
                                    if (!mounted) return;
                                    
                                    await cubit.createStory(
                                      petId: widget.petId,
                                      image: MainCubit.get(context).modelImage!.data,
                                      dateTimeInUTC: DateTime.now(),
                                    );
                                  } catch (e) {
                                    if (!mounted) return;
                                    setState(() => _isPosting = false);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isPosting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  AppStrings.postStory(context),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
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

  Widget _buildPickerButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Gradient gradient,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}