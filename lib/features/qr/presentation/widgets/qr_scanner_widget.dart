import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/qr_cubit.dart';
import '../../../../core/utils/responsive_utils.dart';

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
              width: responsiveWidth(200, context),
              height: responsiveWidth(200, context),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.qr_code_scanner,
                size: responsiveWidth(100, context),
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              ),
            ),
            
            SizedBox(height: responsiveHeight(32, context)),
            
            Text(
              'Point your camera at a Squeak QR code to scan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: responsiveFontSize(16, context),
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            
            SizedBox(height: responsiveHeight(32, context)),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : _simulateScan,
                icon: isLoading 
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      )
                    : const Icon(Icons.camera_alt),
                label: Text(isLoading ? 'Scanning...' : 'Start Scanning'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: responsiveHeight(16, context),
                  ),
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

    if (random == 0) {
      // Invalid QR code
      if (mounted) {
        context.read<QrCubit>().emit(QrError('This QR code is not a valid Squeak code'));
      }
    } else if (random == 1) {
      // Empty QR code
      if (mounted) {
        context.read<QrCubit>().emit(QrScanEmpty());
      }
    } else {
      // Valid QR code with pet data
      if (mounted) {
        context.read<QrCubit>().scanQr(mockQrId);
      }
    }
  }
}
