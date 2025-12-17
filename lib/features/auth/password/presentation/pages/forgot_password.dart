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
  final List<String> petEmojis = ['🐶', '🐱', '🐰', '🐭', '🐦', '🦁'];

  // Motivational messages with both English and Arabic
  final List<Map<String, String>> motivationalMessages = const [
    {
      'en': '"Woof! We\'re here to help!" 🐕',
      'ar': '"هاو! نحن هنا لمساعدتك!" 🐕',
    },
    {
      'en': '"Meow! You\'ll be back in no time!" 🐈',
      'ar': '"مواء! ستعود في لمح البصر!" 🐈',
    },
    {
      'en': '"Hop! Just a few steps away!" 🐰',
      'ar': '"قفزة! خطوات قليلة فقط!" 🐰',
    },
    {
      'en': '"Squeak! Everyone forgets sometimes!" 🐭',
      'ar': '"صرير! الجميع ينسى أحياناً!" 🐭',
    },
    {
      'en': '"Chirp! Reset passwords are easy!" 🐦',
      'ar': '"زقزقة! إعادة تعيين كلمة المرور سهلة!" 🐦',
    },
    {'en': '"Roar! Stay pawsitive!" 🦁', 'ar': '"زئير! ابقَ متفائلاً!" 🦁'},
  ];

  int currentIndex = 0;
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
        // Update both emoji and message together using the same index
        currentIndex = (currentIndex + 1) % petEmojis.length;
      });
      return true;
    });
  }

  @override
  void dispose() {
    _petController.dispose();
    super.dispose();
  }

  String _getMessage() {
    return isArabic()
        ? motivationalMessages[currentIndex]['ar']!
        : motivationalMessages[currentIndex]['en']!;
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
            backgroundColor: Colors.white,
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
                      SizedBox(height: 12 * scaleFactor),
                      Container(
                        width: 84 * scaleFactor,
                        height: 84 * scaleFactor,
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
                              fontSize: 38 * scaleFactor,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12 * scaleFactor),
                      Text(
                        isArabic() ? 'لا تقلق!' : "Don't Worry!",
                        style: TextStyle(
                          fontSize: 20 * scaleFactor,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8 * scaleFactor),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Text(
                          isArabic()
                              ? 'حتى أذكى الحيوانات الأليفة تنسى أين دفنت\nعظامها أحياناً 🦴'
                              : "Even the smartest pets forget where they\nburied their bones sometimes 🦴",
                          style: TextStyle(
                            fontSize: 12 * scaleFactor,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 12 * scaleFactor),
                      Expanded(child: _buildResetCard(cubit, scaleFactor)),
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

  /// Light themed reset card with proper scrolling
  Widget _buildResetCard(PasswordCubit cubit, double scaleFactor) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24 * scaleFactor),
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isArabic() ? 'إعادة تعيين كلمة المرور' : 'Reset Your Password',
              style: TextStyle(
                fontSize: 22 * scaleFactor,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2A2A3E),
              ),
            ),
            SizedBox(height: 10 * scaleFactor),
            Text(
              isArabic()
                  ? 'أدخل عنوان بريدك الإلكتروني وسنرسل لك رمز التحقق\nلإعادة تعيين كلمة المرور.'
                  : 'Enter your email address and we\'ll send you a OTP to reset your password.',
              style: TextStyle(
                fontSize: 14 * scaleFactor,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24 * scaleFactor),

            // Reusable Motivational Widget with synchronized emoji and message
            MotivationalPetWidget(
              petEmoji: petEmojis[currentIndex],
              message: _getMessage(),
              messageKey: ValueKey(currentIndex),
              scaleFactor: scaleFactor,
            ),

            SizedBox(height: 24 * scaleFactor),
            Form(
              key: cubit.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment:
                        isArabic()
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                    child: Text(
                      isArabic() ? 'عنوان البريد الإلكتروني' : 'Email Address',
                      style: TextStyle(
                        fontSize: 14 * scaleFactor,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 8 * scaleFactor),
                  TextFormField(
                    controller: cubit.emailController,
                    style: const TextStyle(color: Colors.black87),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: Colors.grey,
                      ),
                      hintText:
                          isArabic()
                              ? 'أدخل عنوان بريدك الإلكتروني'
                              : 'Enter your email address',
                      hintStyle: const TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 16 * scaleFactor,
                        horizontal: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF7B5CE6),
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return isArabic()
                            ? 'أدخل عنوان بريدك الإلكتروني'
                            : 'Please enter your email';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return isArabic()
                            ? 'أدخل بريداً إلكترونياً صالحاً'
                            : 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24 * scaleFactor),
                  SizedBox(
                    width: double.infinity,
                    child: VcLoadingButton(
                      onPressed: () {
                        if (cubit.formKey.currentState?.validate() ?? false) {
                          FocusScope.of(context).unfocus();
                          cubit.forgetPassword();
                        }
                      },
                      isLoading: cubit.isForgetPassword,
                      backgroundColor: const Color(0xFF7B5CE6),
                      borderRadius: 12,
                      height: 52 * scaleFactor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isArabic() ? 'إرسال رمز التحقق' : 'Send OTP',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16 * scaleFactor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16 * scaleFactor),
            TextButton(
              onPressed: () => navigateToScreen(context, const LoginScreen()),
              child: Text(
                isArabic()
                    ? 'تذكرت كلمة المرور؟ سجل الدخول'
                    : 'Remember your password? Sign In',
                style: TextStyle(
                  color: const Color(0xFF7B5CE6),
                  fontSize: 14 * scaleFactor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 16 * scaleFactor),
          ],
        ),
      ),
    );
  }
}

/// Reusable Motivational Pet Widget
/// Can be used across different screens
class MotivationalPetWidget extends StatelessWidget {
  final String petEmoji;
  final String message;
  final Key messageKey;
  final double scaleFactor;
  final Color? backgroundColor;
  final Color? textColor;

  const MotivationalPetWidget({
    super.key,
    required this.petEmoji,
    required this.message,
    required this.messageKey,
    this.scaleFactor = 1.0,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(petEmoji, style: TextStyle(fontSize: 48 * scaleFactor)),
        SizedBox(height: 12 * scaleFactor),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16 * scaleFactor,
            vertical: 12 * scaleFactor,
          ),
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.1),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Text(
              message,
              key: messageKey,
              style: TextStyle(
                fontSize: 13 * scaleFactor,
                color: textColor ?? Colors.deepPurple,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
