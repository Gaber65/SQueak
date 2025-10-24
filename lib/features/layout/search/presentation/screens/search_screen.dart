import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../vetcare/presenation/view/pet_merge_screen.dart';
import '../controller/search_cubit.dart';
import '../widget/build_column_search_body.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: true,
      create: (context) => sl<SearchCubit>()..getSupplier(),
      child: BlocConsumer<SearchCubit, SearchState>(
        listener: (context, state) {
          if (state is FollowError) {
            if (context.mounted) {
              errorToast(
                context,
                extractFirstError(state.error),
              );
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
              if (context.mounted) {
                navigateAndFinish(context, LayoutScreen());
              }
            }
          }
        },
        builder: (context, state) {
          if (!context.mounted) return const Scaffold();
          var cubit = context.read<SearchCubit>();
          return Scaffold(
            appBar: AppBar(title: Text(S.of(context).search)),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: buildColumnSearchBody(
                cubit,
                state,
                'https://lottie.host/e4e07617-64ba-4c41-89a4-c0f752e83267/aRzu88O6ZO.json',
                context,
              ),
            ),
          );
        },
      ),
    );
  }
}
