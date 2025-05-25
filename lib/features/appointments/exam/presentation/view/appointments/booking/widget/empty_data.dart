import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';

import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/appointments/exam/domain/entities/appointment_entity.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/all_apointment.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/book_again_screen.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/rate_appointment.dart';
import 'package:squeak/features/appointments/exam/presentation/view/files_and_prescription_for_pet/files_for_pet_screen.dart';
import 'package:squeak/features/appointments/exam/presentation/view/files_and_prescription_for_pet/prescription_for_pet_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../supplier/get_supplier.dart';

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
          InkWell(
            onTap: () {
              navigateToScreen(
                context,
                MySupplierScreen(petSelectFromIcon: null),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                isArabic()
                    ? 'اختر العيادة الخاصة بك وحجز الإقامة الخاصة بك.'
                    : 'Pick your Clinic and book your Boarding.',
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
