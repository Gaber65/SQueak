import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/service/global_widget/care_loading_widget.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/card_appoinment_item.dart';
import 'package:squeak/features/appointments/exam/presentation/view/supplier/get_supplier.dart';
import '../../../../boarding/presentation/cubit/boarding_state.dart';
import '../../../../boarding/presentation/screens/widgets/boarding_card.dart';
import '../../../../boarding/presentation/screens/widgets/filter_boarding.dart';
import '../component/filter_component.dart';
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
          create: (context) => sl<BoardingCubit>(),
        ),
        BlocProvider(
          lazy: true,
          create: (context) => sl<PetCubit>(),
        ),
      ],
      child: _AllAppointmentContent(services: _getServiceNames(context)),
    );
  }
}

class _AllAppointmentContent extends StatefulWidget {
  final List<String> services;

  const _AllAppointmentContent({required this.services});

  @override
  State<_AllAppointmentContent> createState() => _AllAppointmentContentState();
}

class _AllAppointmentContentState extends State<_AllAppointmentContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.services.length, vsync: this);
    // Add listener after first frame so inherited blocs are available from context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabController.addListener(_handleTabChange);
    });
  }

  void _handleTabChange() {
    // When the index is changing (user tapped another tab or swiped), clear filters
    if (_tabController.indexIsChanging) {
      final prev = _previousIndex;
      if (prev == 0) {
        try {
          UserAppointmentCubit.get(context).clearFilters();
        } catch (_) {}
      } else if (prev == 1) {
        try {
          BoardingCubit.get(context).clearFilters();
        } catch (_) {}
      }
    } else {
      // update previous index when the animation landed on the new index
      if (_tabController.index != _previousIndex) {
        _previousIndex = _tabController.index;
      }
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
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
            if (state is GetAppointmentSuccess) {
              try {
                final petCubit = context.read<PetCubit>();
                if (petCubit.pets.isEmpty) petCubit.getOwnerPets();
              } catch (_) {
                final petCubit = sl<PetCubit>();
                if (petCubit.pets.isEmpty) petCubit.getOwnerPets();
              }

              try {
                final boardingCubit = context.read<BoardingCubit>();
                if (boardingCubit.boardingEntries.isEmpty) {
                  boardingCubit.getBoardingEntries(true);
                }
              } catch (_) {
                final boardingCubit = sl<BoardingCubit>();
                if (boardingCubit.boardingEntries.isEmpty) {
                  boardingCubit.getBoardingEntries(true);
                }
              }
            }
          },
        ),
        BlocListener<BoardingCubit, BoardingState>(
          listener: (context, state) {
          },
        ),
        BlocListener<PetCubit, PetState>(
          listener: (context, state) {
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: _buildAppBar(context),
            body: _buildTabBarView(context),
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
            controller: _tabController,
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
            tabs: widget.services.map((service) => Tab(text: service)).toList(),
          ),
        ),
      ),
    );
  }

  TabBarView _buildTabBarView(BuildContext context) {
    return TabBarView(
      controller: _tabController,
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
            buildWhen: (previous, current) =>
                current is AppointmentFiltered ||
                current is GetAppointmentSuccess ||
                current is AppointmentFilterCleared,
            builder: (context, state) => buildStateFilter(context),
          ),
        ),
        Expanded(
          child: BlocBuilder<UserAppointmentCubit, UserAppointmentState>(
            buildWhen: (previous, current) =>
                current is AppointmentFiltered ||
                current is AppointmentFilterCleared ||
                current is GetAppointmentSuccess,
            builder: (context, state) {
              final pets = PetCubit.get(context).pets;
              return buildPetFilter(context, pets);
            },
          ),
        ),
        BlocBuilder<UserAppointmentCubit, UserAppointmentState>(
          buildWhen: (previous, current) =>
              current is AppointmentFiltered ||
              current is GetAppointmentSuccess ||
              current is AppointmentFilterCleared,
          builder: (context, state) {
            return Visibility(
              visible: state is AppointmentFiltered,
              child: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => UserAppointmentCubit.get(context).clearFilters(),
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
    if (state is GetAppointmentLoading && cubit.appointments.isEmpty) {
      return CareLoadingWidget(
        theme: Theme.of(context),
        isDark: MainCubit.get(context).isDark,
        text: S.of(context).loadingAppointments,
      );
    }
    if (cubit.appointments.isEmpty && state is! GetSupplierSuccess) {
      return emptyAppointment(context);
    }
    if (state is AppointmentFiltered) {
      return _buildAppointmentList(state.appointments, context, cubit);
    }
    return RefreshIndicator(
      onRefresh: () async => await cubit.getAppointment(false),
      child: _buildAppointmentList(cubit.appointments, context, cubit),
    );
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
          child: BlocBuilder<BoardingCubit, BoardingState>(
            buildWhen: (previous, current) =>
                current is BoardingFiltered ||
                current is BoardingFilteredClear ||
                current is GetBoardingEntriesSuccess,
            builder: (context, state) {
              final pets = PetCubit.get(context).pets;
              return buildPetFilterBoarding(context, pets);
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<BoardingCubit, BoardingState>(
            buildWhen: (previous, current) =>
                current is BoardingFiltered ||
                current is GetBoardingEntriesSuccess ||
                current is BoardingFilteredClear,
            builder: (context, state) => buildStateFilterBoarding(context),
          ),
        ),
        BlocBuilder<BoardingCubit, BoardingState>(
          buildWhen: (previous, current) =>
              current is BoardingFiltered ||
              current is GetBoardingEntriesSuccess ||
              current is BoardingFilteredClear,
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
