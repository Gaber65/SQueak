import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:squeak/core/utils/theme/color_mangment/color_manager.dart';

class AddPetImagePicker extends StatelessWidget {
  final File? imagefile;
  final Function(File?) onImagePicked;

  const AddPetImagePicker({
    super.key,
    required this.imagefile,
    required this.onImagePicked,
  });

  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Please Choose An Option',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Divider(),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  _pickImageWithCamera();
                },
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Camera'),
                      SizedBox(width: 8),
                      Icon(Icons.camera, color: Colors.amber),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  _pickImageWithGallery();
                },
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Gallery'),
                      SizedBox(width: 8),
                      Icon(Icons.browse_gallery, color: Colors.blue),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickImageWithCamera() async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 1080,
        maxHeight: 1080,
      );
      if (pickedFile != null) {
        onImagePicked(File(pickedFile.path));
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _pickImageWithGallery() async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080,
        maxHeight: 1080,
      );
      if (pickedFile != null) {
        onImagePicked(File(pickedFile.path));
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(
              child: imagefile != null
                  ? Image.file(
                      imagefile!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                  : const CircleAvatar(
                      radius: 48,
                      backgroundColor: ColorManager.white,
                      child: Icon(
                        Icons.pets,
                        color: ColorManager.primaryColor,
                        size: 42,
                      ),
                    ),
            ),
          ),
          Positioned(
            bottom: -8,
            right: -12,
            child: InkWell(
              onTap: () => _showImagePickerDialog(context),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: ColorManager.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}