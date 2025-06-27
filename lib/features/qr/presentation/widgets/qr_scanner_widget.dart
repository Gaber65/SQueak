import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/service/global_function/format_utils.dart';
import '../controller/qr_cubit.dart';

class QrScannerWidget extends StatefulWidget {
  const QrScannerWidget({super.key});

  @override
  State<QrScannerWidget> createState() => _QrScannerWidgetState();
}

class _QrScannerWidgetState extends State<QrScannerWidget> {
  bool isScanning = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QrCubit, QrState>(
      builder: (context, state) {
        final isLoading = state is QrLoading || isScanning;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.qr_code_scanner,
                size: 100,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
            ),

            const SizedBox(height: 32),

            Text(
              isArabic()
                  ? 'وجه الكاميرا نحو رمز الاستجابة السريعة الخاص بـ Squeak للمسح'
                  : 'Point your camera at a Squeak QR code to scan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : _simulateScan,
                icon: isLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Icon(Icons.camera_alt),
                label: Text(
                  isLoading
                      ? (isArabic() ? 'جاري المسح...' : 'Scanning...')
                      : (isArabic() ? 'بدء المسح' : 'Start Scanning'),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _simulateScan() async {
    setState(() {
      isScanning = true;
    });

    // Simulate scanning delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isScanning = false;
    });

    // Simulate different QR scan results
    final random = DateTime.now().millisecondsSinceEpoch % 3;
    final mockQrId = 'QR${DateTime.now().millisecondsSinceEpoch}';

    if (mounted) {
      context.read<QrCubit>().scanQrCode(mockQrId);
    }
  }
}
