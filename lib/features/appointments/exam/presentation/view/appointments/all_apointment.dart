import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/appointments/exam/domain/entities/appointment_entity.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/rate_appointment.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/user/user_appointment_cubit.dart';
import '../component/filter_component.dart';
import '../files_and_prescription_for_pet/files_for_pet_screen.dart';
import '../files_and_prescription_for_pet/prescription_for_pet_screen.dart';
import 'appointmentShimmerItem.dart';
import 'book_again_screen.dart';
import 'card_appoinment_item.dart';

class AllAppointment extends StatelessWidget {
  const AllAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  sl<UserAppointmentCubit>()
                    ..fetchSuppliers()
                    ..getAppointment(false),
        ),
        BlocProvider(create: (context) => sl<PetCubit>()..getOwnerPets()),
      ],
      child: BlocConsumer<UserAppointmentCubit, UserAppointmentState>(
        listener: (context, state) {
          if (state is DeleteAppointmentSuccess) {
            UserAppointmentCubit.get(context).getAppointment(false);
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
              automaticallyImplyLeading: true,
              title: Text(isArabic() ? "كل مواعيدك" : "All your appointments"),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Row(
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
                print("DEBUG: Floating button pressed");
                LayoutCubit.get(context).changeBottomNav(1);

                navigateAndFinish(context, LayoutScreen());
              },
              child: const Icon(IconlyLight.calendar, color: Colors.white),
            ),
            body: Builder(
              builder: (context) {
                if (state is GetAppointmentLoading && cubit.appointments.isEmpty) {
                  return ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) => appointmentShimmerItem(context),
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

          );
        },
      ),
    );
  }

}
