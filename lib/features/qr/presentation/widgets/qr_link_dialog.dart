import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import '../../../../core/service/global_function/format_utils.dart';
import '../../../../core/service/global_widget/custom_text_form_field.dart';
import '../../../../core/service/global_widget/toast.dart';
import '../../../../core/service/service_locator/service_locator.dart';
import '../../../../core/utils/theme/color_mangment/color_manager.dart';
import '../controller/qr_cubit.dart';
import '../../../pets/domain/entities/pet_entity.dart';
import '../view/new_scanner.dart';

class QrLinkDialog extends StatefulWidget {
  final PetEntities pet;

  const QrLinkDialog({super.key, required this.pet});

  @override
  State<QrLinkDialog> createState() => _QrLinkDialogState();
}

class _QrLinkDialogState extends State<QrLinkDialog> {
  final TextEditingController qrController = TextEditingController();
  bool isScanning = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<QrCubit>(),
      child: BlocListener<QrCubit, QrState>(
        listener: (context, state) {
          if (state is QrLinkSuccess) {
            Navigator.pop(context);

            successToast(context, state.message);
          } else if (state is QrUnlinkSuccess) {
            successToast(context, state.message);
          } else if (state is QrDownloadSuccess) {
            successToast(context, state.message);
          } else if (state is QrError) {
            errorToast(context, state.message);
          }
        },
        child: AlertDialog(
          title: Text(
            isArabic()
                ? 'ربط رمز QR الي ${widget.pet.petName}'
                : 'Link QR Code to ${widget.pet.petName}',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.qr_code_2,
                size: 100,
                color: ColorManager.primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                isArabic()
                    ? 'اربط حيوانك الأليف برمز QR عن طريق مسحه أو إدخال الرمز يدويًا'
                    : 'Link your pet to a QR code by scanning it or entering the code manually',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: MyTextForm(
                      controller: qrController,
                      prefixIcon: Icon(Icons.qr_code_2, size: 20),
                      enable: false,
                      enabled: false,
                      hintText:
                          isArabic()
                              ? 'أدخل معرف رمز QR أو امسحه'
                              : 'Enter QR code ID or scan',
                      validatorText:
                          isArabic()
                              ? 'أدخل معرف رمز QR أو امسحه'
                              : 'Enter QR code ID or scan',

                      obscureText: false,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: isScanning ? null : _simulateScan,
                    icon:
                        isScanning
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : Icon(IconlyBold.camera, size: 20),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                isArabic() ? 'إلغاء' : 'Cancel',
                style: const TextStyle(color: ColorManager.primaryColor),
              ),
            ),
            BlocBuilder<QrCubit, QrState>(
              builder: (context, state) {
                var cubit = QrCubit.get(context);
                final isLoading = state is QrLoading;
                return TextButton(
                  onPressed:
                      isLoading || qrController.text.isEmpty
                          ? null
                          : () {
                            _linkQr(cubit);
                          },
                  child:
                      isLoading
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : Text(
                            isArabic() ? 'ربط رمز QR' : 'Link QR Code',
                            style:  TextStyle(
                              color:qrController.text.isEmpty ? Colors.grey : ColorManager.primaryColor,
                            ),
                          ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _simulateScan() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScannerScreen()),
    );

    if (result != null && result is String) {
      setState(() {
        qrController.text = result;
      });
    }
  }

  void _linkQr(QrCubit cubit) {
    cubit.linkPetToQr(widget.pet.petId, qrController.text);
  }

  @override
  void dispose() {
    qrController.dispose();
    super.dispose();
  }
}
