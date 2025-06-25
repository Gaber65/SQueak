import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/appointments/exam/domain/entities/appointment_entity.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/all_apointment.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/book_again_screen.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/rate_appointment.dart';
import 'package:squeak/features/appointments/exam/presentation/view/files_and_prescription_for_pet/files_for_pet_screen.dart';
import 'package:squeak/features/appointments/exam/presentation/view/files_and_prescription_for_pet/prescription_for_pet_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../pets/presentation/controller/pet_cubit.dart';
import '../../controller/user/user_appointment_cubit.dart';
import '../component/filter_component.dart';
import 'appointmentShimmerItem.dart';
import 'card_appoinment_item.dart';

class GetUserAppointment extends StatelessWidget {
  const GetUserAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  sl<UserAppointmentCubit>()
                    ..fetchSuppliers()
                    ..getAppointment(true),
        ),
        BlocProvider(create: (context) => sl<PetCubit>()..getOwnerPets()),
      ],
      child: BlocConsumer<UserAppointmentCubit, UserAppointmentState>(
        listener: (context, state) {
          if (state is DeleteAppointmentSuccess) {
            UserAppointmentCubit.get(context).getAppointment(true);
          }
          if (state is EditAppointment) {
            UserAppointmentCubit.get(
              context,
            ).deleteAppointments(state.model.id);
          }
        },
        builder: (context, state) {
          var cubit = UserAppointmentCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(S.of(context).yourAppointments),
              actions: [
                IconButton(
                  onPressed: () {
                    navigateToScreen(context, AllAppointment());
                  },
                  icon: const Icon(IconlyLight.calendar),
                ),
              ],
            ),
            body: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: buildStateFilter(context)),
                    Expanded(
                      child: BlocConsumer<PetCubit, PetState>(
                        builder: (context, state) {
                          var cubit = PetCubit.get(context);
                          return buildPetFilter(context, cubit.pets);
                        },
                        listener: (context, state) {},
                      ),
                    ),
                    if (state is AppointmentFiltered)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          UserAppointmentCubit.get(context).clearFilters();
                        },
                      ),
                  ],
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (state is GetAppointmentLoading &&
                          cubit.appointments.isEmpty) {
                        return ListView.builder(
                          itemCount: 6,
                          itemBuilder:
                              (context, index) =>
                                  appointmentShimmerItem(context),
                          physics: const BouncingScrollPhysics(),
                        );
                      } else if (cubit.appointments.isEmpty) {
                        return emptyAppointment(context);
                      } else if (state is AppointmentFiltered) {
                        return ListView.builder(
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
                        );
                      } else {
                        return RefreshIndicator(
                          onRefresh: () async {
                            await cubit.getAppointment(false);
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
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: ColorManager.primaryColor,
              onPressed: () {
                LayoutCubit.get(context).changeBottomNav(1);
                navigateAndFinish(context, LayoutScreen());
              },
              child: const Icon(IconlyLight.calendar, color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
