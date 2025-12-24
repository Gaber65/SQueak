// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/features/auth/login/data/datasources/login_remote_data_source.dart';
import 'package:squeak/features/auth/login/data/repositories/login_repository.dart';
import 'package:squeak/features/auth/login/domin/usecses/login_use_case.dart';
import 'package:squeak/features/auth/login/domin/usecses/login_with_facebook.dart';
import 'package:squeak/features/auth/login/presentation/cubit/login_cubit.dart';
import 'package:squeak/features/auth/login/presentation/widgets/modern_login_wrapper.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../data/datasources/socail_auth_data_source.dart';
import '../../data/repositories/socail_repo.dart';
import '../../domin/usecses/login_with_google.dart';

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
  bool _isNavigating = false; // Prevent multiple navigation calls

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
    return BlocProvider(
      create:
          (context) => LoginCubit(
            LoginUseCase(
              LoginRepositoryImpl(remoteDataSource: LoginRemoteDataSource()),
            ),

            LoginWithGoogleUseCase(
              SocialRepo(SocailAuthRemoteDataSourceImpl()),
            ),
            LoginWithFacebookUseCase(
              SocialRepo(SocailAuthRemoteDataSourceImpl()),
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

      if (!mounted) return;

      // Use app-level navigator key context to show SnackBar safely in case local context is deactivated
      final rootContext = navigatorKey.currentContext ?? context;
      final messenger = ScaffoldMessenger.maybeOf(rootContext);
      if (messenger != null) {
        messenger.showSnackBar(
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
                messenger.hideCurrentSnackBar();
              },
            ),
          ),
        );
      } else {
        debugPrint(
          '[Login] No ScaffoldMessenger available to show error SnackBar',
        );
      }
    }

    if (state is LoginSuccess && !_isNavigating) {
      _isNavigating = true; // Prevent multiple calls
      HapticFeedback.lightImpact();

      // Persist user data and token before navigating. Await to avoid race conditions
      Future<void> persistLogin() async {
        try {
          debugPrint('[Login] Persisting login data...');
          await Future.wait([
            CacheHelper.saveData('role', state.userEntity.role),
            CacheHelper.saveData('clintId', state.userEntity.id),
            CacheHelper.saveData('phone', state.userEntity.phone),
            CacheHelper.saveData('name', state.userEntity.fullName),
            CacheHelper.saveData('clientName', state.userEntity.fullName),
            CacheHelper.saveData('username', state.userEntity.fullName),
            CacheHelper.saveData('email', state.userEntity.email),
            CacheHelper.saveData('token', state.userEntity.token),
          ]);

          debugPrint(
            '[Login] Saved user fields to CacheHelper. Saving tokens...',
          );
          await TokenManager.saveToken(
            state.userEntity.token,
            state.userEntity.expiresIn,
            state.userEntity.refreshToken,
          );
          debugPrint('[Login] TokenManager.saveToken completed');
        } catch (e) {
          debugPrint('[Login] Error saving login data: $e');
          // If saving fails, still proceed but ensure flag resets later
        }
      }

      // Ensure persistence completes before UI navigation
      persistLogin().whenComplete(() async {
        // Reset MainCubit state safely and navigate. Avoid showing SnackBar from possibly-deactivated context.
        debugPrint(
          '[Login] Persistence complete, resetting MainCubit and navigating',
        );
        try {
          BlocProvider.of<MainCubit>(context).resetState();
        } catch (e) {
          debugPrint('[Login] Error resetting MainCubit: $e');
        }

        if (!mounted || !context.mounted) {
          _isNavigating = false;
          return;
        }

        try {
          debugPrint('[Login] Navigating to LayoutScreen');
          navigateAndFinish(context, const LayoutScreen());
        } catch (e) {
          debugPrint('[Login] Navigation error: $e');
        } finally {
          if (mounted) _isNavigating = false;
        }
      });
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
