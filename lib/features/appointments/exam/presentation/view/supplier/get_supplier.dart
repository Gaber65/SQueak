import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/global_widget/toast.dart';
import 'package:squeak/features/appointments/exam/presentation/view/supplier/widgets/shimmer_loading.dart';
import 'package:squeak/features/layout/search/presentation/controller/search_cubit.dart';
import 'package:squeak/features/layout/search/presentation/widget/build_column_search_body.dart';
import 'package:squeak/generated/l10n.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';

import '../../../../../../core/network/dio.dart';
import '../../../../../../core/service/service_locator/service_locator.dart';
import '../../../../../../core/utils/theme/navigation_helper/navigation.dart';
import '../../../../../pets/presentation/controller/pet_cubit.dart';
import '../../../../../vetcare/presenation/view/pet_merge_screen.dart';
import '../../controller/clinic/appointment_cubit.dart';
import 'widgets/suppliers_section.dart';

class MySupplierScreen extends StatelessWidget {
  const MySupplierScreen({super.key, required this.petSelectFromIcon});
  final PetEntities? petSelectFromIcon;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AppointmentCubit>()..getSuppliersList()),
        BlocProvider(create: (_) => sl<PetCubit>()..getOwnerPets()),
      ],
      child: BlocConsumer<AppointmentCubit, AppointmentState>(
        listener: (context, state) {
          if (state is UnFollowSuccess) {
            AppointmentCubit.get(context).suppliers?.data.remove(state.clinic);
          }
        },
        builder: (context, state) {
          final cubit = AppointmentCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(S.of(context).yourClinic),
            ),
            body: _buildBody(cubit, state, context),
          );
        },
      ),
    );
  }

  Widget _buildBody(
    AppointmentCubit cubit,
    AppointmentState state,
    BuildContext context,
  ) {
    if (state is GetSupplierLoadingScreen && cubit.suppliers == null) {
      return const ShimmerLoading();
    }

    if (cubit.suppliers == null || cubit.suppliers!.data.isEmpty) {
      return _buildSearchSection(cubit, context);
    }

    return SuppliersSection(
      cubit: cubit,
      state: state,
      petSelectFromIcon: petSelectFromIcon,
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
}
