import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:lottie/lottie.dart';
import 'package:squeak/core/constant/global_widget/responsive_screen.dart';
import 'package:squeak/core/thames/decorations.dart';
import 'package:squeak/core/thames/styles.dart';
import 'package:squeak/features/layout/layout.dart';
import 'package:squeak/features/layout/controller/SearchCubit/search_cubit.dart';
import 'package:squeak/features/layout/models/clinic_model.dart';
import 'package:squeak/features/vetcare/view/pet_merge_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constant/global_function/custom_text_form_field.dart';
import '../../../../core/constant/global_function/global_function.dart';
import '../../../../core/constant/global_widget/toast.dart';
import '../../../../core/helper/remotely/end-points.dart';
import '../../../../generated/l10n.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: true,
      create: (context) => SearchCubit()..init(),
      child: BlocConsumer<SearchCubit, SearchState>(
        listener: (context, state) {
          if (state is FollowError) {
            errorToast(
              context,
              state.error.errors.isNotEmpty
                  ? state.error.errors.values.first.first
                  : state.error.message,
            );
          }

          if (state is FollowSuccess) {
            if (state.isHavePet) {
              navigateAndFinish(
                context,
                PetMergeScreen(
                  Code: SearchCubit.get(context).searchController.text,
                  isNavigation: true,
                ),
              );
            } else {
              navigateAndFinish(context, LayoutScreen());
            }
          }
        },
        builder: (context, state) {
          var cubit = SearchCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).search),
            ),
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

Widget buildDetailsContent(Clinic entities, SearchCubit cubit, context, index) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 5),
    width: double.infinity,
    padding: const EdgeInsets.all(10),
    decoration: Decorations.kDecorationBoxShadow(context: context),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              entities.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontFamily: 'bold', fontSize: 15),
            ),
            const Spacer(),
            // Text(
            //   entities.specialities.isNotEmpty
            //       ? entities.specialities[0].name
            //       : '',
            //   overflow: TextOverflow.ellipsis,
            //   style: const TextStyle(fontFamily: 'bold', fontSize: 15),
            // ),
            const Spacer(),
            CircleAvatar(
              backgroundImage: NetworkImage(
                '$imageUrl${entities.image}',
              ),
              radius: 20,
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Row(
                children: [
                  const Icon(
                    Icons.location_city,
                    size: 14,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${entities.location.length > 10 ? entities.location.substring(0, 10) : entities.location} , ${entities.city.length > 10 ? entities.city.substring(0, 10) : entities.city}  , ${entities.address.length > 10 ? entities.address.substring(0, 10) : entities.address} ',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, fontFamily: 'bold'),
                  ),
                ],
              ),
            ),
            const Spacer(),
            CircleAvatar(
              backgroundColor: cubit.isFollowBefore ? Colors.red : Colors.green,
              radius: 15,
              child: IconButton(
                iconSize: 15,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: cubit.isFollowBefore
                            ? Text(S.of(context).unfollowConfirmation)
                            : Text(S.of(context).followConfirmation),
                        content: Container(
                          width: MediaQuery.of(context).size.width + 100,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    entities.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  const Spacer(),
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        '$imageUrl${entities.image}'),
                                    radius: 20,
                                  ),
                                ],
                              ),
                              Text(
                                entities.specialities.isNotEmpty
                                    ? entities.specialities[0].name
                                    : '',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontFamily: 'bold', fontSize: 15),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    IconlyLight.location,
                                    size: 14,
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.sizeOf(context).width / 2,
                                    child: Text(
                                      '${entities.location} , ${entities.address} , ${entities.city} ',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 12, fontFamily: 'bold'),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    IconlyLight.call,
                                    size: 14,
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    entities.phone,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: TextButton(
                              child: Text(
                                cubit.isFollowBefore
                                    ? S.of(context).unfollow
                                    : isArabic()
                                        ? "متابعة"
                                        : "Follow",
                                style: TextStyle(color: Colors.green),
                              ),
                              onPressed: () {
                                if (cubit.isFollowBefore) {
                                  cubit.unfollowClinic(entities.id);
                                } else {
                                  cubit.followClinic(entities.id, context);
                                }
                                Navigator.of(context).pop(true);
                              },
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(
                              isArabic() ? "الغاء " : "cancel",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.person_add),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget buildColumnSearchBody(
    SearchCubit cubit, SearchState state, lottie, context) {
  return SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: Column(
      children: [
        MyTextForm(
          controller: cubit.searchController,
          onFieldSubmitted: (value) {
            print("Searching for: $value");
            if (value.isNotEmpty) {
              print("Searching for: $value");
              cubit
                  .getSearchList(); // Make sure this method filters results based on the input
            }
          },
          prefixIcon: const Icon(
            IconlyLight.search,
            size: 14,
          ),
          enable: false,
          hintText: isArabic()
              ? 'أبحث عن العيادة باستخدام الكود'
              : 'Search with clinic code',
          obscureText: false,
        ),
        if (state is SearchLoading || state is FollowLoading)
          const LinearProgressIndicator(),
        SizedBox(
          height: 20,
        ),
        if (cubit.searchController.text.isEmpty)
          YoutubeCardWidget(
            videoImage: 'assets/squeak_intro.png',
            videoUrl:
                'https://www.youtube.com/watch?v=fb1f8-ZE-fE&list=PLaXhNu0x-iCSzM9AhzBUVc-n5JnNpC_MQ',
          ),
        SizedBox(
          height: 20,
        ),
        if (state is SearchSuccess && cubit.searchList.isNotEmpty)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return buildDetailsContent(
                cubit.searchList[index],
                cubit,
                context,
                index,
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 12,
              );
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
                child: Text(
                  "test search",
                ),
              ),
              Lottie.network(
                'https://lottie.host/0eca7b9f-7dbf-4793-b6e0-8962b136f262/j194YSoHmq.json',
                height: ResponsiveScreen.isMobile(context) ? 400 : 100,
                repeat: false,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(isArabic() ? "لا يوجد نتائج" : "No Results Found"),
            ],
          ),
      ],
    ),
  );
}

class YoutubeCardWidget extends StatelessWidget {
  const YoutubeCardWidget({
    super.key,
    required this.videoImage,
    required this.videoUrl,
  });

  final String videoImage;
  final String videoUrl;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigateToReference(
          url: videoUrl,
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      8,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      8,
                    ),
                    child: Image.asset(
                      videoImage,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Opacity(
                  opacity: 0.8,
                  child: SizedBox(
                    // color: Colors.red,
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Image.asset(
                      'assets/youtube_logo.png',
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
        ],
      ),
    );
  }
}

// open the reference with urlLauncher
Future<void> navigateToReference({
  required url,
}) async {
  final Uri _urla = Uri.parse(url);
  if (!await launchUrl(_urla)) {
    throw Exception(
      'Could not launch $_urla',
    );
  }
}
