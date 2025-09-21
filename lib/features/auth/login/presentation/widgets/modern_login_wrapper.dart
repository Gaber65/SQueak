import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/core/monitoring/advanced_performance_monitor.dart';
import 'package:squeak/features/auth/login/presentation/widgets/enhanced_login_widget.dart';
import 'package:squeak/features/auth/login/presentation/cubit/login_cubit.dart';

class ModernLoginHeader extends StatefulWidget {
  const ModernLoginHeader({super.key});

  @override
  State<ModernLoginHeader> createState() => _ModernLoginHeaderState();
}

class _ModernLoginHeaderState extends State<ModernLoginHeader>
    with TickerProviderStateMixin {
  late AnimationController _pawAnimationController;
  late AnimationController _mascotAnimationController;
  late Animation<double> _pawFloatAnimation;
  late Animation<double> _mascotBounceAnimation;

  @override
  void initState() {
    super.initState();

    // Paw prints floating animation - LIMITED REPEAT
    _pawAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _pawFloatAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _pawAnimationController, curve: Curves.easeInOut),
    );

    // Mascot bounce animation - LIMITED REPEAT
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

    // Start animations with limited repetitions
    _startAnimations();
  }

  void _startAnimations() {
    // TEMPORARILY DISABLED - Animations causing memory leaks
    // Will re-enable after fixing memory issues

    // Log that animations are disabled
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ColorManager.secondColor,
            ColorManager.secondColor.withOpacity(0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          // Floating paw prints background
          AnimatedBuilder(
            animation: _pawFloatAnimation,
            builder: (context, child) {
              return Positioned(
                top: 20 + _pawFloatAnimation.value,
                right: 30,
                child: Transform.rotate(
                  angle: 0.3,
                  child: Icon(
                    Icons.pets,
                    size: 24,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _pawFloatAnimation,
            builder: (context, child) {
              return Positioned(
                top: 80 - _pawFloatAnimation.value,
                left: 40,
                child: Transform.rotate(
                  angle: -0.2,
                  child: Icon(
                    Icons.pets,
                    size: 20,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _pawFloatAnimation,
            builder: (context, child) {
              return Positioned(
                top: 40 + (_pawFloatAnimation.value * 0.7),
                right: 80,
                child: Transform.rotate(
                  angle: 0.5,
                  child: Icon(
                    Icons.pets,
                    size: 16,
                    color: Colors.white.withOpacity(0.25),
                  ),
                ),
              );
            },
          ),

          // Main content
          Column(
            children: [
              // Animated Pet Mascot Logo
              AnimatedBuilder(
                animation: _mascotBounceAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, -_mascotBounceAnimation.value),
                    child: Container(
                      width: 90,
                      height: 90,
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
                          // Cute pet face
                          const Icon(
                            Icons.pets,
                            size: 45,
                            color: ColorManager.secondColor,
                          ),
                          // Heart eyes effect
                          Positioned(
                            top: 20,
                            left: 24,
                            child: Icon(
                              Icons.favorite,
                              size: 8,
                              color: Colors.red.withOpacity(0.8),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            right: 24,
                            child: Icon(
                              Icons.favorite,
                              size: 8,
                              color: Colors.red.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Pet-themed Welcome Text
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
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.pets, color: Colors.white, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Your furry friends are waiting for you!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.pets, color: Colors.white, size: 16),
                ],
              ),
              const SizedBox(height: 4),

              Text(
                'Sign in to continue your pet care journey',
                style: TextStyle(
                  fontSize: 14,
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
  final AdvancedPerformanceMonitor _performanceMonitor =
      AdvancedPerformanceMonitor();

  @override
  void initState() {
    super.initState();
    // TEMPORARILY DISABLED - Performance monitoring causing potential crashes
    // _performanceMonitor.startOperation('modern_login_wrapper_init');

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
    // TEMPORARILY DISABLED - Performance monitoring causing potential crashes
    // _performanceMonitor.endOperation('modern_login_wrapper_init');
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            FadeTransition(
              opacity: _fadeAnimation,
              child: const ModernLoginHeader(),
            ),

            // Form Section
            Expanded(
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          // Enhanced Login Form
                          Container(
                            padding: const EdgeInsets.all(24),
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

                          const SizedBox(height: 40),

                          // Footer
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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.pets, color: Colors.grey, size: 16),
            const SizedBox(width: 8),
            Text(
              'Trusted by Pet Parents Worldwide',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.pets, color: Colors.grey, size: 16),
          ],
        ),
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPetFeatureItem(Icons.pets, 'Pet Care', Icons.favorite_border),
            const SizedBox(width: 32),
            _buildPetFeatureItem(Icons.favorite, 'Love', Icons.favorite),
            const SizedBox(width: 32),
            _buildPetFeatureItem(Icons.shield, 'Safe', Icons.security),
          ],
        ),
        const SizedBox(height: 12),

        // Animated pet mascots row with icons
        _buildAnimatedPetMascots(),
      ],
    );
  }

  Widget _buildPetFeatureItem(IconData icon, String label, IconData accent) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
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
              Icon(icon, size: 24, color: ColorManager.secondColor),
              Positioned(
                top: -2,
                right: -2,
                child: Icon(accent, size: 10, color: Colors.red.shade400),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
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
