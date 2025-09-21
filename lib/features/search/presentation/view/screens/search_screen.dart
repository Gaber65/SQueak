import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:squeak/core/service/global_function/format_utils.dart';
import 'package:squeak/core/service/main_service/presentation/controller/main_cubit/main_cubit.dart';
import 'package:squeak/core/service/service_locator/service_locator.dart';
import 'package:squeak/core/utils/theme/color_mangment/color_manager.dart';
import 'package:squeak/core/utils/theme/fonts/font_styles.dart';
import 'package:squeak/core/utils/theme/navigation_helper/navigation.dart';
import 'package:squeak/features/auth/get_started/presentation/view/screnns/welcome_to_squek.dart';
import 'package:squeak/features/layout/layout/presentation/cubit/layout_cubit.dart';
import 'package:squeak/features/pets/presentation/controller/pet_cubit.dart';
import 'package:squeak/generated/l10n.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PetCubit>()..getAllSpecies(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,

          title: Text(S.of(context).findPetFriends),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(12),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildSearchTextField(context)),
              BlocConsumer<PetCubit, PetState>(
                listener: (context, state) {},
                builder: (context, state) {
                  final cubit = PetCubit.get(context);
                  if (state is GetAllSpeciesLoadingState) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16,
                          ),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        );
                      }, childCount: 1),
                    );
                  }
                  return SliverToBoxAdapter(
                    child: SizedBox(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: cubit.species.length,
                        itemBuilder: (context, index) {
                          final isSelected = index == selectedIndex;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? ColorManager.primaryColor
                                        : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              width: 100,
                              margin: const EdgeInsets.all(8),
                              child: Center(
                                child: Text(
                                  cubit.species[index].type,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),

              SliverToBoxAdapter(child: SizedBox(height: 12)),
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    Icon(Icons.search, size: 32),
                    SizedBox(width: 6),
                    Text('Search Results', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: const CircleAvatar(radius: 26),
                          title: Text('Buddy'),
                          subtitle: const Text(
                            'Golden Retriever • 3 years old',
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.pets, size: 16, color: Colors.white),
                                SizedBox(width: 4),
                                Text(
                                  "Adopt",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Row(
                            children: const [
                              Icon(Icons.not_listed_location_sharp),
                              SizedBox(width: 4),
                              Text('Egypt'),
                              SizedBox(width: 8),
                              Icon(Icons.people),
                              SizedBox(width: 4),
                              Text('15 Friends'),
                              SizedBox(width: 8),
                              Icon(Icons.ac_unit),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Row(
                            children: const [
                              CircleAvatar(radius: 12),
                              CircleAvatar(radius: 12),
                              SizedBox(width: 12),
                              Text('2 Mutual Friends'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                navigateToScreen(context, WelcomeToSquek());
                              },
                              child: Container(
                                margin: const EdgeInsets.all(12),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: Colors.green,
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.check, color: Colors.white),
                                    SizedBox(width: 6),
                                    Text(
                                      'Send Request',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueAccent),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.remove_red_eye),
                                  SizedBox(width: 6),
                                  Text('View Profile'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }, childCount: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText:
              isArabic() ? 'ابحث بالاسم او الرقم' : 'Search by name or phone',
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
            fontColor:
                MainCubit.get(context).isDark
                    ? Colors.white54
                    : const Color.fromRGBO(0, 0, 0, .3),
          ),
          fillColor:
              MainCubit.get(context).isDark
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
}
