// ignore_for_file: deprecated_member_use, invalid_use_of_protected_member

import 'package:squeak/core/service/global_widget/image_detail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/appointments/exam/domain/entities/appointment_entity.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/book_again_screen.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/rate_appointment.dart';
import 'package:squeak/features/appointments/exam/presentation/view/files_and_prescription_for_pet/files_for_pet_screen.dart';
import 'package:squeak/features/appointments/exam/presentation/view/files_and_prescription_for_pet/prescription_for_pet_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../core/utils/enums/day_of_week_enum.dart';
import '../../controller/user/user_appointment_cubit.dart';

Widget buildItem(
  AppointmentEntity appointments,
  BuildContext context,
  UserAppointmentCubit cubit,
  int index,
) {
  // Make the card height responsive to screen size but constrained
  final double cardHeight =
      (MediaQuery.of(context).size.height * 0.28)
          .clamp(220.0, 360.0)
          .toDouble();

  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: SizedBox(
      height: cardHeight,
      child: Container(
        width: double.infinity,
        decoration: Decorations.kDecorationBoxShadow(context: context),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// data
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(14),
                  topStart: Radius.circular(14),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle all appointment states
                    _buildStatusRow(appointments, context, cubit),
                    const SizedBox(height: 3),
                    if (appointments.status == 3 &&
                        appointments.doctorServiceRate != 0)
                      Center(
                        child: Row(
                          children: [
                            Text(
                              isArabic() ? 'تقييم الطبيب' : 'Doctor rating : ',
                              style: FontStyleThame.textStyle(
                                context: context,
                                fontSize: 13,
                              ),
                            ),
                            Row(
                              children: List.generate(
                                5,
                                (index) =>
                                    index < appointments.doctorServiceRate
                                        ? const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 18,
                                        )
                                        : const Icon(
                                          Icons.star_border,
                                          color: Colors.amber,
                                          size: 18,
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            /// image + name
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 6.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: SafeFastCachedImageProviderExtension.safe(ConfigModel.serverFirstHalfOfImageUrl +
                          (appointments.clinicLogo ?? ''),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointments.clinicName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: FontStyleThame.textStyle(
                            context: context,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 4),

                        Text(
                          appointments.pet.name!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: FontStyleThame.textStyle(
                            context: context,
                            fontSize: 15,
                          ),
                        ),
                        if (appointments.status == 3) ...[
                          SizedBox(height: 3),
                          _buildVitalsSection(appointments, context),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      if (appointments.clinicLocation.isEmpty) {
                        infoToast(
                          context,
                          isArabic()
                              ? 'الموقع مفقود، يرجى مطالبة المشرف بإضافة موقعه'
                              : 'the location is missing , please ask the admin to add his location',
                        );
                      } else {
                        launchUrl((Uri.parse(appointments.clinicLocation)));
                      }
                    },
                    child: SafeFastCachedImageExtension.safe(
                      url:
                          'https://firebasestorage.googleapis.com/v0/b/educational-platform-1e5d7.appspot.com/o/google-maps.png?alt=media&token=17b77d3f-92a8-4339-bc65-80cf49dff79e',
                      height: 20,
                      width: 20,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ),

            /// bottom row - constrained and responsive buttons
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: _buildActionButtons(appointments, context, cubit),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildStatusRow(
  AppointmentEntity appointments,
  BuildContext context,
  UserAppointmentCubit cubit,
) {
  switch (appointments.status) {
    case 0: // Reserved
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: MainCubit.get(context).isDark ? 8 : 7,
            backgroundColor:
                MainCubit.get(context).isDark
                    ? ColorManager.getAppointmentWhite
                    : null,
            child: CircleAvatar(
              radius: MainCubit.get(context).isDark ? 5 : 7,
              backgroundColor: Colors.blue,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            S.of(context).appointmentReserved,
            style:
                MainCubit.get(context).isDark
                    ? GoogleFonts.readexPro().copyWith(
                      color: ColorManager.sWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    )
                    : GoogleFonts.readexPro().copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
          ),
          SizedBox(width: 10),
          Text(' ${formatDateString(appointments.date)} , ', maxLines: 2),
          Text(formatTimeToAmPm(appointments.time)),
        ],
      );

    case 1: // Start_Examination
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(radius: 7, backgroundColor: Colors.orange[600]),
          const SizedBox(width: 5),
          Text(
            isArabic() ? 'بدء الفحص' : 'Examination Started',
            style: GoogleFonts.readexPro().copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.orange[600],
            ),
          ),
          SizedBox(width: 10),
          Text(' ${formatDateString(appointments.date)}  ,  ', maxLines: 2),
          Text(formatTimeToAmPm(appointments.time)),
        ],
      );

    case 2: // End_Examination
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(radius: 7, backgroundColor: Colors.purple[600]),
              const SizedBox(width: 5),
              Text(
                isArabic() ? 'انتهاء الفحص' : 'Examination Ended',
                style: GoogleFonts.readexPro().copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.purple[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          Row(
            children: [
              Text(' ${formatDateString(appointments.date)} , ', maxLines: 2),
              Text(formatTimeToAmPm(appointments.time)),
            ],
          ),
        ],
      );

    case 3: // Finished
      return Column(
        children: [
          Row(
            children: [
              CircleAvatar(radius: 7, backgroundColor: Colors.green[600]),
              const SizedBox(width: 5),
              Text(
                S.of(context).appointmentDone,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 8),
              Text(' ${formatDateString(appointments.date)}  ,  ', maxLines: 2),
              Text(formatTimeToAmPm(appointments.time)),
              Spacer(),
              _buildEnhancedMenu(
                context,
                appointments,
                appointments.status,
                cubit,
              ),
            ],
          ),
        ],
      );

    case 4: // Attended
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(radius: 7, backgroundColor: Colors.teal[600]),
              const SizedBox(width: 5),
              Text(
                isArabic() ? 'حضر' : 'Attended',
                style: GoogleFonts.readexPro().copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.teal[600],
                ),
              ),
              SizedBox(width: 10),
              Text(' ${formatDateString(appointments.date)}  ,  ', maxLines: 2),
              Text(formatTimeToAmPm(appointments.time)),
            ],
          ),
        ],
      );

    case 5: // Cancel
      return Row(
        children: [
          CircleAvatar(radius: 7, backgroundColor: Colors.red[400]),
          const SizedBox(width: 5),
          Text(
            S.of(context).appointmentCanceled,
            style: GoogleFonts.readexPro().copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.red[400],
            ),
          ),
          SizedBox(width: 10),
          Text(' ${formatDateString(appointments.date)}  ,  ', maxLines: 2),
          Text(formatTimeToAmPm(appointments.time)),
        ],
      );

    default:
      return Row(
        children: [
          CircleAvatar(radius: 7, backgroundColor: Colors.grey[400]),
          const SizedBox(width: 5),
          Text(
            isArabic() ? 'غير معروف' : 'Unknown Status',
            style: GoogleFonts.readexPro().copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(width: 10),
          Text(' ${formatDateString(appointments.date)}  ,  ', maxLines: 2),
          Text(formatTimeToAmPm(appointments.time)),
        ],
      );
  }
}

List<Widget> _buildActionButtons(
  AppointmentEntity appointments,
  BuildContext context,
  UserAppointmentCubit cubit,
) {
  List<Widget> buttons = [];

  // Helper to create buttons with fixed height but flexible width
  Widget buttonWrapper({required Widget child}) {
    return Flexible(
      fit: FlexFit.tight,
      child: SizedBox(height: 44, child: child),
    );
  }

  // First button - Edit/Book Again based on status
  buttons.add(
    buttonWrapper(
      child: ElevatedButton(
        onPressed: () {
          if (appointments.status == 0) {
            // Reserved - Show edit dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(S.of(context).appointmentModalTitle),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "${S.of(context).appointmentModalDescription} ",
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                            TextSpan(
                              text: appointments.pet.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            TextSpan(
                              text:
                                  " ${isArabic() ? "و" : "and"} ${S.of(context).appointmentButtonBooking} ",
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                       CircleAvatar(
                        backgroundImage: SafeFastCachedImageProviderExtension.safe('https://img.freepik.com/free-vector/emotional-support-animal-concept-illustration_114360-19462.jpg?w=740&t=st=1693530236~exp=1693530836~hmac=754f0eea1ad76b4cfe66e8f471927ff6d1d2c6625ff14e6cb2c81aa69ab9fc90',),
                        radius: 75,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: ElevatedButton(
                        onPressed: () async {
                          // ignore: invalid_use_of_visible_for_testing_member
                          cubit.emit(EditAppointment(appointments));
                          Navigator.of(context).pop(false);
                          cubit.findClinic(
                            cubit.suppliers!.data,
                            appointments.clinicCode,
                            appointments.clinicId,
                          );
                          navigateToScreen(
                            context,
                            BooKAgainScreen(
                              clinicCode: appointments.clinicCode,
                              petId: appointments.petId,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.red,
                          backgroundColor:
                              MainCubit.get(context).isDark
                                  ? ColorManager.myPetsBaseBlackColor
                                  : Colors.red.shade100.withOpacity(.4),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(S.of(context).appointmentModalButtonYes),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.green,
                          backgroundColor:
                              MainCubit.get(context).isDark
                                  ? ColorManager.myPetsBaseBlackColor
                                  : Colors.green.shade100.withOpacity(.4),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(S.of(context).appointmentModalButtonNo),
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            // Other statuses - Book again
            cubit.findClinic(
              cubit.suppliers!.data,
              appointments.clinicCode,
              appointments.clinicId,
            );
            navigateToScreen(
              context,
              BooKAgainScreen(
                clinicCode: appointments.clinicCode,
                petId: appointments.petId,
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.green,
          backgroundColor:
              MainCubit.get(context).isDark
                  ? ColorManager.myPetsBaseBlackColor
                  : Colors.green.shade100.withOpacity(.4),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size.fromHeight(44),
        ),
        child: Text(_getFirstButtonText(appointments.status, context)),
      ),
    ),
  );

  buttons.add(const SizedBox(width: 8));

  // Call button - Always present
  buttons.add(
    buttonWrapper(
      child: ElevatedButton(
        onPressed: () {
          final phone = appointments.clinicPhone;
          final formattedPhone = phone.startsWith('0') ? phone : '0$phone';
          launchUrl(Uri.parse('tel:$formattedPhone'));
          // launchUrl(Uri.parse('tel:0${appointments.clinicPhone}'));
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.blue,
          backgroundColor:
              MainCubit.get(context).isDark
                  ? ColorManager.myPetsBaseBlackColor
                  : Colors.blue.shade100.withOpacity(.4),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size.fromHeight(44),
        ),
        child: Text(S.of(context).appointmentButtonCall),
      ),
    ),
  );

  // Cancel button - Only for reserved appointments
  if (appointments.status == 0) {
    buttons.add(const SizedBox(width: 8));
    buttons.add(
      buttonWrapper(
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(S.of(context).appointmentModalTitle),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "${S.of(context).appointmentModalDescription} ",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextSpan(
                              text: appointments.pet.name,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                       CircleAvatar(
                        backgroundImage: SafeFastCachedImageProviderExtension.safe('https://img.freepik.com/free-vector/emotional-support-animal-concept-illustration_114360-19462.jpg?w=740&t=st=1693530236~exp=1693530836~hmac=754f0eea1ad76b4cfe66e8f471927ff6d1d2c6625ff14e6cb2c81aa69ab9fc90',),
                        radius: 75,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: ElevatedButton(
                        onPressed: () async {
                          cubit.deleteAppointments(appointments.id);
                          Navigator.of(context).pop(true);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.red,
                          backgroundColor:
                              MainCubit.get(context).isDark
                                  ? ColorManager.myPetsBaseBlackColor
                                  : Colors.red.shade100.withOpacity(.4),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(S.of(context).appointmentModalButtonYes),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.green,
                          backgroundColor:
                              MainCubit.get(context).isDark
                                  ? ColorManager.myPetsBaseBlackColor
                                  : Colors.green.shade100.withOpacity(.4),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(S.of(context).appointmentModalButtonNo),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.red,
            backgroundColor:
                MainCubit.get(context).isDark
                    ? ColorManager.myPetsBaseBlackColor
                    : Colors.red.shade100.withOpacity(.4),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size.fromHeight(44),
          ),
          child: Text(S.of(context).appointmentButtonCancel),
        ),
      ),
    );
  }

  return buttons;
}

String _getFirstButtonText(int? status, BuildContext context) {
  switch (status) {
    case 0: // Reserved
      return S.of(context).appointmentButtonEdit;
    case 1: // Start_Examination
      return isArabic() ? 'في الفحص' : 'In Examination';
    case 2: // End_Examination
      return isArabic() ? 'انتهى الفحص' : 'Examination Done';
    case 3: // Finished
      return S.of(context).appointmentButtonBooking;
    case 4: // Attended
      return isArabic() ? 'حجز مرة أخرى' : 'Book Again';
    case 5: // Cancel
      return S.of(context).appointmentButtonBooking;
    default:
      return S.of(context).appointmentButtonBooking;
  }
}

Widget _buildEnhancedMenu(
  context,
  appointment,
  appointmentState,
  UserAppointmentCubit cubit,
) {
  return Container(
    decoration: BoxDecoration(
      color:
          MainCubit.get(context).isDark ? Colors.grey.shade800 : Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color:
            MainCubit.get(context).isDark
                ? Colors.grey.shade700
                : Colors.grey.shade200,
      ),
    ),
    child: PopupMenuButton<int>(
      padding: EdgeInsets.zero,
      icon: Icon(
        Icons.more_vert_rounded,
        color:
            MainCubit.get(context).isDark
                ? Colors.grey.shade400
                : Colors.grey.shade600,
        size: 20,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color:
          MainCubit.get(context).isDark ? Colors.grey.shade800 : Colors.white,
      elevation: 8,
      offset: const Offset(0, 40),
      itemBuilder:
          (context) =>
              _buildMenuItems(appointment, appointmentState, context, cubit),
    ),
  );
}

List<PopupMenuEntry<int>> _buildMenuItems(
  appointment,
  appointmentState,
  BuildContext context,
  UserAppointmentCubit cubit,
) {


  List<PopupMenuEntry<int>> items = [];

  if (appointment.visitId != null && appointment.isBillSqueakVisible) {
    items.add(
      _buildMenuItem(
        1,
        'Bill',
        'الفاتورة',
        Icons.receipt_long_rounded,
        Colors.blue,
        context,
        appointment,
        cubit,
      ),
    );
  }

  if (appointmentState == AppointmentState.Finished.index) {
    items.addAll([
      _buildMenuItem(
        2,
        'Rate',
        'التقييم',
        Icons.star_rounded,
        Colors.amber,
        context,
        appointment,
        cubit,
      ),
      _buildMenuItem(
        3,
        'Prescription',
        'الروشتة',
        Icons.medical_services_rounded,
        Colors.green,
        context,
        appointment,
        cubit,
      ),
      _buildMenuItem(
        4,
        'Files',
        'الملفات',
        Icons.folder_rounded,
        Colors.orange,
        context,
        appointment,
        cubit,
      ),
    ]);
  }

  return items;
}

Widget _buildVitalsSection(appointment, context) {
  return Wrap(
    spacing: 8.0,
    runSpacing: 4.0,
    children: [
      _buildVitalItem(
        'Temp',
        '${appointment.temperature}°C',
        Icons.thermostat_rounded,
        Colors.red,
        context,
      ),
      _buildVitalItem(
        'Weight',
        '${appointment.weight} kg',
        Icons.monitor_weight_rounded,
        Colors.blue,
        context,
      ),
    ],
  );
}

Widget _buildVitalItem(
  String label,
  String value,
  IconData icon,
  Color color,
  context,
) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 14, color: color),
      const SizedBox(width: 4),
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color:
                  MainCubit.get(context).isDark
                      ? Colors.grey.shade400
                      : Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color:
                  MainCubit.get(context).isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ],
  );
}

PopupMenuItem<int> _buildMenuItem(
  int value,
  String englishText,
  String arabicText,
  IconData icon,
  Color color,
  BuildContext context,
  appointment,
  UserAppointmentCubit cubit,
) {
  return PopupMenuItem(
    value: value,
    onTap: () => _handleMenuAction(value, cubit, context, appointment),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isArabic() ? arabicText : englishText,
              style: TextStyle(
                color:
                    MainCubit.get(context).isDark
                        ? Colors.white
                        : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

void _handleMenuAction(
  int value,
  UserAppointmentCubit cubit,
  context,
  appointment,
) {
  switch (value) {
    case 1:
      cubit.printReceipt(appointment, context);
      break;
    case 2:
      navigateToScreen(context, RateAppointment(model: appointment));
      break;
    case 3:
      navigateToScreen(
        context,
        PrescriptionForPetScreen(reservationid: appointment.postId),
      );
      break;
    case 4:
      navigateToScreen(
        context,
        FilesForPetScreen(reservationid: appointment.postId),
      );
      break;
  }
}
