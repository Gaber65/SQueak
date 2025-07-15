import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../feeds/domain/entities/pet_mating_model.dart';
import '../widgets/pet_profile_header.dart';
import '../widgets/pet_tabs_section.dart';
import '../widgets/status_manager_dialog.dart';


class PetProfileScreen extends StatefulWidget {
  final bool isDarkMode;

  const PetProfileScreen({
    super.key,
    this.isDarkMode = false,
  });

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  Color get _backgroundColor => widget.isDarkMode
      ? Colors.grey.shade900
      : Colors.grey.shade50;

  Color get _textPrimaryColor => widget.isDarkMode
      ? Colors.white
      : Colors.black87;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  void _showStatusManager(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const StatusManagerDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pet = PetMating(
      id: 'available-2',
      name: 'Max',
      breed: 'German Shepherd',
      gender: 'Male',
      age: '3 years',
      description: 'Very gentle and well-trained',
      profilePicture: 'assets/images/max.jpg',
      status: PetMatingStatus.onMating,
    );

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    PetProfileHeader(
                      pet: pet,
                      isDarkMode: widget.isDarkMode,
                      onEditPressed: () => _showStatusManager(context),
                    ),
                    const SizedBox(height: 20),
                    PetTabsSection(pet: pet, isDarkMode: widget.isDarkMode),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

// Usage functions (can be placed in a separate utility file if desired)
void showEnhancedPetProfile(BuildContext context, {bool isDarkMode = false}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PetProfileScreen(isDarkMode: isDarkMode),
    ),
  );
}

void showThemeAwarePetProfile(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  showEnhancedPetProfile(context, isDarkMode: isDark);
}