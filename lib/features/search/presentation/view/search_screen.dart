
// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:squeak/core/service/service_locator/service_locator.dart';
import 'package:squeak/core/utils/theme/color_mangment/color_manager.dart';
import 'package:squeak/features/pets/presentation/controller/pet_cubit.dart';
import 'package:squeak/generated/l10n.dart';
import '../../../../core/service/main_service/presentation/controller/main_cubit/main_cubit.dart';
import '../../../pets/domain/entities/pet_entity.dart';
import '../widgets/pet_box.dart';
import '../widgets/search_text_field.dart';
import '../widgets/species_selector_sheet.dart';


class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  int selectedIndex = 0;
  final TextEditingController searchController = TextEditingController();
  bool _isLoadingOtherSpecies = false;
  String selectedSpeciesName = "";
  String selectedSpeciesId = "";

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final isTablet = screen.width > 600;
    final mainCubit = context.read<MainCubit>();

    return BlocProvider(
      create: (context) => sl<PetCubit>()..getAllSpecies(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: mainCubit.isDark ? Colors.grey[900] : Colors.white,
          title: Text(
            S.of(context).findPetFriends,
            style: TextStyle(
              fontSize: isTablet ? 24 : screen.width * 0.045,
              fontWeight: FontWeight.w600,
              color: mainCubit.isDark ? Colors.white : Colors.black87,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: mainCubit.isDark ? Colors.grey[900] : ColorManager.white,
        body: CustomScrollView(
          slivers: [
            // Search Section
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.fromLTRB(
                  screen.width * 0.04,
                  screen.height * 0.02,
                  screen.width * 0.04,
                  screen.height * 0.01,
                ),
                decoration: BoxDecoration(
                  color: mainCubit.isDark ? Colors.grey[850] : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(mainCubit.isDark ? 0.2 : 0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(screen.width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Search for Pet Friends',
                        style: TextStyle(
                          fontSize: isTablet ? 18 : screen.width * 0.042,
                          fontWeight: FontWeight.w600,
                          color: mainCubit.isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      SizedBox(height: screen.height * 0.015),
                      SearchTextField(
                        controller: searchController,
                        isTablet: isTablet,
                        screen: screen,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Filter Section
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.fromLTRB(
                  screen.width * 0.04,
                  screen.height * 0.01,
                  screen.width * 0.04,
                  screen.height * 0.02,
                ),
                decoration: BoxDecoration(
                  color: mainCubit.isDark ? Colors.grey[850] : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(mainCubit.isDark ? 0.2 : 0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(screen.width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Filter by Pet Type',
                        style: TextStyle(
                          fontSize: isTablet ? 18 : screen.width * 0.042,
                          fontWeight: FontWeight.w600,
                          color: mainCubit.isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      SizedBox(height: screen.height * 0.02),
                      Builder(
                        builder: (blocContext) => Row(
                          children: [
                            Expanded(
                              child: PetBox(
                                label: "Cat",
                                icon: FontAwesomeIcons.cat,
                                index: 0,
                                selectedIndex: selectedIndex,
                                isTablet: isTablet,
                                screen: screen,
                                onTap: () => setState(() => selectedIndex = 0),
                              ),
                            ),
                            SizedBox(width: screen.width * 0.03),
                            Expanded(
                              child: PetBox(
                                label: "Dog",
                                icon: FontAwesomeIcons.dog,
                                index: 1,
                                selectedIndex: selectedIndex,
                                isTablet: isTablet,
                                screen: screen,
                                onTap: () => setState(() => selectedIndex = 1),
                              ),
                            ),
                            SizedBox(width: screen.width * 0.03),
                            Expanded(
                              child: PetBox(
                                label: "Others",
                                icon: Icons.pets,
                                index: 2,
                                selectedIndex: selectedIndex,
                                isTablet: isTablet,
                                screen: screen,
                                isLoading: _isLoadingOtherSpecies,
                                selectedSpeciesName: selectedSpeciesName,
                                onTap: () => _handleOthersSelection(blocContext),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Results Section Header
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.fromLTRB(
                  screen.width * 0.04,
                  screen.height * 0.01,
                  screen.width * 0.04,
                  screen.height * 0.015,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.pets,
                      color: ColorManager.primaryColor,
                      size: isTablet ? 24 : screen.width * 0.05,
                    ),
                    SizedBox(width: screen.width * 0.02),
                    Text(
                      'Available Pet Friends',
                      style: TextStyle(
                        fontSize: isTablet ? 20 : screen.width * 0.045,
                        fontWeight: FontWeight.w600,
                        color: mainCubit.isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Results List
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Container(
                  margin: EdgeInsets.fromLTRB(
                    screen.width * 0.04,
                    screen.height * 0.008,
                    screen.width * 0.04,
                    screen.height * 0.008,
                  ),
                  decoration: BoxDecoration(
                    color: mainCubit.isDark ? Colors.grey[850] : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(mainCubit.isDark ? 0.2 : 0.05),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screen.width * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            radius: isTablet ? 30 : screen.width * 0.07,
                            backgroundColor: mainCubit.isDark ? Colors.grey[700] : Colors.grey[300],
                            child: Icon(
                              Icons.pets,
                              color: mainCubit.isDark ? Colors.grey[400] : Colors.grey[600],
                              size: isTablet ? 24 : screen.width * 0.05,
                            ),
                          ),
                          title: Text(
                            'Buddy',
                            style: TextStyle(
                              fontSize: isTablet ? 18 : screen.width * 0.045,
                              fontWeight: FontWeight.w600,
                              color: mainCubit.isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.only(top: screen.height * 0.005),
                            child: Text(
                              'Golden Retriever • 3 years old',
                              style: TextStyle(
                                fontSize: isTablet ? 14 : screen.width * 0.035,
                                color: mainCubit.isDark ? Colors.grey[400] : Colors.grey[600],
                              ),
                            ),
                          ),
                          trailing: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screen.width * 0.03,
                              vertical: screen.height * 0.008,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.pets,
                                  size: isTablet ? 16 : screen.width * 0.035,
                                  color: Colors.white,
                                ),
                                SizedBox(width: screen.width * 0.01),
                                Text(
                                  "Adopt",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isTablet ? 12 : screen.width * 0.03,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: screen.height * 0.015),
                        Container(
                          padding: EdgeInsets.all(screen.width * 0.03),
                          decoration: BoxDecoration(
                            color: mainCubit.isDark ? Colors.grey[800] : Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Wrap(
                            spacing: screen.width * 0.04,
                            runSpacing: screen.height * 0.01,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: isTablet ? 16 : screen.width * 0.04,
                                    color: Colors.orange,
                                  ),
                                  SizedBox(width: screen.width * 0.01),
                                  Text(
                                    'Egypt',
                                    style: TextStyle(
                                      fontSize: isTablet ? 14 : screen.width * 0.035,
                                      fontWeight: FontWeight.w500,
                                      color: mainCubit.isDark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.people,
                                    size: isTablet ? 16 : screen.width * 0.04,
                                    color: Colors.green,
                                  ),
                                  SizedBox(width: screen.width * 0.01),
                                  Text(
                                    '15 Friends',
                                    style: TextStyle(
                                      fontSize: isTablet ? 14 : screen.width * 0.035,
                                      fontWeight: FontWeight.w500,
                                      color: mainCubit.isDark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screen.height * 0.015),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: isTablet ? 16 : screen.width * 0.025,
                              backgroundColor: Colors.blue,
                            ),
                            SizedBox(width: screen.width * 0.01),
                            CircleAvatar(
                              radius: isTablet ? 16 : screen.width * 0.025,
                              backgroundColor: Colors.purple,
                            ),
                            SizedBox(width: screen.width * 0.03),
                            Text(
                              '2 Mutual Friends',
                              style: TextStyle(
                                fontSize: isTablet ? 14 : screen.width * 0.035,
                                color: mainCubit.isDark ? Colors.grey[400] : Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screen.height * 0.02),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  // navigateToScreen(context, WelcomeToSquek());
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: screen.height * 0.015,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.green,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: isTablet ? 18 : screen.width * 0.04,
                                      ),
                                      SizedBox(width: screen.width * 0.02),
                                      Text(
                                        'Send Request',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: isTablet ? 14 : screen.width * 0.035,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: screen.width * 0.03),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: screen.height * 0.015,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueAccent),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.remove_red_eye,
                                      size: isTablet ? 18 : screen.width * 0.04,
                                      color: Colors.blueAccent,
                                    ),
                                    SizedBox(width: screen.width * 0.02),
                                    Text(
                                      'View Profile',
                                      style: TextStyle(
                                        fontSize: isTablet ? 14 : screen.width * 0.035,
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }, childCount: 10),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: screen.height * 0.02),
            ),
          ],
        ),
      ),
    );
  }

  int _mapSpeciesToIndex(String speciesType) {
    final s = speciesType.toLowerCase();
    if (s.contains('dog')) return 1;
    if (s.contains('coww')) return 0;
    return 2;
  }

  Future<void> _handleOthersSelection(BuildContext context) async {
    if (_isLoadingOtherSpecies) return;

    setState(() {
      _isLoadingOtherSpecies = true;
    });

    try {
      final petCubit = context.read<PetCubit>();
      if (petCubit.species.isEmpty) {
        await petCubit.getAllSpecies();
      }
      await Future.delayed(const Duration(milliseconds: 300));
      await showSpeciesSelector(
        context,
        petCubit,
        onSelected: (SpeciesEntity species) {
          setState(() {
            selectedSpeciesName = species.type;
            selectedSpeciesId = species.id;
            selectedIndex = _mapSpeciesToIndex(species.type);
          });
        },
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load species list. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingOtherSpecies = false;
        });
      }
    }
  }
}