// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        // Microchip Information Section
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(FontAwesomeIcons.microchip, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      isArabic()
                          ? 'معلومات شريحة الدقيقة'
                          : 'Microchip Information',
                      style: FontStyleThame.textStyle(
                        context: context,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  isArabic() ? 'رقم الشريحة الدقيقة' : 'Microchip Number',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
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
                  validatorText: null,
                  obscureText: false,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Passport Information Section
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.passport,
                      color: Colors.blue,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      isArabic()
                          ? 'معلومات جواز السفر'
                          : 'Passport Information',
                      style: FontStyleThame.textStyle(
                        context: context,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  isArabic() ? 'رقم جواز السفر' : 'Passport Number',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: MyTextForm(
                        controller: cubit.passportNumberController,
                        prefixIcon: Icon(
                          Icons.card_membership,
                          size: 20,
                          color:
                              isDark
                                  ? ColorManager.sWhite
                                  : ColorManager.black_87,
                        ),
                        enable: false,
                        hintText:
                            isArabic()
                                ? 'ادخل رقم جواز السفر'
                                : 'Enter passport number',
                        validatorText: null,
                        obscureText: false,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () => _handlePassportImageTap(context),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.blue,
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
                                      color: Colors.white,
                                    )
                                    : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                         crossAxisAlignment: CrossAxisAlignment.center,   
                                        children: [
                                          Flexible(
                                            child: Text(
                                              isArabic() ? 'أرفق' : 'Attach',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12, // Reduced font size to fit better
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(width: 4), // Reduced spacing
                                          Icon(
                                            Icons.attach_file,
                                            size: 16, // Reduced icon size
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _handlePassportImageTap(BuildContext context) {
    if (cubit.passportImage != null ||
        cubit.passportImageNameController.text.isNotEmpty) {
      _showPassportImageDialog(context);
    } else {
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
                              mainAxisSize: MainAxisSize.min,
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
                                ),
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
