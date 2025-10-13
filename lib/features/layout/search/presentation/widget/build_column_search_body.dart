// search_widgets.dart
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/layout/search/presentation/widget/youtube_card_widget.dart';
import '../controller/search_cubit.dart';
import 'build_details_content_search.dart';

Widget buildColumnSearchBody(
  SearchCubit cubit,
  SearchState state,
  lottie,
  context,
) {
  return SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: Column(
      children: [
        MyTextForm(
          controller: cubit.searchController,
          onFieldSubmitted: (value) {
            // print("Searching for: $value");
            if (value.isNotEmpty) {
              // print("Searching for: $value");
              cubit
                  .getSearchList(); // Make sure this method filters results based on the input
            }
          },
          prefixIcon: const Icon(IconlyLight.search, size: 14),
          enable: false,
          hintText:
              isArabic()
                  ? 'أبحث عن العيادة باستخدام الكود'
                  : 'Search with clinic code',
          obscureText: false,
        ),
        if (state is SearchLoading || state is FollowLoading)
          const LinearProgressIndicator(),
        SizedBox(height: 20),
        if (cubit.searchController.text.isEmpty)
          YoutubeCardWidget(
            videoImage: 'assets/squeak_intro.png',
            videoUrl:
                'https://www.youtube.com/watch?v=fb1f8-ZE-fE&list=PLaXhNu0x-iCSzM9AhzBUVc-n5JnNpC_MQ',
          ),
        SizedBox(height: 20),
        if (state is SearchSuccess && cubit.searchList.isNotEmpty)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return buildDetailsContentSearch(
                cubit.searchList[index],
                cubit,
                context,
                index,
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 12);
            },
            itemCount: cubit.searchList.length,
          ),
        if (state is SearchSuccess && cubit.searchList.isEmpty)
          Column(
            children: [
              TextButton(
                onPressed: () {
                  cubit.getSearchList();
                },
                child: Text("test search"),
              ),
              Lottie.network(
                'https://lottie.host/0eca7b9f-7dbf-4793-b6e0-8962b136f262/j194YSoHmq.json',
                height: ResponsiveScreen.isMobile(context) ? 400 : 100,
                repeat: false,
              ),
              const SizedBox(height: 10),
              Text(isArabic() ? "لا يوجد نتائج" : "No Results Found"),
            ],
          ),
      ],
    ),
  );
}

