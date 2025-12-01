import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/attach_files_in_chat/image_preview_screen.dart';
import 'package:squeak/features/mating/chat/presentation/widgets/attach_files_in_chat/attachment_options_bottom_sheet.dart';

class CameraScreen extends StatefulWidget {
  final Function(File file, AttachmentType type, {String? caption}) onAttachmentSelected;

  const CameraScreen({
    super.key,
    required this.onAttachmentSelected,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool _isTakingPhoto = false;
  String? _errorMessage;

  Future<void> _takePhoto() async {
    if (_isTakingPhoto) return;
    
    setState(() {
      _isTakingPhoto = true;
      _errorMessage = null;
    });

    try {
      // Request camera permission
      final status = await Permission.camera.request();
      
      if (!status.isGranted) {
        setState(() {
          _errorMessage = 'Camera permission denied. You can select from gallery instead.';
          _isTakingPhoto = false;
        });
        return;
      }

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (pickedFile != null && mounted) {
        debugPrint('📷 CameraScreen: Photo captured');
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MediaPreviewScreen(
              mediaFile: File(pickedFile.path),
              mediaType: MediaType.image,
              cameraOption: true,
              onSend: (file, caption) {
                debugPrint('✅ CameraScreen: Photo sent with caption: "${caption.isEmpty ? '(no caption)' : caption}"');
                widget.onAttachmentSelected(
                  file,
                  AttachmentType.image,
                  caption: caption,
                );
                Navigator.pop(context, true); // Return true when sent
              },
            ),
          ),
        );
        
        // If user sent the image, close camera screen
        if (result == true && mounted) {
          Navigator.pop(context);
        } else if (mounted) {
          // User went back, take another photo
          setState(() {
            _isTakingPhoto = false;
          });
          _takePhoto();
        }
      } else {
        if (mounted) {
          setState(() {
            _isTakingPhoto = false;
          });
        }
      }
    } catch (e) {
      debugPrint('❌ CameraScreen: Error taking photo: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Camera not available. Use gallery instead.';
          _isTakingPhoto = false;
        });
      }
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null && mounted) {
        debugPrint('📷 CameraScreen: Photo selected from gallery');
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MediaPreviewScreen(
              mediaFile: File(pickedFile.path),
              mediaType: MediaType.image,
              cameraOption: true,
              onSend: (file, caption) {
                debugPrint('✅ CameraScreen: Photo sent with caption: "${caption.isEmpty ? '(no caption)' : caption}"');
                widget.onAttachmentSelected(
                  file,
                  AttachmentType.image,
                  caption: caption,
                );
                Navigator.pop(context, true); // Return true when sent
              },
            ),
          ),
        );
        
        // If user sent the image, close camera screen
        if (result == true && mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      debugPrint('❌ CameraScreen: Error picking from gallery: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _takePhoto();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Camera', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: _isTakingPhoto
            ? const CircularProgressIndicator(color: Colors.white)
            : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_errorMessage != null) ...[
                      Icon(
                        Icons.camera_alt_outlined,
                        size: 64,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: _pickFromGallery,
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Choose from Gallery'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          backgroundColor: const Color(0xFF00BCD4),
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: _takePhoto,
                        child: const Text(
                          'Try Camera Again',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ] else ...[
                      ElevatedButton.icon(
                        onPressed: _takePhoto,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Take Photo'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          backgroundColor: const Color(0xFF665CFF),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}
