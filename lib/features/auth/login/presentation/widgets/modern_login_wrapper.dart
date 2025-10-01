// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/auth/login/presentation/widgets/enhanced_login_widget.dart';
import 'package:squeak/features/auth/login/presentation/cubit/login_cubit.dart';

class ModernLoginHeader extends StatefulWidget {
  const ModernLoginHeader({super.key});

  @override
  State<ModernLoginHeader> createState() => _ModernLoginHeaderState();
}

class _ModernLoginHeaderState extends State<ModernLoginHeader>
    with TickerProviderStateMixin {
  late final AnimationController _pawAnimationController;
  late final AnimationController _mascotAnimationController;
  late final Animation<double> _pawFloatAnimation;
  late final Animation<double> _mascotBounceAnimation;

  @override
  void initState() {
    super.initState();

    _pawAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _pawFloatAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _pawAnimationController, curve: Curves.easeInOut),
    );

    _mascotAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _mascotBounceAnimation = Tween<double>(begin: 0.0, end: 5.0).animate(
      CurvedAnimation(
        parent: _mascotAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    debugPrint('Login animations temporarily disabled for memory optimization');
  }

  @override
  void dispose() {
    _pawAnimationController.dispose();
    _mascotAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.06,
        vertical: height * 0.03,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorManager.secondColor,
            ColorManager.secondColor.withOpacity(0.8),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Stack(
        children: [
          _buildFloatingPaw(
            top: height * 0.02,
            right: width * 0.08,
            angle: 0.3,
            size: width * 0.06,
            opacity: 0.3,
            reverse: false,
          ),
          _buildFloatingPaw(
            top: height * 0.1,
            left: width * 0.1,
            angle: -0.2,
            size: width * 0.05,
            opacity: 0.2,
            reverse: true,
          ),
          _buildFloatingPaw(
            top: height * 0.06,
            right: width * 0.2,
            angle: 0.5,
            size: width * 0.04,
            opacity: 0.25,
            factor: 0.7,
          ),
          Column(
            children: [
              _buildMascot(width),
              SizedBox(height: height * 0.02),

              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.01),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.pets, color: Colors.white, size: 16),
                  SizedBox(width: width * 0.02),
                  Text(
                    'Your furry friends are waiting for you!',
                    style: TextStyle(
                      fontSize: width * 0.04,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: width * 0.02),
                  const Icon(Icons.pets, color: Colors.white, size: 16),
                ],
              ),
              SizedBox(height: height * 0.005),

              Text(
                'Sign in to continue your pet care journey',
                style: TextStyle(
                  fontSize: width * 0.035,
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Reusable floating paw builder
  Widget _buildFloatingPaw({
    required double top,
    double? right,
    double? left,
    required double angle,
    required double size,
    required double opacity,
    bool reverse = false,
    double factor = 1.0,
  }) {
    return AnimatedBuilder(
      animation: _pawFloatAnimation,
      builder: (_, __) {
        final offset = _pawFloatAnimation.value * factor;
        return Positioned(
          top: reverse ? (top - offset) : (top + offset),
          right: right,
          left: left,
          child: Transform.rotate(
            angle: angle,
            child: Icon(
              Icons.pets,
              size: size,
              color: Colors.white.withOpacity(opacity),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMascot(double width) {
    return AnimatedBuilder(
      animation: _mascotBounceAnimation,
      builder: (_, __) {
        return Transform.translate(
          offset: Offset(0, -_mascotBounceAnimation.value),
          child: Container(
            width: width * 0.18,
            height: width * 0.18,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 25,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.pets,
                  size: 50,
                  color: ColorManager.secondColor,
                ),
                Positioned(
                  top: width * 0.03,
                  left: width * 0.03,
                  child: Icon(
                    Icons.favorite,
                    size: width * 0.025,
                    color: Colors.red.withOpacity(0.8),
                  ),
                ),
                Positioned(
                  top: width * 0.03,
                  right: width * 0.04,
                  child: Icon(
                    Icons.favorite,
                    size: width * 0.025,
                    color: Colors.red.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ModernLoginWrapper extends StatefulWidget {
  final LoginCubit cubit;
  const ModernLoginWrapper({super.key, required this.cubit});

  @override
  State<ModernLoginWrapper> createState() => _ModernLoginWrapperState();
}

class _ModernLoginWrapperState extends State<ModernLoginWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  Added: Use MediaQuery for responsive sizing
    final width = MediaQuery.of(context).size.width; // <-- Added

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: const ModernLoginHeader(),
            ),
            Expanded(
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(width * 0.06), //  Changed
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: width * 0.03), //  Changed
                          Container(
                            padding: EdgeInsets.all(width * 0.06), //  Changed
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: EnhancedLoginView(cubit: widget.cubit),
                          ),
                          SizedBox(height: width * 0.04), 
                          _buildFooter(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(children: [_buildFeatureFooter()]);
  }

  Widget _buildFeatureFooter() {
    final width = MediaQuery.of(context).size.width; //  Added
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.pets, color: Colors.grey, size: 16),
            SizedBox(width: width * 0.02), //  Changed
            Text(
              'Trusted by Pet Parents Worldwide',
              style: TextStyle(
                fontSize: width * 0.035, //  Changed
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: width * 0.02), //  Changed
            const Icon(Icons.pets, color: Colors.grey, size: 16),
          ],
        ),
        SizedBox(height: width * 0.04), //  Changed
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPetFeatureItem(Icons.pets, 'Pet Care', Icons.favorite_border),
            SizedBox(width: width * 0.08), //  Changed
            _buildPetFeatureItem(Icons.favorite, 'Love', Icons.favorite),
            SizedBox(width: width * 0.08), //  Changed
            _buildPetFeatureItem(Icons.shield, 'Safe', Icons.security),
          ],
        ),
        SizedBox(height: width * 0.03), //  Changed
        _buildAnimatedPetMascots(),
      ],
    );
  }

  Widget _buildPetFeatureItem(IconData icon, String label, IconData accent) {
    final width = MediaQuery.of(context).size.width; //  Added
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(width * 0.03), //  Changed
          decoration: BoxDecoration(
            color: ColorManager.secondColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ColorManager.secondColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                icon,
                size: width * 0.06,
                color: ColorManager.secondColor,
              ), //  Changed
              Positioned(
                top: -2,
                right: -2,
                child: Icon(
                  accent,
                  size: width * 0.025,
                  color: Colors.red.shade400,
                ), //  Changed
              ),
            ],
          ),
        ),
        SizedBox(height: width * 0.02), //  Changed
        Text(
          label,
          style: TextStyle(
            fontSize: width * 0.03, //  Changed
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedPetMascots() {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildBouncingPet(Icons.pets, 0),
          const SizedBox(width: 8),
          _buildBouncingPet(Icons.favorite, 500),
          const SizedBox(width: 8),
          _buildBouncingPet(Icons.star, 1000),
          const SizedBox(width: 8),
          _buildBouncingPet(Icons.home, 1500),
          const SizedBox(width: 8),
          _buildBouncingPet(Icons.shield, 2000),
        ],
      ),
    );
  }

  Widget _buildBouncingPet(IconData icon, int delay) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 2000 + delay),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -10 * (0.5 - (value * 2 - 1).abs())),
          child: Icon(
            icon,
            size: 24,
            color: ColorManager.secondColor.withOpacity(0.6),
          ),
        );
      },
    );
  }
}
