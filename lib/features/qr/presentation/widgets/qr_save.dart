import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class QrSave extends StatelessWidget {
   QrSave({super.key, required this.qrData, required this.isDarkMode});
  final String qrData;
  final bool isDarkMode;
  final GlobalKey _qrKey = GlobalKey();

  Future<Uint8List> _capturePng() async {
    try {
      RenderRepaintBoundary boundary = _qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();
        return pngBytes;
      } else {
        throw Exception("Failed to convert image to ByteData.");
      }
    } catch (e) {
      // print(e);
      throw Exception("Failed to capture image.");
    }
  }

  Future<void> _saveAsPdf(Uint8List imageBytes) async {
    final pdf = pw.Document();

    final image = pw.MemoryImage(imageBytes);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(child: pw.Image(image));
        },
      ),
    );

    // Save PDF or share it using the `Printing` package
    await Printing.sharePdf(bytes: await pdf.save(), filename: 'qr.pdf');
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDarkMode
                  ? [
                    Colors.grey.shade900,
                    Colors.grey.shade800,
                    Colors.black87,
                  ]
                  : [
                    Colors.blue.shade50,
                    Colors.white,
                    Colors.purple.shade50,
                  ],
        ),
        border:
            isDarkMode
                ? Border.all(color: Colors.grey.shade700, width: 1)
                : null,
      ),
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:
                  isDarkMode
                      ? [
                        Colors.grey.shade900,
                        Colors.grey.shade800,
                        Colors.black87,
                      ]
                      : [
                        Colors.blue.shade50,
                        Colors.white,
                        Colors.purple.shade50,
                      ],
            ),
            border:
                isDarkMode
                    ? Border.all(color: Colors.grey.shade700, width: 1)
                    : null,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header section
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            isDarkMode
                                ? Colors.blue.shade800.withOpacity(0.3)
                                : Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.qr_code_2,
                        color:
                            isDarkMode
                                ? Colors.blue.shade300
                                : Colors.blue.shade700,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        isArabic() ? "رمز الاستجابة السريعة" : "QR Code",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        color: isDarkMode ? Colors.grey.shade400 : Colors.grey,
                      ),
                      splashRadius: 20,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Animated QR Code
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.bounceOut,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color:
                            isDarkMode
                                ? Colors.black.withOpacity(0.5)
                                : Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: RepaintBoundary(
                    key: _qrKey,
                    child: QrImageView(
                      backgroundColor: Colors.white,
                      data: qrData,
                      version: QrVersions.auto,
                      size: 200.0,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.circle,
                        color: Colors.black,
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.circle,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Description text
                Text(
                  isArabic()
                      ? "امسح الرمز ضوئياً للوصول السريع"
                      : "Scan this code for quick access",
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                // Action buttons with enhanced dark mode styling
                Row(
                  children: [
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          borderRadius: BorderRadius.circular(12),
                          splashColor:
                              isDarkMode
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade200,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    isDarkMode
                                        ? Colors.grey.shade600
                                        : Colors.grey.shade300,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.close,
                                  size: 18,
                                  color:
                                      isDarkMode
                                          ? Colors.grey.shade300
                                          : Colors.grey.shade700,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isArabic() ? "إغلاق" : "Close",
                                  style: TextStyle(
                                    color:
                                        isDarkMode
                                            ? Colors.grey.shade300
                                            : Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Material(
                        color:
                            isDarkMode
                                ? Colors.blue.shade700
                                : Colors.blue.shade600,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: () async {
                            Uint8List imageBytes = await _capturePng();
                            _saveAsPdf(imageBytes);
                          },
                          borderRadius: BorderRadius.circular(12),
                          splashColor:
                              isDarkMode
                                  ? Colors.blue.shade600
                                  : Colors.blue.shade700,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.download,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isArabic() ? "حفظ" : "Save",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
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
      ),
    );
  }
}
