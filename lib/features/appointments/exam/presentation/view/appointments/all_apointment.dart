import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import '../../../../boarding/presentation/cubit/boarding_state.dart';
import '../../../../boarding/presentation/screens/widgets/boarding_card.dart';
import '../../../../boarding/presentation/screens/widgets/filter_boarding.dart';
import '../component/filter_component.dart';
import '../component/loading_widget.dart';
import '../supplier/get_supplier.dart';
import 'booking/widget/empty_data.dart';
import 'card_appoinment_item.dart';
import 'get_user_appointment.dart';

class AllAppointment extends StatelessWidget {
  AllAppointment({super.key});

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
          create: (context) => sl<UserAppointmentCubit>()..fetchSuppliers(),
        ),
        BlocProvider(create: (context) => sl<BoardingCubit>()),
        BlocProvider(
          lazy: true,
          create: (context) => sl<PetCubit>()..getOwnerPets()),
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
  bool _examinationDataLoaded = false;
  bool _boardingDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    // Load examination data initially since it's the first tab
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_examinationDataLoaded) {
        context.read<UserAppointmentCubit>().getAppointment(true);
        _examinationDataLoaded = true;
      }
    });
  }

  void _onTabChanged() {
    if (_tabController.index == 0 && !_examinationDataLoaded) {
      context.read<UserAppointmentCubit>().getAppointment(true);
      _examinationDataLoaded = true;
    } else if (_tabController.index == 1 && !_boardingDataLoaded) {
      context.read<BoardingCubit>().getBoardingEntries(true);
      _boardingDataLoaded = true;
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
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
          },
        ),
        BlocListener<BoardingCubit, BoardingState>(
          listener: (context, state) {
            // Add boarding-specific listeners here if needed
          },
        ),
        BlocListener<PetCubit, PetState>(
          listener: (context, state) {
            // Add pet-specific listeners here if needed
          },
        ),
      ],
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: _buildAppBar(context),
          body: TabBarView(
            controller: _tabController,
            children: [_ExaminationTab(), _BoardingTab()],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(S.of(context).yourAppointments),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => navigateAndFinish(context, LayoutScreen())
      ),
      actions: [
        IconButton(
          onPressed: () => navigateToScreen(context, GetUserAppointment()),
          icon: const Icon(IconlyLight.calendar),
        ),
      ],
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
}

// Separate Examination Tab Widget
class _ExaminationTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserAppointmentCubit, UserAppointmentState>(
      builder: (context, state) {
        final cubit = UserAppointmentCubit.get(context);
        // Show loading indicator for initial load
        if (state is GetAppointmentLoading && cubit.appointments.isEmpty) {
          return LoadingWidget(message: 'Loading appointments...');
        } else {
          return Scaffold(
            body: Column(
              children: [
                const SizedBox(height: 10),
                _ExaminationFilters(),
                Expanded(child: _ExaminationList(cubit: cubit, state: state)),
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
        }
      },
    );
  }
}

// Separate Examination Filters Widget
class _ExaminationFilters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}

// Separate Examination List Widget with Pagination
class _ExaminationList extends StatefulWidget {
  final UserAppointmentCubit cubit;
  final UserAppointmentState state;

  const _ExaminationList({required this.cubit, required this.state});

  @override
  State<_ExaminationList> createState() => _ExaminationListState();
}

class _ExaminationListState extends State<_ExaminationList> {
  final ScrollController _scrollController = ScrollController();
  static const int _pageSize = 10;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  void _loadMore() {
    final appointments =
        widget.state is AppointmentFiltered
            ? (widget.state as AppointmentFiltered).appointments
            : widget.cubit.appointments;

    if (_currentPage * _pageSize < appointments.length) {
      setState(() {
        _currentPage++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state is GetAppointmentLoading &&
        widget.cubit.appointments.isEmpty) {
      return LoadingWidget(message: 'Loading appointments...');
    } else if (widget.cubit.appointments.isEmpty &&
        widget.state is! GetSupplierSuccess) {
      return emptyAppointment(context);
    }

    final appointments =
        widget.state is AppointmentFiltered
            ? (widget.state as AppointmentFiltered).appointments
            : widget.cubit.appointments;

    if (widget.state is AppointmentFiltered && appointments.isNotEmpty) {
      return _buildAppointmentList(appointments, context);
    } else {
      return RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _currentPage = 1;
          });
          await widget.cubit.getAppointment(false);
        },
        child: _buildAppointmentList(appointments, context),
      );
    }
  }

  Widget _buildAppointmentList(
    List<dynamic> appointments,
    BuildContext context,
  ) {
    final itemsToShow = (_currentPage * _pageSize).clamp(
      0,
      appointments.length,
    );
    final displayedAppointments = appointments.sublist(0, itemsToShow);

    return ListView.builder(
      key: const PageStorageKey('examination_list'),
      controller: _scrollController,
      itemBuilder: (context, index) {
        if (index < displayedAppointments.length) {
          return buildItem(
            displayedAppointments[index],
            context,
            widget.cubit,
            index,
          );
        } else {
          return LoadingItem();
        }
      },
      itemCount:
          displayedAppointments.length +
          (itemsToShow < appointments.length ? 1 : 0),
      physics: const AlwaysScrollableScrollPhysics(),
    );
  }
}

// Separate Boarding Tab Widget
class _BoardingTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BoardingCubit, BoardingState>(
      builder: (context, state) {
        final boardingCubit = BoardingCubit.get(context);

        // Show loading indicator for initial load
        if (state is GetBoardingEntriesLoading &&
            boardingCubit.boardingEntries.isEmpty) {
          return LoadingWidget(message: 'Loading boarding entries...');
        }

        return Column(
          children: [
            _BoardingFilters(),
            Expanded(
              child: _BoardingList(boardingCubit: boardingCubit, state: state),
            ),
          ],
        );
      },
    );
  }
}

// Separate Boarding Filters Widget
class _BoardingFilters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}

// Separate Boarding List Widget with Pagination
class _BoardingList extends StatefulWidget {
  final BoardingCubit boardingCubit;
  final BoardingState state;

  const _BoardingList({required this.boardingCubit, required this.state});

  @override
  State<_BoardingList> createState() => _BoardingListState();
}

class _BoardingListState extends State<_BoardingList> {
  final ScrollController _scrollController = ScrollController();
  static const int _pageSize = 10;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  void _loadMore() {
    final entries =
        widget.state is BoardingFiltered
            ? (widget.state as BoardingFiltered).filteredEntries
            : widget.boardingCubit.boardingEntries;

    if (_currentPage * _pageSize < entries.length) {
      setState(() {
        _currentPage++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.boardingCubit.boardingEntries.isEmpty) {
      return emptyBoarding(context);
    }

    final entries =
        widget.state is BoardingFiltered
            ? (widget.state as BoardingFiltered).filteredEntries
            : widget.boardingCubit.boardingEntries;
    final isDarkMode = MainCubit.get(context).isDark;

    if (widget.state is BoardingFiltered) {
      return _buildBoardingListView(entries, isDarkMode, context);
    } else {
      return RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _currentPage = 1;
          });
          await widget.boardingCubit.getBoardingEntries(true);
        },
        child: _buildBoardingListView(entries, isDarkMode, context),
      );
    }
  }

  Widget _buildBoardingListView(
    List<dynamic> entries,
    bool isDarkMode,
    BuildContext context,
  ) {
    final itemsToShow = (_currentPage * _pageSize).clamp(0, entries.length);
    final displayedEntries = entries.sublist(0, itemsToShow);

    return ListView.builder(
      key: const PageStorageKey('boarding_list'),
      controller: _scrollController,
      itemBuilder: (context, index) {
        if (index < displayedEntries.length) {
          return BoardingCard(
            isDarkMode: isDarkMode,
            entry: displayedEntries[index],
            cubit: widget.boardingCubit,
          );
        } else {
          return LoadingItem();
        }
      },
      itemCount:
          displayedEntries.length + (itemsToShow < entries.length ? 1 : 0),
      physics: const AlwaysScrollableScrollPhysics(),
    );
  }
}
