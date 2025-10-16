// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'dart:async';
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

// Performance constants
class _AppointmentConstants {
  static const int pageSize = 5; // Reduced for faster initial load
  static const double scrollThreshold = 100.0; // Reduced for responsive load
  static const int maxVisibleItems = 15; // Limit visible items
  static const Duration debounceDelay = Duration(milliseconds: 300);
}

// Simple in-memory cache for small computed values
class _AppointmentCache {
  static final Map<String, dynamic> _cache = {};
  static const int _maxCacheSize = 50;

  static T? get<T>(String key) => _cache[key] as T?;

  static void set<T>(String key, T value) {
    if (_cache.length >= _maxCacheSize) _cache.remove(_cache.keys.first);
    _cache[key] = value;
  }
}

// Pagination mixin with debounce and light-weight virtual loading
mixin PaginationMixin<T extends StatefulWidget> on State<T> {
  late final ScrollController _scrollController;
  int _currentPage = 1;
  bool _isLoadingMore = false;
  Timer? _debounceTimer;
  final Set<int> _loadedItems = <int>{};

  ScrollController get scrollController => _scrollController;
  int get currentPage => _currentPage;
  bool get isLoadingMore => _isLoadingMore;

  void initPagination() {
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void disposePagination() {
    _debounceTimer?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
  }

  void _onScroll() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_AppointmentConstants.debounceDelay, () {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent -
              _AppointmentConstants.scrollThreshold) {
        _loadMore();
      }
    });
  }

  void _loadMore() {
    if (!_isLoadingMore &&
        _currentPage * _AppointmentConstants.pageSize < _getTotalItems()) {
      if (mounted) setState(() => _isLoadingMore = true);
      _currentPage++;
      loadMoreData();
    }
  }

  void resetPagination() {
    _debounceTimer?.cancel();
    if (mounted) {
      setState(() {
        _currentPage = 1;
        _isLoadingMore = false;
        _loadedItems.clear();
      });
    }
  }

  void setLoadingMore(bool loading) {
    if (mounted) setState(() => _isLoadingMore = loading);
  }

  bool isItemLoaded(int index) => _loadedItems.contains(index);

  void markItemAsLoaded(int index) => _loadedItems.add(index);

  // Implement these in subclasses
  void loadMoreData();

  int _getTotalItems();
}

class AllAppointment extends StatelessWidget {
  const AllAppointment({super.key});

  static const List<Map<String, String>> _services = [
    {'en': 'Examination', 'ar': 'الاختبار'},
    {'en': 'Boarding', 'ar': 'مكان الاقامة'},
  ];

  List<String> _getServiceNames(BuildContext context) {
    final isAr = MainCubit.get(context).language == 'ar';
    final cacheKey = 'service_names_${isAr ? 'ar' : 'en'}';

    final cached = _AppointmentCache.get<List<String>>(cacheKey);
    if (cached != null) return cached;

    final names = _services
        .map((service) => isAr ? service['ar']! : service['en']!)
        .toList();
    _AppointmentCache.set(cacheKey, names);
    return names;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<UserAppointmentCubit>(),
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
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final TabController _tabController;
  bool _examinationDataLoaded = false;
  bool _boardingDataLoaded = false;
  Timer? _backgroundRefreshTimer;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    debugPrint('AllAppointment:initState → ${DateTime.now().toIso8601String()}');
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('AllAppointment:postFrameCallback → ${DateTime.now().toIso8601String()}');
      if (mounted && !_examinationDataLoaded) {
        _loadExaminationDataInBackground();
        _examinationDataLoaded = true;
      }
    });

    _setupBackgroundRefresh();
  }

  void _setupBackgroundRefresh() {
    _backgroundRefreshTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      if (mounted) _refreshDataInBackground();
    });
  }

  void _loadExaminationDataInBackground() {
    Future.microtask(() {
      if (mounted) context.read<UserAppointmentCubit>().getAppointment(true);
    });
  }

  void _refreshDataInBackground() {
    Future.microtask(() {
      if (!mounted) return;
      final exam = context.read<UserAppointmentCubit>();
      final boarding = context.read<BoardingCubit>();
      exam.getAppointment(false);
      boarding.getBoardingEntries(false);
    });
  }

  void _onTabChanged() {
    if (_tabController.index == 0 && !_examinationDataLoaded) {
      _loadExaminationDataInBackground();
      _examinationDataLoaded = true;
    } else if (_tabController.index == 1 && !_boardingDataLoaded) {
      Future.microtask(() {
        if (mounted) context.read<BoardingCubit>().getBoardingEntries(true);
      });
      _boardingDataLoaded = true;
    }
  }

  @override
  void dispose() {
    _backgroundRefreshTimer?.cancel();
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<UserAppointmentCubit, UserAppointmentState>(
          listenWhen: (previous, current) =>
              current is DeleteAppointmentSuccess ||
              current is EditAppointment ||
              current is GetAppointmentSuccess,
          listener: (context, state) {
            // keep existing behaviors
            if (state is DeleteAppointmentSuccess) {
              UserAppointmentCubit.get(context).getAppointment(false);
            }
            if (state is EditAppointment) {
              UserAppointmentCubit.get(context).deleteAppointments(state.model.id);
            }
            if (state is GetAppointmentSuccess) {
              try {
                final petCubit = context.read<PetCubit>();
                if (petCubit.pets.isEmpty) {
                  petCubit.getOwnerPets();
                }
              } catch (_) {
                final petCubit = sl<PetCubit>();
                if (petCubit.pets.isEmpty) petCubit.getOwnerPets();
              }
            }
          },
        ),
        BlocListener<BoardingCubit, BoardingState>(
          listenWhen: (previous, current) => false,
          listener: (context, state) {},
        ),
        BlocListener<PetCubit, PetState>(
          listenWhen: (previous, current) => false,
          listener: (context, state) {},
        ),
      ],
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: _buildAppBar(context),
          body: TabBarView(
            controller: _tabController,
            children: const [
              _ExaminationTab(),
              _BoardingTab(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final isDark = MainCubit.get(context).isDark;
    return AppBar(
      centerTitle: true,
      title: Text(S.of(context).yourAppointments),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: isDark ? Colors.white : Colors.black87,
        ),
        onPressed: () => navigateAndFinish(context, LayoutScreen()),
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
            color: MainCubit.get(context).isDark
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

class _ExaminationTab extends StatelessWidget {
  const _ExaminationTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserAppointmentCubit, UserAppointmentState>(
      builder: (context, state) {
        final cubit = UserAppointmentCubit.get(context);
        if (state is GetAppointmentLoading && cubit.appointments.isEmpty) {
          return const LoadingWidget(
            enMessage: 'Loading appointments...',
            arMessage: 'جارٍ تحميل المواعيد...',
          );
        }

        return Scaffold(
          body: Column(
            children: const [
              SizedBox(height: 10),
              _ExaminationFilters(),
              Expanded(child: _ExaminationListPlaceholder()),
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
}

class _ExaminationFilters extends StatelessWidget {
  const _ExaminationFilters();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Row(
        children: [
          Expanded(
            child: BlocBuilder<UserAppointmentCubit, UserAppointmentState>(
              buildWhen: (previous, current) =>
                  current is AppointmentFiltered || current is GetAppointmentSuccess,
              builder: (context, state) => buildStateFilter(context),
            ),
          ),
          Expanded(
            child: BlocBuilder<PetCubit, PetState>(
              buildWhen: (previous, current) =>
                  current is GetOwnerPetsSuccessState ||
                  current is PetCreateSuccessState ||
                  current is DeletePetSuccessState,
              builder: (context, state) {
                final pets = PetCubit.get(context).pets;
                return buildPetFilter(context, pets);
              },
            ),
          ),
          BlocBuilder<UserAppointmentCubit, UserAppointmentState>(
            buildWhen: (previous, current) =>
                current is AppointmentFiltered || current is GetAppointmentSuccess,
            builder: (context, state) {
              return Visibility(
                visible: state is AppointmentFiltered,
                child: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    Future.microtask(() {
                      UserAppointmentCubit.get(context).clearFilters();
                    });
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Placeholder that wires into the real list via Bloc to keep file small and focused
class _ExaminationListPlaceholder extends StatefulWidget {
  const _ExaminationListPlaceholder();

  @override
  State<_ExaminationListPlaceholder> createState() => _ExaminationListPlaceholderState();
}

class _ExaminationListPlaceholderState extends State<_ExaminationListPlaceholder>
    with PaginationMixin {
  List<dynamic> _cachedAppointments = [];

  @override
  void initState() {
    super.initState();
    initPagination();
  }

  @override
  void dispose() {
    disposePagination();
    super.dispose();
  }

  @override
  void loadMoreData() {
    Future.delayed(const Duration(milliseconds: 100), () {
      setLoadingMore(false);
    });
  }

  @override
  int _getTotalItems() => _cachedAppointments.length;

  List<dynamic> _getAppointments(UserAppointmentState state) {
    final cubit = UserAppointmentCubit.get(context);
  final appointments = state is AppointmentFiltered
    ? state.appointments
    : cubit.appointments;

    if (_cachedAppointments != appointments) {
      _cachedAppointments = appointments;
      // schedule resetPagination after current frame to avoid calling setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) resetPagination();
      });
    }

    return _cachedAppointments;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserAppointmentCubit, UserAppointmentState>(
      builder: (context, state) {
        final appointments = _getAppointments(state);

        if (state is GetAppointmentLoading && appointments.isEmpty) {
          return const LoadingWidget(
            enMessage: 'Loading appointments...',
            arMessage: 'جارٍ تحميل المواعيد...',
          );
        }

        if (appointments.isEmpty && state is! GetSupplierSuccess) {
          return emptyAppointment(context);
        }

        final itemsToShow = (currentPage * _AppointmentConstants.pageSize).clamp(0, appointments.length);
        final maxItems = _AppointmentConstants.maxVisibleItems;
        final displayed = appointments.sublist(0, itemsToShow.clamp(0, maxItems));

        return RefreshIndicator(
          onRefresh: () async {
            resetPagination();
            await UserAppointmentCubit.get(context).getAppointment(false);
          },
          child: ListView.builder(
            key: const PageStorageKey('examination_list'),
            controller: scrollController,
            itemCount: displayed.length + (isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < displayed.length) {
                final appointment = displayed[index];
                return RepaintBoundary(
                  key: ValueKey('appointment_${appointment.id}_$index'),
                  child: buildItem(appointment, context, UserAppointmentCubit.get(context), index),
                );
              }
              if (index == displayed.length && isLoadingMore) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
            physics: const AlwaysScrollableScrollPhysics(),
            addAutomaticKeepAlives: true,
            addRepaintBoundaries: true,
            addSemanticIndexes: false,
            cacheExtent: 100.0,
            itemExtent: 300.0,
          ),
        );
      },
    );
  }
}

class _BoardingTab extends StatelessWidget {
  const _BoardingTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BoardingCubit, BoardingState>(
      builder: (context, state) {
        final boardingCubit = BoardingCubit.get(context);

        if (state is GetBoardingEntriesLoading && boardingCubit.boardingEntries.isEmpty) {
          return const LoadingWidget(
            enMessage: 'Loading boarding entries...',
            arMessage: 'جارٍ تحميل مواعيد الإقامة...',
          );
        }

        return Column(
          children: [
            const _BoardingFilters(),
            Expanded(
              child: _BoardingList(boardingCubit: boardingCubit, state: state),
            ),
          ],
        );
      },
    );
  }
}

class _BoardingFilters extends StatelessWidget {
  const _BoardingFilters();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Row(
        children: [
          Expanded(
            child: BlocBuilder<PetCubit, PetState>(
              buildWhen: (previous, current) =>
                  current is GetOwnerPetsSuccessState ||
                  current is PetCreateSuccessState ||
                  current is DeletePetSuccessState,
              builder: (context, state) {
                final pets = PetCubit.get(context).pets;
                return buildPetFilterBoarding(context, pets);
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<LayoutCubit, LayoutState>(
              buildWhen: (previous, current) =>
                  current is BoardingFiltered || current is GetBoardingEntriesSuccess,
              builder: (context, state) => buildStateFilterBoarding(context),
            ),
          ),
          BlocBuilder<BoardingCubit, BoardingState>(
            buildWhen: (previous, current) =>
                current is BoardingFiltered || current is GetBoardingEntriesSuccess,
            builder: (context, state) {
              return Visibility(
                visible: state is BoardingFiltered,
                child: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    Future.microtask(() {
                      BoardingCubit.get(context).clearFilters();
                    });
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BoardingList extends StatefulWidget {
  final BoardingCubit boardingCubit;
  final BoardingState state;

  const _BoardingList({required this.boardingCubit, required this.state});

  @override
  State<_BoardingList> createState() => _BoardingListState();
}

class _BoardingListState extends State<_BoardingList> with PaginationMixin {
  List<dynamic> _cachedEntries = [];

  @override
  void initState() {
    super.initState();
    initPagination();
  }

  @override
  void dispose() {
    disposePagination();
    super.dispose();
  }

  @override
  void loadMoreData() {
    Future.delayed(const Duration(milliseconds: 100), () {
      setLoadingMore(false);
    });
  }

  @override
  int _getTotalItems() => _cachedEntries.length;

  List<dynamic> _getEntries() {
    final entries = widget.state is BoardingFiltered
        ? (widget.state as BoardingFiltered).filteredEntries
        : widget.boardingCubit.boardingEntries;

    if (_cachedEntries != entries) {
      _cachedEntries = entries;
      // schedule resetPagination after current frame to avoid calling setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) resetPagination();
      });
    }

    return _cachedEntries;
  }

  @override
  Widget build(BuildContext context) {
    final entries = _getEntries();

    if (entries.isEmpty) return emptyBoarding(context);

    final isDarkMode = MainCubit.get(context).isDark;

    final itemsToShow = (currentPage * _AppointmentConstants.pageSize).clamp(0, entries.length);
    final maxItems = _AppointmentConstants.maxVisibleItems;
    final displayed = entries.sublist(0, itemsToShow.clamp(0, maxItems));

    return RefreshIndicator(
      onRefresh: () async {
        resetPagination();
        await widget.boardingCubit.getBoardingEntries(true);
      },
      child: ListView.builder(
        key: const PageStorageKey('boarding_list'),
        controller: scrollController,
        itemCount: displayed.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < displayed.length) {
            return RepaintBoundary(
              key: ValueKey('boarding_${displayed[index].id}_$index'),
              child: BoardingCard(
                isDarkMode: isDarkMode,
                entry: displayed[index],
                cubit: widget.boardingCubit,
              ),
            );
          }
          if (index == displayed.length && isLoadingMore) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
          return const SizedBox.shrink();
        },
        physics: const AlwaysScrollableScrollPhysics(),
        addAutomaticKeepAlives: true,
        addRepaintBoundaries: true,
        addSemanticIndexes: false,
        cacheExtent: 100.0,
        itemExtent: 300.0,
      ),
    );
  }
}
