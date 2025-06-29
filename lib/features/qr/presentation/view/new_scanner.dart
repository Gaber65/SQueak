import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/service/global_function/format_utils.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isArabic() ? 'ماسح QR' : 'QR Scanner')),
      body: MobileScanner(
        controller: MobileScannerController(
          facing: CameraFacing.back,

          torchEnabled: false,
        ),

        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final String code = barcodes.first.rawValue ?? '';
            if (code.isNotEmpty) {
              Navigator.pop(context, code);
            }
          }
        },
      ),
    );
  }
}
