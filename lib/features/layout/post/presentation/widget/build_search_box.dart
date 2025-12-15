import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/export_path/export_files.dart';
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
            if (context.mounted) {
              errorToast(context, extractFirstError(state.error));
            }
          }

          if (state is FollowSuccess) {
            CacheHelper.removeData('posts');

            if (state.isHavePet) {
              if (context.mounted) {
                final searchCubit = context.read<SearchCubit>();
                navigateAndFinish(
                  context,
                  PetMergeScreen(
                    code: searchCubit.searchController.text,
                    isNavigation: true,
                  ),
                );
              }
            } else {
              sl<SearchCubit>().getSupplier();
            }
          }
        },
        builder: (context, state) {
          if (!context.mounted) return const SizedBox.shrink();
          var cubit = context.read<SearchCubit>();
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
