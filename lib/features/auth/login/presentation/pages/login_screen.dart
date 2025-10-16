import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/features/auth/get_started/presentation/screnns/welcome_to_squek.dart';
import 'package:squeak/features/auth/login/data/datasources/login_remote_data_source.dart';
import 'package:squeak/features/auth/login/data/repositories/login_repository.dart';
import 'package:squeak/features/auth/login/domin/usecses/login_use_case.dart';
import 'package:squeak/features/auth/login/presentation/cubit/login_cubit.dart';
import 'package:squeak/features/auth/login/presentation/widgets/modern_login_wrapper.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
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
    // TEMPORARILY DISABLED - Performance monitoring wrapper causing potential crashes
    return BlocProvider(
      create:
          (context) => LoginCubit(
            LoginUseCase(
              LoginRepositoryImpl(remoteDataSource: LoginRemoteDataSource()),
            ),
          ),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          _handleStateChanges(context, state);
        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          return _buildAnimatedContent(context, cubit, state);
        },
      ),
    );
  }

  void _handleStateChanges(BuildContext context, LoginState state) {
    if (state is LoginError) {
      // Enhanced error handling with haptic feedback
      HapticFeedback.mediumImpact();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  state.error.errors.isNotEmpty
                      ? state.error.errors.values.first.first
                      : state.error.message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }

    if (state is LoginSuccess) {
      // Success haptic feedback
      HapticFeedback.lightImpact();

      // Save user data
      CacheHelper.saveData('role', state.userEntity.role);
      CacheHelper.saveData('clintId', state.userEntity.id);
      CacheHelper.saveData('phone', state.userEntity.phone);
      CacheHelper.saveData('name', state.userEntity.fullName);
      CacheHelper.saveData('clientName', state.userEntity.fullName);
      CacheHelper.saveData('username', state.userEntity.fullName);
      CacheHelper.saveData('email', state.userEntity.email);
      TokenManager.saveToken(
        state.userEntity.token,
        state.userEntity.expiresIn,
        state.userEntity.refreshToken,
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                'Welcome back, ${state.userEntity.fullName}!',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );

      if (CacheHelper.getBool('welcome_seen')) {
        navigateAndFinish(context, LayoutScreen());
      } else {
        navigateAndFinish(context, WelcomeToSquek());
        CacheHelper.saveData('welcome_seen', true);
      }
    }
  }

  Widget _buildAnimatedContent(
    BuildContext context,
    LoginCubit cubit,
    LoginState state,
  ) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: ModernLoginWrapper(cubit: cubit),
          ),
        );
      },
    );
  }
}
