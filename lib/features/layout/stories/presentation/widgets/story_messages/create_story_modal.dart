// lib/features/stories/presentation/widgets/chat_messages/create_story_modal.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../../controllers/story_controller.dart';
import '../common/app_strings.dart';

class CreateStoryModal extends StatefulWidget {
  final StoryController controller;
  const CreateStoryModal({super.key, required this.controller});

  @override
  State<CreateStoryModal> createState() => _CreateStoryModalState();
}

class _CreateStoryModalState extends State<CreateStoryModal> {
  File? _selectedFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedFile = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final safeInset = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: safeInset),
      duration: const Duration(milliseconds: 200),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(child: Text('Create Story', style: Theme.of(context).textTheme.titleMedium)),
                IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(height: 12),

            // Upload area
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
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

            // 9:16 preview
            if (_selectedFile != null)
              AspectRatio(
                aspectRatio: 9 / 16,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(_selectedFile!, fit: BoxFit.cover),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('9:16', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() => _selectedFile = null);
                      Navigator.of(context).pop();
                    },
                    child: Text(AppStrings.cancelStory(context)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedFile == null
                        ? null
                        : () async {
                      await widget.controller.postStory(
                        imageFile: _selectedFile!,
                        ownerId: 'owner-123', // TODO: inject real auth user
                        ownerName: 'You',
                        ownerAvatarUrl: '',
                      );
                      Navigator.of(context).pop();
                    },
                    child: Text(AppStrings.postStory(context)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// TODO: Implement create_story_modal.dart