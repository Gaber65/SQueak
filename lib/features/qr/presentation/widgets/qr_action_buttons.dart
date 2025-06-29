
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/qr/presentation/widgets/qr_save.dart';
import 'package:squeak/features/qr/presentation/widgets/qr_unlink_dialog.dart';
import '../../../pets/presentation/view/widgets/get_pet/action_button.dart';
import '../../../vaccination/presentation/pages/pet_vaccination_page.dart';
import '../controller/qr_cubit.dart';
import '../../../pets/domain/entities/pet_entity.dart';
import 'qr_link_dialog.dart';

class QrActionButtons extends StatelessWidget {
  final PetEntities pet;
  final PetCubit petCubit;
  final QrCubit c;
  const QrActionButtons({
    super.key,
    required this.pet,
    required this.petCubit,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QrCubit, QrState>(
      listener: (context, state) {

      },
      builder: (context, state) {
        final isLinked = pet.qrCodeId != null;

        if (isLinked) {
          return Row(
            children: [
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
                  onPressed:
                      () => navigateToScreen(context, QrSave(qrData: pet.qrCode!, isDarkMode: MainCubit.get(context).isDark,)),
                  icon: Icon(
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
                  onPressed: () => _unlinkQr(context, c),

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
                  onPressed: () => _showLinkDialog(context, c),
                  icon: Icon(
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

  void _showLinkDialog(BuildContext context,QrCubit c) {
    showDialog(context: context, builder: (context) => QrLinkDialog(pet: pet,cubit: c,isDarkMode: MainCubit.get(context).isDark,));
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

  void _unlinkQr(BuildContext context, QrCubit c) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: MainCubit.get(context).isDark ? Colors.black87 : Colors.black54,
      builder: (context) => QrUnlinkDialog(
        pet: pet,
        cubit: c,
        isDarkMode: MainCubit.get(context).isDark,
      ),
    );
  }




}
