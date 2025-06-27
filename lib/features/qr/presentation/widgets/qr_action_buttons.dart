import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:pdf/widgets.dart' as pw;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import '../../../pets/presentation/view/widgets/get_pet/action_button.dart';
import '../../../vaccination/presentation/pages/pet_vaccination_page.dart';
import '../controller/qr_cubit.dart';
import '../../../pets/domain/entities/pet_entity.dart';
import 'qr_link_dialog.dart';

class QrActionButtons extends StatelessWidget {
  final PetEntities pet;
  final PetCubit petCubit;
   QrActionButtons({super.key, required this.pet, required this.petCubit});
  final GlobalKey _qrKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QrCubit, QrState>(
      listener: (context, state) {
        if (state is QrLinkSuccess) {
          successToast(context, state.message);
        } else if (state is QrUnlinkSuccess) {
          successToast(context, state.message);
        } else if (state is QrDownloadSuccess) {
          successToast(context, state.message);
        } else if (state is QrError) {
          errorToast(context, state.message);
        }
      },
      builder: (context, state) {
        final isLinked = pet.qrCodeId != null;
        final isLoading = state is QrLoading;

        if (isLinked) {
          return Row(
            children: [
              Offstage(
                offstage: true,
                child: RepaintBoundary(
                  key: _qrKey,
                  child: QrImageView(
                    data: pet.qrCodeId!,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(5),
                    side: BorderSide(
                      color:
                          MainCubit.get(context).isDark
                              ? Colors.white
                              : Colors.grey.shade400,
                      width: .5,
                    ),
                  ),
                  onPressed: isLoading ? null : () async {
                    Uint8List imageBytes = await _capturePng();
                    _saveAsPdf(imageBytes);
                  },
                  icon:
                      isLoading
                          ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : Icon(
                            Icons.qr_code_sharp,
                            size: 16,
                            color:
                                MainCubit.get(context).isDark
                                    ? Colors.white
                                    : Colors.black,
                          ),
                  label: Text(
                    isArabic() ? 'تحميل QR' : 'Download QR',
                    style: TextStyle(
                      color:
                          MainCubit.get(context).isDark
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(5),
                    side: BorderSide(
                      color:
                          MainCubit.get(context).isDark
                              ? Colors.white
                              : Colors.grey.shade400,
                      width: .5,
                    ),
                  ),
                  onPressed: isLoading ? null : () => _unlinkQr(context),

                  child: Icon(
                    Icons.link_off,
                    size: 16,
                    color:
                        MainCubit.get(context).isDark
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
              ),

              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(5),
                    side: BorderSide(
                      color:
                          MainCubit.get(context).isDark
                              ? Colors.white
                              : Colors.grey.shade400,
                      width: .5,
                    ),
                  ),
                  onPressed:
                      () => navigateToScreen(
                        context,
                        PetVaccinationPage(petModel: pet),
                      ),
                  child: Icon(
                    IconlyLight.notification,
                    size: 16,
                    color: ColorManager.primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(5),
                    side: BorderSide(
                      color:
                          MainCubit.get(context).isDark
                              ? Colors.white
                              : Colors.grey.shade400,
                      width: .5,
                    ),
                  ),
                  onPressed: () => _showDeleteConfirmation(context),
                  child: Icon(
                    IconlyLight.delete,
                    size: 16,
                    color: ColorManager.red,
                  ),
                ),
              ),
            ],
          );
        } else {
          return Row(
            children: [
              Offstage(
                offstage: true,
                child: RepaintBoundary(
                  key: _qrKey,
                  child: QrImageView(
                    data: pet.qrCodeId ?? 'dsfdsfdsfdsf',
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(5),
                    side: BorderSide(
                      color:
                      MainCubit.get(context).isDark
                          ? Colors.white
                          : Colors.grey.shade400,
                      width: .5,
                    ),
                  ),
                  onPressed: isLoading ? null : () async {
                    Uint8List imageBytes = await _capturePng();
                    _saveAsPdf(imageBytes);
                  },
                  icon:
                  isLoading
                      ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : Icon(
                    Icons.qr_code_sharp,
                    size: 16,
                    color:
                    MainCubit.get(context).isDark
                        ? Colors.white
                        : Colors.black,
                  ),
                  label: Text(
                    isArabic() ? 'تحميل QR' : 'Download QR',
                    style: TextStyle(
                      color:
                      MainCubit.get(context).isDark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(5),
                    side: BorderSide(
                      color:
                          MainCubit.get(context).isDark
                              ? Colors.white
                              : Colors.grey.shade400,
                      width: .5,
                    ),
                  ),
                  onPressed: isLoading ? null : () => _showLinkDialog(context),
                  icon:
                      isLoading
                          ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : Icon(
                            Icons.link,
                            size: 16,
                            color:
                                MainCubit.get(context).isDark
                                    ? Colors.white
                                    : Colors.black,
                          ),
                  label: Text(
                    isArabic() ? 'ربط QR' : 'Link QR',
                    style: TextStyle(
                      color:
                          MainCubit.get(context).isDark
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(5),
                    side: BorderSide(
                      color:
                          MainCubit.get(context).isDark
                              ? Colors.white
                              : Colors.grey.shade400,
                      width: .5,
                    ),
                  ),
                  onPressed:
                      () => navigateToScreen(
                        context,
                        PetVaccinationPage(petModel: pet),
                      ),
                  child: Icon(
                    IconlyLight.notification,
                    size: 16,
                    color: ColorManager.primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(5),
                    side: BorderSide(
                      color:
                          MainCubit.get(context).isDark
                              ? Colors.white
                              : Colors.grey.shade400,
                      width: .5,
                    ),
                  ),
                  onPressed: () => _showDeleteConfirmation(context),
                  child: Icon(
                    IconlyLight.delete,
                    size: 16,
                    color: ColorManager.red,
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  void _showLinkDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => QrLinkDialog(pet: pet));
  }

  void _showDeleteConfirmation(BuildContext context) {
    showCustomConfirmationDialog(
      context: context,
      description:
          isArabic()
              ? Text.rich(
                TextSpan(
                  text: 'هل أنت متأكد أنك تريد حذف ',
                  children: [
                    TextSpan(
                      text: pet.petName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: '?'),
                  ],
                ),
              )
              : Text.rich(
                TextSpan(
                  text: 'Are you sure you want to delete ',
                  children: [
                    TextSpan(
                      text: pet.petName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: '?'),
                  ],
                ),
              ),
      imageUrl:
          'https://img.freepik.com/premium-vector/sad-dog_161669-74.jpg?size=626&ext=jpg&uid=R78903714&ga=GA1.2.131510781.1692744483&semt=ais',
      onConfirm: () async {
        Navigator.of(context).pop(true);
        await petCubit.deletePet(pet.petId.toString());
      },
    );
  }

  void _unlinkQr(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(isArabic() ? 'إلغاء ربط رمز QR' : 'Unlink QR Code'),
            content: Text(
              isArabic()
                  ? 'هل أنت متأكد من أنك تريد إلغاء ربط ${pet.petName} من رمز QR الخاص به؟'
                  : 'Are you sure you want to unlink ${pet.petName} from its QR code?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(isArabic() ? 'إلغاء' : 'Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<QrCubit>().unlinkPetFromQr(pet.petId);
                },
                child: Text(isArabic() ? 'إلغاء الربط' : 'Unlink'),
              ),
            ],
          ),
    );
  }

  Future<Uint8List> _capturePng() async {
    try {
      // انتظر لحد نهاية فريم الـ UI
      await Future.delayed(Duration(milliseconds: 100));
      RenderRepaintBoundary boundary = _qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary;

      if (boundary.debugNeedsPaint) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();
        return pngBytes;
      } else {
        throw Exception("Failed to convert image to ByteData.");
      }
    } catch (e) {
      print(e);
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

}
