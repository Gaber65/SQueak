import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import '../../../pets/presentation/view/widgets/get_pet/action_button.dart';
import '../../../vaccination/presentation/pages/pet_vaccination_page.dart';
import '../controller/qr_cubit.dart';
import '../../../pets/domain/entities/pet_entity.dart';
import 'qr_link_dialog.dart';

class QrActionButtons extends StatelessWidget {
  final PetEntities pet;
  final PetCubit petCubit;
  const QrActionButtons({super.key, required this.pet, required this.petCubit});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QrCubit, QrState>(
      listener: (context, state) {
        if (state is QrLinkSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is QrUnlinkSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is QrDownloadSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is QrError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final qrCubit = context.read<QrCubit>();
        final isLinked = qrCubit.isPetLinkedToQr(pet.petId);
        final isLoading = state is QrLoading;

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
                  onPressed: isLoading ? null : () => _downloadQr(context),
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
                    color: MainCubit.get(context).isDark ? Colors.white : Colors.black,
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

  void _downloadQr(BuildContext context) {
    context.read<QrCubit>().downloadQrCode(pet.petId, pet.petName);
  }
}
