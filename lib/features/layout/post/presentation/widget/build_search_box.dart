import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/service/global_widget/toast.dart';
import '../../../../../core/service/service_locator/service_locator.dart';
import '../../../../../core/utils/export_path/export_files.dart';
import '../../../../../core/utils/theme/navigation_helper/navigation.dart';
import '../../../../vetcare/presenation/view/pet_merge_screen.dart';
import '../../../search/presentation/controller/search_cubit.dart';
import '../../../search/presentation/widget/build_column_search_body.dart';
import '../controller/post_cubit.dart';

Padding buildSearchBox(PostCubit cubit) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: BlocProvider(
      create: (context) => sl<SearchCubit>()..getSupplier(),
      child: BlocConsumer<SearchCubit, SearchState>(
        listener: (context, state) {
          if (state is FollowError) {
            errorToast(
              context,
              extractFirstError(state.error),
            );
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
              sl<SearchCubit>().getSupplier();
              cubit.init();
            }
          }
        },
        builder: (context, state) {
          var cubit = SearchCubit.get(context);
          return buildColumnSearchBody(
            cubit,
            state,
            'https://lottie.host/e4e07617-64ba-4c41-89a4-c0f752e83267/aRzu88O6ZO.json',
            context,
          );
        },
      ),
    ),
  );
}
