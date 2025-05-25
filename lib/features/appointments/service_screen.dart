import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../core/service/main_service/presentation/controller/main_cubit/main_cubit.dart';
import '../../core/service/service_locator/service_locator.dart';
import '../pets/domain/entities/pet_entity.dart';
import '../pets/presentation/controller/pet_cubit.dart';
import 'boarding/presentation/cubit/boarding_cubit.dart';
import 'boarding/presentation/screens/boarding_screen.dart';
import 'exam/domain/entities/availability_entities.dart';
import 'exam/domain/entities/doctor_entity.dart';
import 'exam/presentation/controller/clinic/appointment_cubit.dart';
import 'exam/presentation/view/appointments/booking/booking_screen.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({
    super.key,
    required this.doctors,
    required this.selectedDate,
    required this.timeSlotData,
    required this.clinicCode,
    required this.petSelectFromIcon,
  });

  final DateTime selectedDate;
  final List<Availability> timeSlotData;
  final String clinicCode;
  final List<Doctor> doctors;
  final PetEntities? petSelectFromIcon;

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  String? doctorImage;

  String? doctorName;

  String? doctorId;

  final List<Map> services = [
    // {'en': 'Grooming', 'ar': 'تجميل'},
    {'en': 'Boarding', 'ar': 'الاقامة'},
    {'en': 'Examination', 'ar': 'الاختبار'},
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) =>
                  sl<AppointmentCubit>()..getClientINClinic(widget.clinicCode),
        ),
        BlocProvider(create: (_) => sl<PetCubit>()..getOwnerPets()),
        BlocProvider(
          create:
              (context) => BoardingCubit()..getBoardingType(widget.clinicCode),
        ),
      ],
      child: BlocConsumer<AppointmentCubit, AppointmentState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return DefaultTabController(
            length: services.length,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(15),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color:
                            MainCubit.get(context).isDark
                                ? Colors.black26
                                : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TabBar(
                        isScrollable: false,
                        indicatorColor: ColorManager.primaryColor,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Colors.white,
                        indicator: BoxDecoration(
                          color: ColorManager.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        unselectedLabelColor: Color.fromRGBO(129, 136, 152, 1),
                        indicatorWeight: 2,
                        padding: EdgeInsets.all(6),
                        labelStyle: FontStyleThame.textStyle(
                          context: context,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        tabs:
                            services
                                .map(
                                  (service) => Tab(
                                    text:
                                        isArabic()
                                            ? service['ar']
                                            : service['en'],
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ),
                ),
              ),
              body: TabBarView(
                children:
                    services.map((service) {
                      // if (service['en'] == 'Grooming' ||
                      //     service['ar'] == 'تجميل') {
                      //   return GroomingScreen();
                      // } else
                      if (service['en'] == 'Boarding' ||
                          service['ar'] == 'الاقامة') {
                        return BoardingScreen(clinicCode: widget.clinicCode);
                      } else if (service['en'] == 'Examination' ||
                          service['ar'] == 'الاختبار') {
                        return BookingScreen(
                          doctors: widget.doctors,
                          clinicCode: widget.clinicCode,
                          selectedDate: widget.selectedDate,
                          timeSlotData: widget.timeSlotData,
                          petSelectFromIcon: widget.petSelectFromIcon,
                        );
                      } else {
                        return Container();
                      }
                    }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
