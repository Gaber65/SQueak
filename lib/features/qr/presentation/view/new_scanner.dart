import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';  // Temporarily disabled due to dependency conflict

import '../../../../core/service/global_function/format_utils.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isArabic() ? 'ماسح QR' : 'QR Scanner')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.qr_code_scanner,
              size: 100,
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              isArabic() 
                ? 'ماسح QR غير متاح مؤقتاً\nيرجى إدخال الرمز يدوياً'
                : 'QR Scanner temporarily unavailable\nPlease enter code manually',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(isArabic() ? 'إغلاق' : 'Close'),
            ),
          ],
        ),
      ),
      // Temporarily disabled due to mobile_scanner dependency conflict
      // body: MobileScanner(
      //   controller: MobileScannerController(
      //     facing: CameraFacing.back,
      //     torchEnabled: false,
      //   ),
      //   onDetect: (capture) {
      //     if (_isScanned) return;
      //
      //     final List<Barcode> barcodes = capture.barcodes;
      //     if (barcodes.isNotEmpty) {
      //       final String code = barcodes.first.rawValue ?? '';
      //       if (code.isNotEmpty) {
      //         _isScanned = true;
      //         Navigator.pop(context, code);
      //       }
      //     }
      //   },
      // ),
    );
  }
}
