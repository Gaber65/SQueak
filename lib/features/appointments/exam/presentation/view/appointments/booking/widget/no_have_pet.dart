// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:squeak/features/pets/presentation/view/pet_screen.dart';
import '../../../../../../../../core/utils/export_path/export_files.dart';

class NoHavePetAlert extends StatelessWidget {
  const NoHavePetAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            MainCubit.get(context).isDark
                ? ColorManager.sBaseDarkColor
                : ColorManager.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top banner
          Container(
            height: 20,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorManager.primaryColor,
                  ColorManager.primaryColor.withOpacity(0.5),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),

          // Alert content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: ColorManager.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child:  SvgPicture.asset(
                        'assets/no_hav_pet.svg',
                        semanticsLabel: 'Dart Logo',

                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      isArabic() ? 'لا يوجد صديق أليفة' : 'No Pets Found',
                      style: FontStyleThame.textStyle(
                        context: context,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  isArabic()
                      ? 'لاحظنا عدم تسجيل أي أليفة لديك بعد. ستحتاج إلى إضافة أليف واحد على الأقل قبل إكمال حجز موعدك.'
                      : "We noticed you don't have any pets registered yet. You'll need to add at least one pet before you can complete your appointment booking.",
                  style: FontStyleThame.textStyle(
                    context: context,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: () {
                    navigateAndFinish(context, PetScreen());
                  },
                  icon: const Icon(Icons.pets, size: 18),
                  label: Text(isArabic() ? 'اضافة أليف' : "Add Pet"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ColorManager.primaryColor,
                    side: const BorderSide(color: ColorManager.primaryBorder),
                    backgroundColor: ColorManager.primaryLight,
                  ),
                ),
              ],
            ),
          ),

          // Bottom tip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color:
                  MainCubit.get(context).isDark
                      ? ColorManager.sBaseDarkColor
                      : ColorManager.primaryLight,
              border: Border(
                top: BorderSide(color: ColorManager.primaryBorder),
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.pets, size: 16, color: ColorManager.primaryColor),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isArabic()
                        ? 'إن إضافة أليف لا يستغرق سوى دقيقة واحدة ويساعدنا في تقديم رعاية أفضل أثناء المواعيد.'
                        : 'Adding a pet only takes a minute and helps us provide better care during appointments.',
                    style: FontStyleThame.textStyle(
                      context: context,
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      fontColor: ColorManager.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
