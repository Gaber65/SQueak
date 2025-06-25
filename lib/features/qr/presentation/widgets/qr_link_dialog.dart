import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../pets/domain/entities/pet_entity.dart';
import '../controller/qr_cubit.dart';
import '../../../../core/utils/responsive_utils.dart';

class QrLinkDialog extends StatefulWidget {
  final PetEntities pet;

  const QrLinkDialog({
    super.key,
    required this.pet,
  });

  @override
  State<QrLinkDialog> createState() => _QrLinkDialogState();
}

class _QrLinkDialogState extends State<QrLinkDialog> {
  final TextEditingController qrController = TextEditingController();
  bool isScanning = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<QrCubit, QrState>(
      listener: (context, state) {
        if (state is QrLinkSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Pet successfully linked to QR code!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is QrError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: AlertDialog(
        title: Text('Link QR Code to ${widget.pet.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.qr_code,
              size: responsiveWidth(64, context),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            SizedBox(height: responsiveHeight(16, context)),
            Text(
              'Link your pet to a QR code by scanning it or entering the code manually',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: responsiveFontSize(14, context),
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            SizedBox(height: responsiveHeight(16, context)),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: qrController,
                    decoration: const InputDecoration(
                      labelText: 'QR Code ID',
                      hintText: 'Enter QR code ID or scan',
                    ),
                  ),
                ),
                SizedBox(width: responsiveWidth(8, context)),
                IconButton(
                  onPressed: isScanning ? null : _simulateScan,
                  icon: isScanning 
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.camera_alt),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          BlocBuilder<QrCubit, QrState>(
            builder: (context, state) {
              final isLoading = state is QrLoading;
              return TextButton(
                onPressed: (isLoading || qrController.text.isEmpty) 
                    ? null 
                    : _linkQr,
                child: isLoading 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Link QR Code'),
              );
            },
          ),
        ],
      ),
    );
  }

  void _simulateScan() async {
    setState(() {
      isScanning = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isScanning = false;
      qrController.text = 'QR${DateTime.now().millisecondsSinceEpoch}';
    });
  }

  void _linkQr() {
    context.read<QrCubit>().linkQr(widget.pet.id, qrController.text);
  }

  @override
  void dispose() {
    qrController.dispose();
    super.dispose();
  }
}
