import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import 'package:squeak/features/appointments/models/get_appointment_model.dart';
import 'package:squeak/features/appointments/view/appointments/book_again_screen.dart';
import 'package:squeak/features/appointments/view/appointments/rate_appointment.dart';
import 'package:squeak/features/layout/controller/layout_cubit.dart';
import 'package:squeak/features/layout/layout.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../generated/l10n.dart';
import '../../../pets/models/pet_model.dart';
import '../../controller/user/user_appointment_cubit.dart';
import '../component/filter_component.dart';
import '../files_and_prescription_for_pet/files_for_pet_screen.dart';
import '../files_and_prescription_for_pet/prescription_for_pet_screen.dart';

class AllAppointment extends StatelessWidget {
  const AllAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  UserAppointmentCubit()
                    ..getSupplier()
                    ..getAppointment(false),
        ),
        BlocProvider(create: (context) => LayoutCubit()..getOwnerPet()),
      ],
      child: BlocConsumer<UserAppointmentCubit, UserAppointmentState>(
        listener: (context, state) {
          if (state is DeleteAppointmentSuccess) {
            UserAppointmentCubit.get(context).getAppointment(false);
          }
          if (state is EditAppointment) {
            UserAppointmentCubit.get(context).deleteAppointments(state.model);
          }
        },
        builder: (context, state) {
          var cubit = UserAppointmentCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              title: Text(isArabic() ? "كل مواعيدك" : "All your appointments"),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Row(
                  children: [
                    Expanded(
                      child: BlocConsumer<LayoutCubit, LayoutState>(
                        builder: (context, state) {
                          List<PetsData> pets = LayoutCubit.get(context).pets;
                          return buildPetFilter(context, pets);
                        },
                        listener: (context, state) {},
                      ),
                    ),
                    Expanded(
                      child: BlocConsumer<LayoutCubit, LayoutState>(
                        builder: (context, state) {
                          return buildStateFilter(context);
                        },
                        listener: (context, state) {},
                      ),
                    ),
                    if (state is AppointmentFiltered)
                      IconButton(
                        icon: Icon(Icons.clear), // Clear icon
                        onPressed: () {
                          UserAppointmentCubit.get(context).clearFilters();
                        },
                      ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: ColorManager.primaryColor,
              onPressed: () {
                LayoutCubit.get(context).changeBottomNav(1);

                navigateAndFinish(context, LayoutScreen());
              },
              child: const Icon(IconlyLight.calendar, color: Colors.white),
            ),
            body:
                cubit.appointments.isEmpty
                    ? emptyAppointment(context)
                    : (state is AppointmentFiltered)
                    ? ListView.builder(
                      itemBuilder: (context, index) {
                        return buildItem(
                          state.appointments[index],
                          context,
                          cubit,
                          index,
                        );
                      },
                      itemCount: state.appointments.length,
                      physics: const BouncingScrollPhysics(),
                    )
                    : RefreshIndicator(
                      onRefresh: () async {
                        await UserAppointmentCubit.get(
                          context,
                        ).getAppointment(false);
                      },
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return buildItem(
                            cubit.appointments[index],
                            context,
                            cubit,
                            index,
                          );
                        },
                        itemCount: cubit.appointments.length,
                        physics: const BouncingScrollPhysics(),
                      ),
                    ),
          );
        },
      ),
    );
  }

  Widget buildItem(
    AppointmentModel appointments,
    BuildContext context,
    UserAppointmentCubit cubit,
    int index,
  ) {
    print(appointments.statues);
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: double.infinity,
        decoration: Decorations.kDecorationBoxShadow(context: context),
        child: Column(
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
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // reserved status
                    if (appointments.statues == 0)
                      Row(
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
                              backgroundColor: Colors.black,
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
                          Text(
                            ' ${formatDateString(appointments.date)}  ,  ',
                            maxLines: 2,
                          ),
                          Text(formatTimeToAmPm(appointments.time)),
                          SizedBox(width: 10),
                          if (appointments.isPrint)
                            const CircularProgressIndicator(),
                          if (appointments.statues == 3)
                            if (!appointments.isPrint)
                              PopupMenuButton<int>(
                                padding: EdgeInsets.zero,
                                onCanceled: () {
                                  Navigator.of(context);
                                },
                                itemBuilder: (context) {
                                  return [
                                    if (appointments.visitId != null &&
                                        appointments.isBillSqueakVisible)
                                      PopupMenuItem(
                                        value: 1,
                                        onTap: () {
                                          cubit.printReceipt(
                                            appointments,
                                            context,
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            isArabic()
                                                ? Text('الفاتورة')
                                                : Text('Bill'),
                                            Spacer(),
                                            Icon(
                                              Icons.receipt_long_sharp,
                                              color: Color(0xff6096ba),
                                            ),
                                          ],
                                        ),
                                      ),
                                    PopupMenuItem(
                                      value: 2,
                                      onTap: () {
                                        navigateToScreen(
                                          context,
                                          RateAppointment(
                                            model: appointments,
                                            isNav: true,
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          isArabic()
                                              ? Text("التقييم")
                                              : Text('Rate'),
                                          Spacer(),
                                          Icon(
                                            Icons.star_border_purple500,
                                            color: Colors.amber,
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 3,
                                      onTap: () {
                                        navigateToScreen(
                                          context,
                                          PrescriptionForPetScreen(
                                            reservationid: appointments.id,
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          isArabic()
                                              ? Text("الروشتة")
                                              : Text("Prescription"),
                                          Spacer(),
                                          Icon(
                                            Icons.add_box_rounded,
                                            color: Colors.amber,
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 4,
                                      onTap: () {
                                        navigateToScreen(
                                          context,
                                          FilesForPetScreen(
                                            reservationid: appointments.id,
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          isArabic()
                                              ? Text("الملفات")
                                              : Text("Files"),
                                          Spacer(),
                                          Icon(
                                            Icons.file_copy_rounded,
                                            color: Colors.amber,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ];
                                },
                                icon: const Icon(Icons.more_vert_outlined),
                                offset: const Offset(0, 20),
                              ),
                        ],
                      )
                    // canceled status
                    else if (appointments.statues == 5)
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 7,
                            backgroundColor: Colors.red[400],
                          ),
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
                          Text(
                            ' ${formatDateString(appointments.date)}  ,  ',
                            maxLines: 2,
                          ),
                          Text(formatTimeToAmPm(appointments.time)),
                          SizedBox(width: 10),
                          if (appointments.isPrint)
                            const CircularProgressIndicator(),
                          if (appointments.statues == 3)
                            if (!appointments.isPrint)
                              PopupMenuButton<int>(
                                padding: EdgeInsets.zero,
                                onCanceled: () {
                                  Navigator.of(context);
                                },
                                itemBuilder: (context) {
                                  return [
                                    if (appointments.visitId != null &&
                                        appointments.isBillSqueakVisible)
                                      PopupMenuItem(
                                        value: 1,
                                        onTap: () {
                                          cubit.printReceipt(
                                            appointments,
                                            context,
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            isArabic()
                                                ? Text('الفاتورة')
                                                : Text('Bill'),
                                            Spacer(),
                                            Icon(
                                              Icons.receipt_long_sharp,
                                              color: Color(0xff6096ba),
                                            ),
                                          ],
                                        ),
                                      ),
                                    PopupMenuItem(
                                      value: 2,
                                      onTap: () {
                                        navigateToScreen(
                                          context,
                                          RateAppointment(
                                            isNav: true,
                                            model: appointments,
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          isArabic()
                                              ? Text("التقييم")
                                              : Text('Rate'),
                                          Spacer(),
                                          Icon(
                                            Icons.star_border_purple500,
                                            color: Colors.amber,
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 3,
                                      onTap: () {
                                        navigateToScreen(
                                          context,
                                          PrescriptionForPetScreen(
                                            reservationid: appointments.id,
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          isArabic()
                                              ? Text("الروشتة")
                                              : Text("Prescription"),
                                          Spacer(),
                                          Icon(
                                            Icons.add_box_rounded,
                                            color: Colors.amber,
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 4,
                                      onTap: () {
                                        navigateToScreen(
                                          context,
                                          FilesForPetScreen(
                                            reservationid: appointments.id,
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          isArabic()
                                              ? Text("الملفات")
                                              : Text("Files"),
                                          Spacer(),
                                          Icon(
                                            Icons.file_copy_rounded,
                                            color: Colors.amber,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ];
                                },
                                icon: const Icon(Icons.more_vert_outlined),
                                offset: const Offset(0, 20),
                              ),
                        ],
                      )
                    // done status
                    else if (appointments.statues == 3)
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 7,
                            backgroundColor: Colors.green[600],
                          ),
                          const SizedBox(width: 5),
                          Text(S.of(context).appointmentDone),
                          Spacer(),
                          Text(
                            ' ${formatDateString(appointments.date)}  ,  ',
                            maxLines: 2,
                          ),
                          Text(formatTimeToAmPm(appointments.time)),
                          Spacer(),
                          if (appointments.isPrint)
                            const CircularProgressIndicator(),
                          if (appointments.statues == 3)
                            if (!appointments.isPrint)
                              PopupMenuButton<int>(
                                padding: EdgeInsets.zero,
                                onCanceled: () {
                                  Navigator.of(context);
                                },
                                itemBuilder: (context) {
                                  return [
                                    if (appointments.visitId != null &&
                                        appointments.isBillSqueakVisible)
                                      PopupMenuItem(
                                        value: 1,
                                        onTap: () {
                                          cubit.printReceipt(
                                            appointments,
                                            context,
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            isArabic()
                                                ? Text('الفاتورة')
                                                : Text('Bill'),
                                            Spacer(),
                                            Icon(
                                              Icons.receipt_long_sharp,
                                              color: Color(0xff6096ba),
                                            ),
                                          ],
                                        ),
                                      ),
                                    PopupMenuItem(
                                      value: 2,
                                      onTap: () {
                                        navigateToScreen(
                                          context,
                                          RateAppointment(
                                            isNav: true,
                                            model: appointments,
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          isArabic()
                                              ? Text("التقييم")
                                              : Text('Rate'),
                                          Spacer(),
                                          Icon(
                                            Icons.star_border_purple500,
                                            color: Colors.amber,
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 3,
                                      onTap: () {
                                        navigateToScreen(
                                          context,
                                          PrescriptionForPetScreen(
                                            reservationid: appointments.id,
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          isArabic()
                                              ? Text("الروشتة")
                                              : Text("Prescription"),
                                          Spacer(),
                                          Icon(
                                            Icons.add_box_rounded,
                                            color: Colors.amber,
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 4,
                                      onTap: () {
                                        navigateToScreen(
                                          context,
                                          FilesForPetScreen(
                                            reservationid: appointments.id,
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          isArabic()
                                              ? Text("الملفات")
                                              : Text("Files"),
                                          Spacer(),
                                          Icon(
                                            Icons.file_copy_rounded,
                                            color: Colors.amber,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ];
                                },
                                icon: const Icon(Icons.more_vert_outlined),
                                offset: const Offset(0, 20),
                              ),
                        ],
                      ),
                    const SizedBox(height: 5),

                    if (appointments.statues == 3 &&
                        appointments.doctorServiceRate != 0)
                      Center(
                        child: Row(
                          children: [
                            Text(
                              isArabic() ? 'تقييم الطبيب' : 'Doctor rating : ',
                              style: FontStyleThame.textStyle(
                                context: context,
                                fontSize: 14,
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
                                        )
                                        : const Icon(
                                          Icons.star_border,
                                          color: Colors.amber,
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
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      ConfigModel.serverFirstHalfOfImageUrl +
                          (appointments.clinicLogo ?? ''),
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          appointments.pet.name!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: FontStyleThame.textStyle(
                            context: context,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(height: 7),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          appointments.clinicName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: FontStyleThame.textStyle(
                            context: context,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
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
                    child: FastCachedImage(
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

            /// bottom row
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (appointments.statues == 0) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  S.of(context).appointmentModalTitle,
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                "${S.of(context).appointmentModalDescription} ",
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                            ),
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
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        'https://img.freepik.com/free-vector/emotional-support-animal-concept-illustration_114360-19462.jpg?w=740&t=st=1693530236~exp=1693530836~hmac=754f0eea1ad76b4cfe66e8f471927ff6d1d2c6625ff14e6cb2c81aa69ab9fc90',
                                      ),
                                      radius: 75,
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        cubit.emit(
                                          EditAppointment(appointments),
                                        );

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
                                                ? ColorManager
                                                    .myPetsBaseBlackColor
                                                : Colors.red.shade100
                                                    .withOpacity(.4),
                                        elevation: 0,
                                        shape: (RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        )),
                                      ),
                                      child: Text(
                                        S.of(context).appointmentModalButtonYes,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.green,
                                        backgroundColor:
                                            MainCubit.get(context).isDark
                                                ? ColorManager
                                                    .myPetsBaseBlackColor
                                                : Colors.green.shade100
                                                    .withOpacity(.4),
                                        elevation: 0,
                                        shape: (RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        )),
                                      ),
                                      child: Text(
                                        S.of(context).appointmentModalButtonNo,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }

                        if (appointments.statues != 0) {
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
                        shape: (RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        )),
                      ),
                      child: Text(
                        appointments.statues == 0
                            ? S.of(context).appointmentButtonEdit
                            : S.of(context).appointmentButtonBooking,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),
                  //call button
                  Expanded(
                    child: OfflineWidget(
                      onlineChild: ElevatedButton(
                        onPressed: () {
                          launchUrl(
                            Uri.parse('tel:${appointments.clinicPhone}'),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          backgroundColor:
                              MainCubit.get(context).isDark
                                  ? ColorManager.myPetsBaseBlackColor
                                  : Colors.blue.shade100.withOpacity(.4),
                          elevation: 0,
                          shape: (RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          )),
                        ),
                        child: Text(S.of(context).appointmentButtonCall),
                      ),
                      offlineChild: ElevatedButton(
                        onPressed: () {
                          launchUrl(Uri.parse('tel:+2${1000927095}'));
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          backgroundColor:
                              MainCubit.get(context).isDark
                                  ? ColorManager.myPetsBaseBlackColor
                                  : Colors.blue.shade100.withOpacity(.4),
                          elevation: 0,
                          shape: (RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          )),
                        ),
                        child: Text(S.of(context).appointmentButtonCall),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  appointments.statues == 0
                      ? OfflineWidget(
                        onlineChild: Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      S.of(context).appointmentModalTitle,
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text:
                                                    "${S.of(context).appointmentModalDescription} ",
                                                style:
                                                    Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium, // Use the existing theme for consistency
                                              ),
                                              TextSpan(
                                                text: appointments.pet.name,
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium?.copyWith(
                                                  fontWeight:
                                                      FontWeight
                                                          .bold, // Make the pet's name bold
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            'https://img.freepik.com/free-vector/emotional-support-animal-concept-illustration_114360-19462.jpg?w=740&t=st=1693530236~exp=1693530836~hmac=754f0eea1ad76b4cfe66e8f471927ff6d1d2c6625ff14e6cb2c81aa69ab9fc90',
                                          ),
                                          radius: 75,
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                            3,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            cubit.deleteAppointments(
                                              appointments,
                                            );
                                            Navigator.of(context).pop(true);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.red,
                                            backgroundColor:
                                                MainCubit.get(context).isDark
                                                    ? ColorManager
                                                        .myPetsBaseBlackColor
                                                    : Colors.red.shade100
                                                        .withOpacity(.4),
                                            elevation: 0,
                                            shape: (RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            )),
                                          ),
                                          child: Text(
                                            S
                                                .of(context)
                                                .appointmentModalButtonYes,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                            3,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.green,
                                            backgroundColor:
                                                MainCubit.get(context).isDark
                                                    ? ColorManager
                                                        .myPetsBaseBlackColor
                                                    : Colors.green.shade100
                                                        .withOpacity(.4),
                                            elevation: 0,
                                            shape: (RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            )),
                                          ),
                                          child: Text(
                                            S
                                                .of(context)
                                                .appointmentModalButtonNo,
                                          ),
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
                              shape: (RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              )),
                            ),
                            child: Text(S.of(context).appointmentButtonCancel),
                          ),
                        ),
                        offlineChild: Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              OfflineWidget.showOfflineWidget(context);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.red,
                              backgroundColor:
                                  MainCubit.get(context).isDark
                                      ? ColorManager.myPetsBaseBlackColor
                                      : Colors.red.shade100.withOpacity(.4),
                              elevation: 0,
                              shape: (RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              )),
                            ),
                            child: Text(S.of(context).appointmentButtonCancel),
                          ),
                        ),
                      )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
}
