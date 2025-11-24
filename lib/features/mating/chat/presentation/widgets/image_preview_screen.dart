// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:squeak/generated/l10n.dart';

// class ImagePreviewScreen extends StatefulWidget {
//   final File imageFile;
//   final Function(File file) onSend;

//   const ImagePreviewScreen({
//     super.key,
//     required this.imageFile,
//     required this.onSend,
//   });

//   @override
//   State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
// }

// class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
//   late File _currentImage;
//   final TextEditingController _captionController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _currentImage = widget.imageFile;
//   }

//   @override
//   void dispose() {
//     _captionController.dispose();
//     super.dispose();
//   }

//   Future<void> _cropImage() async {
//     final croppedFile = await ImageCropper().cropImage(
//       sourcePath: _currentImage.path,
//       uiSettings: [
//         AndroidUiSettings(
//           toolbarTitle: 'Edit Image',
//           toolbarColor: const Color(0xFF6200EA),
//           toolbarWidgetColor: Colors.white,
//           initAspectRatio: CropAspectRatioPreset.original,
//           lockAspectRatio: false,
//           aspectRatioPresets: [
//             CropAspectRatioPreset.square,
//             CropAspectRatioPreset.ratio3x2,
//             CropAspectRatioPreset.original,
//             CropAspectRatioPreset.ratio4x3,
//             CropAspectRatioPreset.ratio16x9
//           ],
//         ),
//         IOSUiSettings(
//           title: 'Edit Image',
//           aspectRatioPresets: [
//             CropAspectRatioPreset.square,
//             CropAspectRatioPreset.ratio3x2,
//             CropAspectRatioPreset.original,
//             CropAspectRatioPreset.ratio4x3,
//             CropAspectRatioPreset.ratio16x9
//           ],
//         ),
//       ],
//     );

//     if (croppedFile != null) {
//       setState(() {
//         _currentImage = File(croppedFile.path);
//       });
//     }
//   }

//   void _handleSend() {
//     widget.onSend(_currentImage);
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;

//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1E1E1E),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Preview',
//           style: TextStyle(color: Colors.white),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.crop_rotate, color: Colors.white),
//             onPressed: _cropImage,
//             tooltip: 'Crop Image',
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Center(
//               child: InteractiveViewer(
//                 minScale: 0.5,
//                 maxScale: 4.0,
//                 child: Image.file(
//                   _currentImage,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFF2E2E2E),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.3),
//                   blurRadius: 8,
//                   offset: const Offset(0, -2),
//                 ),
//               ],
//             ),
//             child: SafeArea(
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _captionController,
//                       style: const TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         hintText: 'Add a caption...',
//                         hintStyle: TextStyle(color: Colors.grey[400]),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(25),
//                           borderSide: BorderSide.none,
//                         ),
//                         filled: true,
//                         fillColor: Colors.grey[800],
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 20,
//                           vertical: 10,
//                         ),
//                       ),
//                       maxLines: null,
//                       textInputAction: TextInputAction.newline,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Container(
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         colors: [Color(0xFF6200EA), Color(0xFF9C27B0)],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: const Color(0xFF6200EA).withOpacity(0.4),
//                           blurRadius: 8,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: IconButton(
//                       icon: const Icon(Icons.send_rounded, color: Colors.white),
//                       onPressed: _handleSend,
//                       tooltip: S.of(context).send,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
