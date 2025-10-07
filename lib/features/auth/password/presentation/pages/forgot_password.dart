// ignore_for_file: deprecated_member_use
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/core/service/global_widget/vc_loading_widget.dart';
import 'package:squeak/features/auth/password/data/datasources/password_remote_data_source.dart';
import 'package:squeak/features/auth/password/data/repositories/password_repo.dart';
import 'package:squeak/features/auth/password/domin/usecses/forget_password_usecase.dart';
import 'package:squeak/features/auth/password/domin/usecses/reset_password_usecase.dart';
import 'package:squeak/features/auth/password/domin/usecses/verify_user_usecase.dart';
import 'package:squeak/features/auth/password/presentation/cubit/password_cubit.dart';
import 'package:squeak/features/auth/password/presentation/pages/reset_password.dart';
import '../../../login/presentation/pages/login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final List<String> petEmojis = [
    '🐶',
    '🐱',
    '🐰',
    '🐹',
    '🦊',
    '🐻',
    '🐨',
    '🐸',
  ];
  final List<String> motivationalMessages = [
    '"Squeak! Everyone forgets sometimes!" 🐭',
    '"Chirp! Reset passwords are easy!" 🐦',
    '"Woof! We\'re here to help!" 🐕',
    '"Meow! You\'ll be back in no time!" 🐈',
    '"Hop! Just a few steps away!" 🐰',
    '"Roar! Stay pawsitive!" 🦁',
  ];

  int currentMessageIndex = 0;
  int currentPetIndex = 0;
  late AnimationController _petController;

  @override
  void initState() {
    super.initState();
    _petController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));
      if (!mounted) return false;
      setState(() {
        currentMessageIndex =
            (currentMessageIndex + 1) % motivationalMessages.length;
        currentPetIndex = (currentPetIndex + 1) % petEmojis.length;
      });
      return true;
    });
  }

  @override
  void dispose() {
    _petController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final scaleFactor = isTablet ? 1.2 : 1.0;

    return BlocProvider(
      create:
          (_) => PasswordCubit(
            forgetPasswordUseCase: ForgetPasswordUseCase(
              PasswordRepoImpl(remoteDataSource: PasswordRemoteDataSource()),
            ),
            resetPasswordUseCase: ResetPasswordUseCase(
              PasswordRepoImpl(remoteDataSource: PasswordRemoteDataSource()),
            ),
            verifyUserUseCase: VerifyUserUseCase(
              PasswordRepoImpl(remoteDataSource: PasswordRemoteDataSource()),
            ),
          ),
      child: BlocConsumer<PasswordCubit, PasswordState>(
        listener: (context, state) {
          if (state is ForgetPasswordErrorState) {
            errorToast(context, state.error);
          }
          if (state is ForgetPasswordSuccessState) {
            navigateAndFinish(
              context,
              ResetPasswordScreen(
                emailController: context.read<PasswordCubit>().emailController,
              ),
            );
            context.read<PasswordCubit>().emailController.clear();
          }
        },
        builder: (context, state) {
          final cubit = context.read<PasswordCubit>();
          return Scaffold(
            backgroundColor: const Color(0xFF1A1A2E),
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF7F8DFA),
                        Color(0xFF9192F5),
                        Color(0xFF27272B),
                      ],
                      stops: [0.0, 0.4, 1.0],
                    ),
                  ),
                ),
                // Floating pet emojis
                ...List.generate(5, (index) {
                  final random = math.Random(index);
                  final baseTop = random.nextDouble() * screenHeight * 0.3;
                  final baseLeft = random.nextDouble() * screenWidth;
                  return AnimatedBuilder(
                    animation: _petController,
                    builder: (context, child) {
                      final offset =
                          math.sin(_petController.value * 2 * math.pi) * 10;
                      return Positioned(
                        top: baseTop + offset,
                        left: baseLeft,
                        child: Opacity(
                          opacity: 0.08,
                          child: Text(
                            petEmojis[index % petEmojis.length],
                            style: TextStyle(
                              fontSize: isTablet ? 34 : 26,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
                SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        width: 110 * scaleFactor,
                        height: 110 * scaleFactor,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFCDC2F4), Color(0xFF5B3FB5)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '🐾',
                            style: TextStyle(
                              fontSize: 50 * scaleFactor,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Don't Worry!",
                        style: TextStyle(
                          fontSize: 28 * scaleFactor,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Even the smartest pets forget where they\nburied their bones sometimes 🦴",
                        style: TextStyle(
                          fontSize: 14 * scaleFactor,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: SingleChildScrollView(
                          child: _buildResetCard(cubit, scaleFactor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Light themed reset card
  Widget _buildResetCard(PasswordCubit cubit, double scaleFactor) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(20 * scaleFactor),
      decoration: BoxDecoration(
        color: Colors.white, // Light background
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Reset Your Password',
            style: TextStyle(
              fontSize: 22 * scaleFactor,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2A2A3E),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Enter your email address and we\'ll send you a OTP to reset your password.',
            style: TextStyle(
              fontSize: 14 * scaleFactor,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            petEmojis[(currentPetIndex + 2) % petEmojis.length],
            style: TextStyle(fontSize: 36 * scaleFactor),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                motivationalMessages[currentMessageIndex],
                key: ValueKey(currentMessageIndex),
                style: TextStyle(
                  fontSize: 13 * scaleFactor,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Form(
            key: cubit.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email Address',
                    style: TextStyle(
                      fontSize: 14 * scaleFactor,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: cubit.emailController,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Colors.grey,
                    ),
                    hintText: 'Enter your email address',
                    hintStyle: const TextStyle(color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: VcLoadingButton(
                    onPressed: () {
                      // Validate form then call cubit's forgetPassword
                      if (cubit.formKey.currentState?.validate() ?? false) {
                        FocusScope.of(context).unfocus();
                        cubit.forgetPassword();
                        cubit.emailController.text.trim();
                      }
                    },
                    isLoading: cubit.isForgetPassword,
                    backgroundColor: const Color(0xFF7B5CE6),
                    borderRadius: 12,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Send OTP',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.send_rounded, color: Colors.white, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () => navigateToScreen(context, const LoginScreen()),
            label: const Text(
              'Remember your password? Sign In',
              style: TextStyle(color: Color(0xFF7B5CE6)),
            ),
          ),
        ],
      ),
    );
  }
}
