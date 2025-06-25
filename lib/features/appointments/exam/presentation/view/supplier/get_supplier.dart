import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../../../../layout/search/presentation/controller/search_cubit.dart';
import '../../../../../layout/search/presentation/widget/build_column_search_body.dart';
import '../../../../../pets/domain/entities/pet_entity.dart';
import '../../../../../vetcare/presenation/view/pet_merge_screen.dart';
import '../../controller/clinic/appointment_cubit.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import '../availability/availability_screen.dart';

class MySupplierScreen extends StatelessWidget {
  const MySupplierScreen({super.key, required this.petSelectFromIcon});

  final PetEntities? petSelectFromIcon;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AppointmentCubit>()..getSuppliersList(),
      child: BlocConsumer<AppointmentCubit, AppointmentState>(
        listener: (context, state) {
          // Handle state changes if needed
        },
        builder: (context, state) {
          var cubit = AppointmentCubit.get(context);
          return Scaffold(
            appBar: _buildAppBar(context),
            body: _buildBody(cubit, state, context),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(S.of(context).yourClinic),
      automaticallyImplyLeading: false,
      leading: petSelectFromIcon == null
          ? null
          : IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => _handleBackPressed(context),
      ),
    );
  }

  void _handleBackPressed(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        exit(0);
      }
    }
  }

  Widget _buildBody(AppointmentCubit cubit, AppointmentState state, BuildContext context) {
    // Show shimmer when loading
    if (state is GetSupplierLoadingScreen && cubit.suppliers == null) {
      return _buildShimmerLoading(context);
    }

    // Show search screen when no suppliers
    if (cubit.suppliers == null || cubit.suppliers!.data.isEmpty) {
      return _buildSearchSection(cubit, context);
    }

    // Show suppliers list
    return _buildSuppliersSection(cubit, context);
  }

  Widget _buildShimmerLoading(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Search field shimmer
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Shimmer.fromColors(
            baseColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
            highlightColor: isDark ? Colors.grey.shade700 : Colors.grey.shade100,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade900 : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        // List shimmer
        Expanded(
          child: ListView.builder(
            itemCount: 8, // Show 8 shimmer items
            itemBuilder: (context, index) => _buildShimmerItem(context),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerItem(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Shimmer.fromColors(
          baseColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
          highlightColor: isDark ? Colors.grey.shade700 : Colors.grey.shade100,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Avatar shimmer
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Name shimmer
                      Container(
                        width: 120,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Address shimmer
                      Row(
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Arrow shimmer
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection(AppointmentCubit cubit, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: BlocProvider(
        create: (context) => sl<SearchCubit>(),
        child: BlocConsumer<SearchCubit, SearchState>(
          listener: (context, state) {
            if (state is FollowError) {
              errorToast(context, extractFirstError(state.error));
            }
            if (state is FollowSuccess) {
              if (state.isHavePet) {
                navigateAndFinish(
                  context,
                  PetMergeScreen(
                    code: SearchCubit.get(context).searchController.text,
                    isNavigation: true,
                  ),
                );
              } else {
                cubit.getSuppliersList();
              }
            }
          },
          builder: (context, state) {
            var searchCubit = SearchCubit.get(context);
            return buildColumnSearchBody(
              searchCubit,
              state,
              'https://lottie.host/2f7e7695-4b78-4226-bd69-20f23959b1e9/LTteLFlERO.json',
              context,
            );
          },
        ),
      ),
    );
  }

  Widget _buildSuppliersSection(AppointmentCubit cubit, BuildContext context) {
    return Column(
      children: [
        _buildSearchTextField(cubit, context),
        _buildSuppliersList(cubit, context),
      ],
    );
  }

  Widget _buildSearchTextField(AppointmentCubit cubit, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: cubit.searchController,
        onChanged: cubit.filterSuppliers,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: isArabic() ? 'ابحث بالاسم او الكود' : 'Search by name or code',
          contentPadding: const EdgeInsets.all(0),
          filled: true,
          counterStyle: FontStyleThame.textStyle(
            context: context,
            fontSize: 13,
          ),
          hintStyle: FontStyleThame.textStyle(
            context: context,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            fontColor: MainCubit.get(context).isDark
                ? Colors.white54
                : const Color.fromRGBO(0, 0, 0, .3),
          ),
          fillColor: MainCubit.get(context).isDark
              ? Colors.black26
              : Colors.grey.shade200,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildSuppliersList(AppointmentCubit cubit, BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: cubit.filteredSuppliers.length,
        itemBuilder: (context, index) => _buildSupplierItem(cubit, index, context),
      ),
    );
  }

  Widget _buildSupplierItem(AppointmentCubit cubit, int index, BuildContext context) {
    final supplier = cubit.filteredSuppliers[index];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 80,
        decoration: Decorations.kDecorationBoxShadow(context: context),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _navigateToAvailability(supplier, context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                _buildSupplierAvatar(supplier, context),
                const SizedBox(width: 10),
                _buildSupplierInfo(supplier, context),
                const Spacer(),
                _buildArrowIcon(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSupplierAvatar(dynamic supplier, BuildContext context) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: MainCubit.get(context).isDark ? Colors.black38 : Colors.white,
      backgroundImage: NetworkImage(imageUrl + supplier.data.image),
    );
  }

  Widget _buildSupplierInfo(dynamic supplier, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          supplier.data.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Icon(
              IconlyBold.location,
              color: ColorManager.secondColor,
              size: 18,
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * .5,
              child: Text(
                '${supplier.data.address}, ${supplier.data.city}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildArrowIcon() {
    return Icon(
      isArabic() ? Icons.keyboard_arrow_left : Icons.keyboard_arrow_right,
      color: Colors.grey,
    );
  }

  void _navigateToAvailability(dynamic supplier, BuildContext context) {
    navigateToScreen(
      context,
      AvailabilityScreen(
        clinicInfo: supplier,
        petSelectFromIcon: petSelectFromIcon,
      ),
    );
  }
}