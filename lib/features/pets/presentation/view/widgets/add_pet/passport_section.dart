import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import '../../../controller/pet_cubit.dart';

class PassportSection extends StatelessWidget {
  const PassportSection({super.key, required this.cubit, required this.isDark});

  final PetCubit cubit;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic() ? 'معلومات جواز السفر' : 'Passport Information',
          style: FontStyleThame.textStyle(
            context: context,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Passport Number Field
            Expanded(
              flex: 3,
              child: MyTextForm(
                controller: cubit.passportNumberController,
                prefixIcon: Icon(
                  Icons.card_membership,
                  size: 20,
                  color: isDark ? ColorManager.sWhite : ColorManager.black_87,
                ),
                enable: false,

                hintText:
                    isArabic()
                        ? 'ادخل رقم جواز السفر'
                        : 'Enter passport number',
                validatorText: null, // Optional fieldtest
                obscureText: false,
              ),
            ),
            const SizedBox(width: 12),
            // Passport Image
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () => _handlePassportImageTap(context),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          isDark
                              ? ColorManager.sWhite.withOpacity(0.3)
                              : ColorManager.black_87.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child:
                        cubit.passportImage != null ||
                                cubit
                                    .passportImageNameController
                                    .text
                                    .isNotEmpty
                            ? Icon(
                              Icons.image,
                              size: 24,
                              color: ColorManager.primaryColor,
                            )
                            : Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 24,
                              color:
                                  isDark
                                      ? ColorManager.sWhite.withOpacity(0.6)
                                      : ColorManager.black_87.withOpacity(0.6),
                            ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          isArabic()
              ? 'معلومات شريحة الدقيقة' : 'Microchip Information',
          style: FontStyleThame.textStyle(
            context: context,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        MyTextForm(
          controller: cubit.microchipNumberController,
          prefixIcon: Icon(
            Icons.sim_card_alert_outlined,
            size: 20,
            color: isDark ? ColorManager.sWhite : ColorManager.black_87,
          ),
          enable: false,

          hintText:
          isArabic()
              ? 'ادخل رقم الشريحة الدقيقة'
              : 'Enter Microchip Number',
          validatorText: null, // Optional fieldtest
          obscureText: false,
        ),
      ],
    );
  }

  void _handlePassportImageTap(BuildContext context) {
    if (cubit.passportImage != null ||
        cubit.passportImageNameController.text.isNotEmpty) {
      // Show image in dialog
      _showPassportImageDialog(context);
    } else {
      // Pick new image
      cubit.getPassportImage();
    }
  }

  void _showPassportImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isArabic() ? 'صورة جواز السفر' : 'Passport Image',
                      style: FontStyleThame.textStyle(
                        context: context,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                ),
                child:
                    cubit.passportImage != null
                        ? Image.file(cubit.passportImage!, fit: BoxFit.contain)
                        : cubit.passportImageNameController.text.isNotEmpty
                        ? Image.network(
                          imageUrl + cubit.passportImageNameController.text,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Column(
                              mainAxisSize:MainAxisSize.min,
                              children: [
                                Container(
                                  height: 200,
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(error.toString()),
                                )

                              ],
                            );
                          },
                        )
                        : Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        cubit.getPassportImage();
                      },
                      icon: const Icon(Icons.edit),
                      label: Text(isArabic() ? 'تغيير' : 'Change'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        cubit.removePassportImage();
                      },
                      icon: const Icon(Icons.delete),
                      label: Text(isArabic() ? 'حذف' : 'Remove'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
