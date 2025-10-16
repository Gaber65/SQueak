import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:squeak/core/utils/export_path/export_files.dart';


Center emptyAppointment(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.network(
            'https://lottie.host/812196ca-692a-4bd1-8920-3bbffa763c4e/P24Orl2mFH.json',
            height: 300,
            repeat: false,
            width: double.infinity,
          ),
          InkWell(
            onTap: () {
              LayoutCubit.get(context).changeBottomNav(1);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                isArabic()
                    ? 'اختر العيادة الخاص بك واحجز موعدك.'
                    : 'Pick your Clinic and book your appointment.',
                textAlign: TextAlign.center,
                style: FontStyleThame.textStyle(
                  context: context,
                  fontColor: ColorManager.secondColor,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Center emptyBoarding(BuildContext context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.network(
            'https://lottie.host/65a42f6a-c6f4-45dd-80c8-6a42f2c40fb3/ymXRXnl1jB.json',
            height: 300,
            repeat: false,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              isArabic()
                  ? 'لا توجد أي إقامات مُسجّلة حتى الآن'
                  : 'No boarding records available yet.',
              textAlign: TextAlign.center,
              style: FontStyleThame.textStyle(
                context: context,
                fontWeight: FontWeight.bold,
                fontColor: ColorManager.secondColor,
              ),
            ),
          ),
          Text(
            !isArabic()
                ? 'When your pet is checked into a boarding service at one of your followed clinics, the details will appear here automatically'
                : 'عند تسجيل صديقك الأليف في إقامة من خلال إحدى العيادات التي تتابعها، ستظهر تفاصيلها هنا تلقائيًا.',
            textAlign: TextAlign.center,
            style: FontStyleThame.textStyle(
              context: context,
              fontColor: ColorManager.secondColor,
            ),
          ),

        ],
      ),
    ),
  );
}
