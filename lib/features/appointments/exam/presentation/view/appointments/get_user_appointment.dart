import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/appointmentShimmerItem.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/booking/widget/appointment_item.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/card_appoinment_item.dart';

import '../../../../../pets/domain/entities/pet_entity.dart';
import '../../../../boarding/presentation/cubit/boarding_cubit.dart';
import '../../../../boarding/presentation/cubit/boarding_state.dart';
import '../../../../boarding/presentation/screens/widgets/boarding_card.dart';
import '../../../../boarding/presentation/screens/widgets/filter_boarding.dart';
import '../../controller/user/user_appointment_cubit.dart';
import '../component/filter_component.dart';

import 'booking/widget/empty_data.dart';

class GetUserAppointment extends StatelessWidget {
  GetUserAppointment({super.key});
  final List<Map> services = [
    {'en': 'Examination', 'ar': 'الاختبار'},
    {'en': 'Boarding', 'ar': 'مكان الاقامة'},
  ];
bool isArabic() {
  return MainCubit.get(navigatorKey.currentContext!).language == 'ar';
}
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
            child: Builder(
                builder: (context) {
                  final TabController tabController = DefaultTabController.of(context);

                  return Scaffold(
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
                              controller: tabController,

                              onTap: (index) {
                                (context as Element).markNeedsBuild();
                                // cubit.changeTab(index);
                              },
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
                      children: [
                        Scaffold(
                          body:   Column(
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
                              Expanded(
                                child: BlocConsumer<
                                    UserAppointmentCubit,
                                    UserAppointmentState
                                >(
                                  listener: (context, state) {},

                                  builder: (context, state) {
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
                              ),
                            ],
                          ),
                          floatingActionButton:   FloatingActionButton(
                            backgroundColor: ColorManager.primaryColor,
                            onPressed: () {
                              LayoutCubit.get(context).changeBottomNav(1);
                              navigateAndFinish(context, LayoutScreen());
                            },
                            child:
                            const Icon(IconlyLight.calendar, color: Colors.white),
                          ),
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
                                        isDarkMode:MainCubit.get(context).isDark,
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
                                          isDarkMode:MainCubit.get(context).isDark,

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
                  );
                }
            ),
          );
        },
      ),
    );
  }
}
