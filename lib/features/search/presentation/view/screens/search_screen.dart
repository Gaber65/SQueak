import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:squeak/core/service/global_function/format_utils.dart';
import 'package:squeak/core/service/main_service/presentation/controller/main_cubit/main_cubit.dart';
import 'package:squeak/core/service/service_locator/service_locator.dart';
import 'package:squeak/core/utils/theme/color_mangment/color_manager.dart';
import 'package:squeak/core/utils/theme/fonts/font_styles.dart';
import 'package:squeak/core/utils/theme/navigation_helper/navigation.dart';
import 'package:squeak/features/auth/get_started/presentation/view/screnns/welcome_to_squek.dart';
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
    final screen = MediaQuery.of(context).size; // get width & height

    return BlocProvider(
      create: (context) => sl<PetCubit>()..getAllSpecies(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            S.of(context).findPetFriends,
            style: TextStyle(fontSize: screen.width * 0.045),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(screen.width * 0.03),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildSearchTextField(context)),

              /// Species List
              BlocConsumer<PetCubit, PetState>(
                listener: (context, state) {},
                builder: (context, state) {
                  final cubit = PetCubit.get(context);

                  if (state is GetAllSpeciesLoadingState) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: screen.height * 0.01,
                            horizontal: screen.width * 0.04,
                          ),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              height: screen.height * 0.12,
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
                      height: screen.height * 0.08,
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
                              width: screen.width * 0.25,
                              margin: EdgeInsets.all(screen.width * 0.02),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? ColorManager.primaryColor
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: FittedBox(
                                  child: Text(
                                    cubit.species[index].type,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
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

              SliverToBoxAdapter(child: SizedBox(height: screen.height * 0.015)),

              /// Search Results Header
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    Icon(Icons.search, size: screen.width * 0.07),
                    SizedBox(width: screen.width * 0.02),
                    Text(
                      'Search Results',
                      style: TextStyle(fontSize: screen.width * 0.04),
                    ),
                  ],
                ),
              ),

              /// Results List
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: screen.height * 0.012),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            radius: screen.width * 0.07,
                          ),
                          title: Text(
                            'Buddy',
                            style: TextStyle(fontSize: screen.width * 0.045),
                          ),
                          subtitle: Text(
                            'Golden Retriever • 3 years old',
                            style: TextStyle(fontSize: screen.width * 0.035),
                          ),
                          trailing: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screen.width * 0.03,
                              vertical: screen.height * 0.006,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.pets,
                                    size: screen.width * 0.04,
                                    color: Colors.white),
                                SizedBox(width: screen.width * 0.01),
                                Text(
                                  "Adopt",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screen.width * 0.035,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        /// Location + Friends
                        Padding(
                          padding: EdgeInsets.only(left: screen.width * 0.04),
                          child: Wrap(
                            spacing: screen.width * 0.02,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: const [
                              Icon(Icons.not_listed_location_sharp),
                              Text('Egypt'),
                              Icon(Icons.people),
                              Text('15 Friends'),
                              Icon(Icons.ac_unit),
                            ],
                          ),
                        ),
                        SizedBox(height: screen.height * 0.015),

                        /// Mutual Friends
                        Padding(
                          padding: EdgeInsets.only(left: screen.width * 0.04),
                          child: Row(
                            children: [
                              CircleAvatar(radius: screen.width * 0.03),
                              SizedBox(width: screen.width * 0.01),
                              CircleAvatar(radius: screen.width * 0.03),
                              SizedBox(width: screen.width * 0.03),
                              Text(
                                '2 Mutual Friends',
                                style: TextStyle(fontSize: screen.width * 0.035),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screen.height * 0.015),

                        /// Action Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                // navigateToScreen(context, WelcomeToSquek());
                              },
                              child: Container(
                                margin: EdgeInsets.all(screen.width * 0.03),
                                padding: EdgeInsets.symmetric(
                                  horizontal: screen.width * 0.06,
                                  vertical: screen.height * 0.015,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: Colors.green,
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.check,
                                        color: Colors.white,
                                        size: screen.width * 0.04),
                                    SizedBox(width: screen.width * 0.015),
                                    Text(
                                      'Send Request',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screen.width * 0.035,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(screen.width * 0.03),
                              padding: EdgeInsets.symmetric(
                                horizontal: screen.width * 0.04,
                                vertical: screen.height * 0.012,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueAccent),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.remove_red_eye,
                                      size: screen.width * 0.04),
                                  SizedBox(width: screen.width * 0.015),
                                  Text(
                                    'View Profile',
                                    style: TextStyle(
                                      fontSize: screen.width * 0.035,
                                    ),
                                  ),
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
    final screen = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.all(screen.width * 0.02),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: isArabic()
              ? 'ابحث بالاسم او الرقم'
              : 'Search by name or phone',
          contentPadding: const EdgeInsets.all(0),
          filled: true,
          counterStyle: FontStyleThame.textStyle(
            context: context,
            fontSize: screen.width * 0.032,
          ),
          hintStyle: FontStyleThame.textStyle(
            context: context,
            fontSize: screen.width * 0.034,
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
}
