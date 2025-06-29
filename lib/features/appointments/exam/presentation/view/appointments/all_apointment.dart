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
import 'book_again_screen.dart';

class AllAppointment extends StatelessWidget {
  AllAppointment({super.key});
  final List<Map> services = [
    {'en': 'Examination', 'ar': 'الاختبار'},
    {'en': 'Boarding', 'ar': 'مكان الاقامة'},
  ];

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
        BlocProvider(
          create: (context) => sl<BoardingCubit>()..getBoardingEntries(true),
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
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(S.of(context).yourAppointments),
                actions: [
                  IconButton(
                    onPressed: () {
                      navigateToScreen(context, GetUserAppointment());
                    },
                    icon: const Icon(IconlyLight.calendar),
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(40),
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
                        onTap: (index) {},
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
              floatingActionButton: FloatingActionButton(
                backgroundColor: ColorManager.primaryColor,
                onPressed: () {
                  LayoutCubit.get(context).changeBottomNav(1);

                  navigateAndFinish(context, LayoutScreen());
                },
                child: const Icon(IconlyLight.calendar, color: Colors.white),
              ),
              body: TabBarView(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: BlocConsumer<
                              UserAppointmentCubit,
                              UserAppointmentState
                            >(
                              builder: (context, state) {
                                return buildStateFilter(context);
                              },
                              listener: (context, state) {},
                            ),
                          ),
                          Expanded(
                            child: BlocConsumer<PetCubit, PetState>(
                              builder: (context, state) {
                                return buildPetFilter(
                                  context,
                                  PetCubit.get(context).pets,
                                );
                              },
                              listener: (context, state) {},
                            ),
                          ),
                          if (state is AppointmentFiltered)
                            IconButton(
                              icon: Icon(Icons.clear), // Clear icon
                              onPressed: () {
                                UserAppointmentCubit.get(
                                  context,
                                ).clearFilters();
                              },
                            ),
                        ],
                      ),
                      cubit.appointments.isEmpty
                          ? emptyAppointment(context)
                          : (state is AppointmentFiltered)
                          ? Expanded(
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return buildItemAppointment(
                                  state.appointments[index],
                                  context,
                                  cubit,
                                  index,
                                );
                              },
                              itemCount: state.appointments.length,
                              physics: const BouncingScrollPhysics(),
                            ),
                          )
                          : Expanded(
                            child: RefreshIndicator(
                              onRefresh: () async {
                                await UserAppointmentCubit.get(
                                  context,
                                ).getAppointment(false);
                              },
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return buildItemAppointment(
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
                          ),
                    ],
                  ),
                  BlocConsumer<BoardingCubit, BoardingState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      var boardingCubit = BoardingCubit.get(context);
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: BlocConsumer<PetCubit, PetState>(
                                  builder: (context, state) {
                                    List<PetEntities> pets =
                                        PetCubit.get(context).pets;
                                    return buildPetFilterBoarding(
                                      context,
                                      pets,
                                    );
                                  },
                                  listener: (context, state) {},
                                ),
                              ),
                              Expanded(
                                child: BlocConsumer<LayoutCubit, LayoutState>(
                                  builder: (context, state) {
                                    return buildStateFilterBoarding(context);
                                  },
                                  listener: (context, state) {},
                                ),
                              ),
                              if (state is BoardingFiltered)
                                IconButton(
                                  icon: Icon(Icons.clear), // Clear icon
                                  onPressed: () {
                                    boardingCubit.clearFilters();
                                  },
                                ),
                            ],
                          ),
                          Expanded(
                            child:
                                boardingCubit.boardingEntries.isEmpty
                                    ? emptyBoarding(context)
                                    : (state is BoardingFiltered)
                                    ? ListView.builder(
                                      itemBuilder: (context, index) {
                                        return BoardingCard(
                                          entry: state.filteredEntries[index],
                                          cubit: boardingCubit,
                                        );
                                      },
                                      itemCount: state.filteredEntries.length,
                                      physics: const BouncingScrollPhysics(),
                                    )
                                    : RefreshIndicator(
                                      onRefresh: () async {
                                        await boardingCubit.getBoardingEntries(
                                          true,
                                        );
                                      },
                                      child: ListView.builder(
                                        itemBuilder: (context, index) {
                                          return BoardingCard(
                                            entry:
                                                boardingCubit
                                                    .boardingEntries[index],
                                            cubit: boardingCubit,
                                          );
                                        },
                                        itemCount:
                                            boardingCubit
                                                .boardingEntries
                                                .length,
                                        physics: const BouncingScrollPhysics(),
                                      ),
                                    ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
