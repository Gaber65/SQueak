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
        Text(
          isArabic() ? 'معلومات شريحة الدقيقة' : 'Microchip Information',
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
        const SizedBox(height: 12),
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
                Row(
                  children: [
                    // Passport Number Field
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Passport Number",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Input + Button in a row
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "Enter passport number (opt)",
                                    hintStyle: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                      horizontal: 12,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(
                                          0xFFBFD2FF,
                                        ), // light border
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(
                                          0xFF4A7CFF,
                                        ), // focus border
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 8),
                              // Passport Image
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () => _handlePassportImageTap(context),
                                  child: Container(
                                    height: 50,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color:
                                            isDark ? Colors.blue : Colors.blue,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      color: isDark ? Colors.blue : Colors.blue,
                                    ),

                                    child: Center(
                                      child:
                                          cubit.passportImage != null ||
                                                  cubit
                                                      .passportImageNameController
                                                      .text
                                                      .isNotEmpty
                                              ? Text(
                                                'Attach',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              )
                                              : Text(
                                                'Attach',
                                                style: TextStyle(
                                                  color: Colors.white,
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
