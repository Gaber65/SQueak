import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import '../../../../../core/service/main_service/presentation/controller/main_cubit/main_cubit.dart';
import '../../domain/entities/pet_mating_model.dart';
import '../widgets/pet_card.dart';
import '../widgets/send_request_dialog.dart';


class PetFeedScreen extends StatelessWidget {
  const PetFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(
                color: MainCubit.get(context).isDark ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.8),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.09),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(IconlyBold.heart, color: Colors.pink.shade500),
                      const SizedBox(width: 8),
                      const Text(
                        'Welcome to Squeak!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Find the perfect match for your beloved pets. Connect, chat, and create beautiful families together.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _FeatureCard(
                          icon: Icons.pets,
                          title: 'Create Pet Profile',
                          subtitle: 'Add your pet\'s details and photos',
                          color: Colors.pink.shade500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _FeatureCard(
                          icon: Icons.favorite,
                          title: 'Find Matches',
                          subtitle: 'Discover compatible pets nearby',
                          color: Colors.red.shade500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _FeatureCard(
                          icon: Icons.message,
                          title: 'Start Chatting',
                          subtitle: 'Connect with other pet owners',
                          color: ColorManager.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Available Pets
          const Text(
            'Available Pets Near You',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pets looking for love in your area',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Pet List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: PetMating.availablePets.length,
            itemBuilder: (context, index) {
              final pet = PetMating.availablePets[index];
              return PetCardMating(
                pet: pet,
                onSendRequest: () => _showSendRequestDialog(context, pet),
                onViewProfile: () => _viewPetProfile(context, pet),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showSendRequestDialog(BuildContext context, pet) {
    showDialog(
      context: context,
      builder: (context) => SendRequestDialog(targetPet: pet,isDarkMode: MainCubit.get(context).isDark,),
    );
  }

  void _viewPetProfile(BuildContext context, pet) {
    // Navigate to pet profile view
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing ${pet.name}\'s profile')),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: Decorations.kDecorationBoxShadow(context: context),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
