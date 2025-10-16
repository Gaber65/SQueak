import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/service/global_function/format_utils.dart';
import 'package:squeak/features/friendship/presentation/controllers/pet_friend_cubit.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import '../../../../../friendship/presentation/widgets/FriendsTab.dart';
import '../../../../../friendship/presentation/widgets/SectionHeaderWidget.dart';
import 'pets_suggetion_card.dart';

class StartSuggetTab extends StatelessWidget {
  final List<PetEntities> suggested;
  final String specieId;
  final String activePetId; // Add this parameter

  const StartSuggetTab({
    super.key,
    required this.suggested,
    required this.specieId,
    required this.activePetId, // Add this parameter
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh:
          () => context.read<PetFriendsCubit>().loadSuggestedFriends(
            specieId: specieId,
          ),
      child:
          suggested.isEmpty
              ? ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  const SizedBox(height: 150),
                  AmazingEmptyList(
                    onPressed:
                        () => context
                            .read<PetFriendsCubit>()
                            .loadSuggestedFriends(specieId: specieId),
                    icon: IconlyBold.search,
                    message:
                        isArabic()
                            ? "لا توجد اقتراحات حالياً"
                            : "No Suggestions Yet",
                  ),
                ],
              )
              : CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: SectionHeader(
                        icon: Icons.pets,
                        title:
                            isArabic()
                                ? 'الأصدقاء المقترحون'
                                : 'Suggested Friends',
                        count: suggested.length,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    sliver: SliverLayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount = 1;
                        if (constraints.crossAxisExtent > 900) {
                          crossAxisCount = 3;
                        } else if (constraints.crossAxisExtent > 600) {
                          crossAxisCount = 2;
                        }

                        return SliverGrid(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            return AnimatedItem(
                              index: index,
                              child: PetsSuggetionRequestCard(
                                pet: suggested[index],
                                activePetId: activePetId, // Use the correct pet ID
                              ),
                            );
                          }, childCount: suggested.length),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio:
                                    crossAxisCount == 1 ? 2.2 : 0.8,
                              ),
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}