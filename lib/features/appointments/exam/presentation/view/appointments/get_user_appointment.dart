import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/card_appoinment_item.dart';
import 'package:squeak/features/appointments/exam/presentation/view/supplier/get_supplier.dart';
import '../../../../boarding/presentation/cubit/boarding_state.dart';
import '../../../../boarding/presentation/screens/widgets/boarding_card.dart';
import '../../../../boarding/presentation/screens/widgets/filter_boarding.dart';
import '../component/filter_component.dart';
import '../component/loading_widget.dart';
import 'booking/widget/empty_data.dart';

class GetUserAppointment extends StatelessWidget {
  GetUserAppointment({super.key});
  final List<Map> services = [
    {'en': 'Examination', 'ar': 'الاختبار'},
    {'en': 'Boarding', 'ar': 'مكان الاقامة'},
  ];
  List<String> _getServiceNames(BuildContext context) {
    final isAr = MainCubit.get(context).language == 'ar';
    return services
        .map(
          (service) => isAr ? service['ar'] as String : service['en'] as String,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create:
              (context) => sl<UserAppointmentCubit>()..getAppointment(false),
        ),
        BlocProvider(
          lazy: true,
          create: (context) => sl<BoardingCubit>()..getBoardingEntries(true),
        ),
        BlocProvider(
          lazy: true,
          create: (context) => sl<PetCubit>()..getOwnerPets(),
        ),
      ],
      child: _AllAppointmentContent(services: _getServiceNames(context)),
    );
  }
}

class _AllAppointmentContent extends StatelessWidget {
  final List<String> services;

  const _AllAppointmentContent({required this.services});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Listen for UserAppointmentCubit state changes
        BlocListener<UserAppointmentCubit, UserAppointmentState>(
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
        ),
        // Listen for BoardingCubit state changes if needed
        BlocListener<BoardingCubit, BoardingState>(
          listener: (context, state) {
            // Add boarding-specific listeners here if needed
            // For example: show snackbars, navigate, etc.
          },
        ),
        // Listen for PetCubit state changes if needed
        BlocListener<PetCubit, PetState>(
          listener: (context, state) {
            // Add pet-specific listeners here if needed
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: _buildAppBar(context),
              body: _buildTabBarView(context),
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(S.of(context).allYourAppointments),
      bottom: _buildTabBar(context),
    );
  }

  PreferredSize _buildTabBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
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
            unselectedLabelColor: const Color.fromRGBO(129, 136, 152, 1),
            indicatorWeight: 2,
            padding: const EdgeInsets.all(6),
            labelStyle: FontStyleThame.textStyle(
              context: context,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            tabs: services.map((service) => Tab(text: service)).toList(),
          ),
        ),
      ),
    );
  }

  TabBarView _buildTabBarView(BuildContext context) {
    return TabBarView(
      children: [_buildExaminationTab(context), _buildBoardingTab(context)],
    );
  }

  Widget _buildExaminationTab(BuildContext context) {
    return BlocBuilder<UserAppointmentCubit, UserAppointmentState>(
      builder: (context, state) {
        final cubit = UserAppointmentCubit.get(context);

        return Scaffold(
          body: Column(
            children: [
              const SizedBox(height: 10),
              _buildExaminationFilters(context, state),
              Expanded(child: _buildExaminationList(context, cubit, state)),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: ColorManager.primaryColor,
            onPressed: () {
              navigateToScreen(
                context,
                MySupplierScreen(petSelectFromIcon: null),
              );
            },
            child: const Icon(IconlyLight.calendar, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildExaminationFilters(
    BuildContext context,
    UserAppointmentState state,
  ) {
    return Row(
      children: [
        Expanded(
          child: BlocBuilder<UserAppointmentCubit, UserAppointmentState>(
            builder: (context, state) => buildStateFilter(context),
          ),
        ),
        Expanded(
          child: BlocBuilder<PetCubit, PetState>(
            builder: (context, state) {
              final pets = PetCubit.get(context).pets;
              return buildPetFilter(context, pets);
            },
          ),
        ),
        BlocBuilder<UserAppointmentCubit, UserAppointmentState>(
          builder: (context, state) {
            return Visibility(
              visible: state is AppointmentFiltered,
              child: IconButton(
                icon: const Icon(Icons.clear),
                onPressed:
                    () => UserAppointmentCubit.get(context).clearFilters(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildExaminationList(
    BuildContext context,
    UserAppointmentCubit cubit,
    UserAppointmentState state,
  ) {
    if (state is GetAppointmentLoading && state is! GetAppointmentSuccess) {
      return LoadingWidget(
        enMessage: 'Loading All appointments...',
        arMessage: 'جاري تحميل جميع المواعيد...',
      );
    } else if (cubit.appointments.isEmpty && state is! GetSupplierSuccess) {
      return emptyAppointment(context);
    } else if (state is AppointmentFiltered && state is GetAppointmentSuccess) {
      return _buildAppointmentList(state.appointments, context, cubit);
    } else {
      return RefreshIndicator(
        onRefresh: () async => await cubit.getAppointment(false),
        child: _buildAppointmentList(cubit.appointments, context, cubit),
      );
    }
  }

  Widget _buildAppointmentList(
    List<dynamic> appointments,
    BuildContext context,
    UserAppointmentCubit cubit,
  ) {
    return ListView.builder(
      itemBuilder:
          (context, index) =>
              buildItem(appointments[index], context, cubit, index),
      itemCount: appointments.length,
      physics: const BouncingScrollPhysics(),
    );
  }

  Widget _buildBoardingTab(BuildContext context) {
    return BlocBuilder<BoardingCubit, BoardingState>(
      builder: (context, state) {
        final boardingCubit = BoardingCubit.get(context);
        return Column(
          children: [
            _buildBoardingFilters(context, state),
            Expanded(child: _buildBoardingList(context, boardingCubit, state)),
          ],
        );
      },
    );
  }

  Widget _buildBoardingFilters(BuildContext context, BoardingState state) {
    return Row(
      children: [
        Expanded(
          child: BlocBuilder<PetCubit, PetState>(
            builder: (context, state) {
              final pets = PetCubit.get(context).pets;
              return buildPetFilterBoarding(context, pets);
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<LayoutCubit, LayoutState>(
            builder: (context, state) => buildStateFilterBoarding(context),
          ),
        ),
        BlocBuilder<BoardingCubit, BoardingState>(
          builder: (context, state) {
            return Visibility(
              visible: state is BoardingFiltered,
              child: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => BoardingCubit.get(context).clearFilters(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBoardingList(
    BuildContext context,
    BoardingCubit boardingCubit,
    BoardingState state,
  ) {
    if (boardingCubit.boardingEntries.isEmpty) {
      return emptyBoarding(context);
    }

    final entries =
        state is BoardingFiltered
            ? state.filteredEntries
            : boardingCubit.boardingEntries;
    final isDarkMode = MainCubit.get(context).isDark;

    if (state is BoardingFiltered) {
      return ListView.builder(
        itemBuilder:
            (context, index) => BoardingCard(
              isDarkMode: isDarkMode,
              entry: entries[index],
              cubit: boardingCubit,
            ),
        itemCount: entries.length,
        physics: const BouncingScrollPhysics(),
      );
    } else {
      return RefreshIndicator(
        onRefresh: () async => await boardingCubit.getBoardingEntries(true),
        child: ListView.builder(
          itemBuilder:
              (context, index) => BoardingCard(
                isDarkMode: isDarkMode,
                entry: entries[index],
                cubit: boardingCubit,
              ),
          itemCount: entries.length,
          physics: const BouncingScrollPhysics(),
        ),
      );
    }
  }
}
