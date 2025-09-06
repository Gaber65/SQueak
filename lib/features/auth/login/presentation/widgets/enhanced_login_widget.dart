import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/core/auth/enhanced_auth_validator.dart';
import 'package:squeak/core/widgets/vc_enhanced_button.dart';
import 'package:squeak/core/accessibility/accessibility_helper.dart';
import 'package:squeak/core/monitoring/advanced_performance_monitor.dart';

import 'package:squeak/features/auth/login/presentation/cubit/login_cubit.dart';
import 'package:squeak/features/auth/password/presentation/pages/forgot_password.dart';
import 'package:squeak/features/auth/register/presentation/pages/register_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class EnhancedLoginView extends StatefulWidget {
  const EnhancedLoginView({super.key, required this.cubit});

  final LoginCubit cubit;

  @override
  State<EnhancedLoginView> createState() => _EnhancedLoginViewState();
}

class _EnhancedLoginViewState extends State<EnhancedLoginView> 
    with AccessibilityMixin, TickerProviderStateMixin {
  ValidationResult? _emailValidation;
  ValidationResult? _passwordValidation;
  bool _isFormValid = false;
  bool _obscurePassword = true;
  final AdvancedPerformanceMonitor _performanceMonitor = AdvancedPerformanceMonitor();
  
  late AnimationController _shakeController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    // TEMPORARILY DISABLED - Performance monitoring causing potential crashes
    // _performanceMonitor.startOperation('enhanced_login_init');
    
    widget.cubit.emailController.addListener(_validateEmail);
    widget.cubit.passwordController.addListener(_validatePassword);
    
    // Initialize animations
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // TEMPORARILY DISABLED - Performance monitoring causing potential crashes
    // _performanceMonitor.endOperation('enhanced_login_init');
  }

  @override
  void dispose() {
    widget.cubit.emailController.removeListener(_validateEmail);
    widget.cubit.passwordController.removeListener(_validatePassword);
    _shakeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    setState(() {
      _emailValidation = EnhancedAuthValidator.validateEmailOrPhone(
        widget.cubit.emailController.text,
      );
      _updateFormValidity();
    });
  }

  void _validatePassword() {
    setState(() {
      _passwordValidation = EnhancedAuthValidator.validatePassword(
        widget.cubit.passwordController.text,
      );
      _updateFormValidity();
    });
  }

  void _updateFormValidity() {
    final wasValid = _isFormValid;
    _isFormValid = (_emailValidation?.isValid ?? false) && 
                   (_passwordValidation?.isValid ?? false);
    
    // Trigger pulse animation when form becomes valid
    if (!wasValid && _isFormValid) {
      _pulseController.forward().then((_) => _pulseController.reverse());
      HapticFeedback.lightImpact();
    }
  }

  void _handleLogin() {
    if (!_isFormValid) {
      _shakeController.forward().then((_) => _shakeController.reverse());
      HapticFeedback.mediumImpact();
      announce('Please fix the form errors before continuing');
      return;
    }

    HapticFeedback.selectionClick();
    if (widget.cubit.formKey.currentState!.validate()) {
      widget.cubit.login(context);
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return AccessibilityHelper.semanticWrapper(
      label: 'Login form',
      child: Form(
        key: widget.cubit.formKey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Login Title
              AccessibilityHelper.semanticWrapper(
                label: 'Login screen',
                header: true,
                child: Text(
                  S.of(context).login,
                  style: FontStyleThame.textStyle(
                    context: context,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              SizedBox(height: getAnimationDuration().inMilliseconds > 200 ? 20 : 13),

              // Enhanced Email/Phone Field with accessibility
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _emailValidation?.isValid == false 
                            ? Colors.red.shade300
                            : _emailValidation?.isValid == true
                                ? Colors.green.shade300
                                : Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    child: TextFormField(
                      controller: widget.cubit.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Enter your email or phone number',
                        prefixIcon: const Icon(Icons.alternate_email, size: 18),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, 
                          vertical: 16,
                        ),
                      ),
                      validator: (value) => _emailValidation?.isValid == false 
                          ? _emailValidation?.message 
                          : null,
                    ),
                  ),
                  if (_emailValidation != null && !_emailValidation!.isValid)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: AccessibilityHelper.semanticWrapper(
                        liveRegion: true,
                        child: Text(
                          _emailValidation!.message ?? '',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  if (_emailValidation != null && _emailValidation!.isValid)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, 
                            color: Colors.green, 
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Perfect! Your pet parent ID looks great!',
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              SizedBox(height: getAnimationDuration().inMilliseconds > 200 ? 20 : 13),

              // Enhanced Password Field with accessibility
              AccessibilityHelper.accessibleFormField(
                label: 'Secure Paw-ssword',
                hint: 'Enter your secure password to protect your pet data',
                required: true,
                errorText: _passwordValidation?.isValid == false 
                    ? _passwordValidation?.message 
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _passwordValidation?.isValid == false 
                              ? Colors.red.shade300
                              : _passwordValidation?.isValid == true
                                  ? Colors.green.shade300
                                  : Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: TextFormField(
                        controller: widget.cubit.passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: 'Enter your secure password',
                          prefixIcon: const Icon(Icons.lock_outlined, size: 18),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword 
                                  ? Icons.visibility_outlined 
                                  : Icons.visibility_off_outlined,
                              size: 18,
                            ),
                            onPressed: _togglePasswordVisibility,
                            tooltip: _obscurePassword ? 'Show password' : 'Hide password',
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, 
                            vertical: 16,
                          ),
                        ),
                        validator: (value) => _passwordValidation?.isValid == false 
                            ? _passwordValidation?.message 
                            : null,
                      ),
                    ),
                    if (_passwordValidation != null && !_passwordValidation!.isValid)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: AccessibilityHelper.semanticWrapper(
                          liveRegion: true,
                          child: Text(
                            _passwordValidation!.message ?? '',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    if (_passwordValidation != null && _passwordValidation!.isValid)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, 
                              color: Colors.green, 
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Password is valid',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: getAnimationDuration().inMilliseconds > 200 ? 20 : 13),

              // Forgot Password Link with accessibility
              AccessibilityHelper.semanticWrapper(
                label: 'Forgot password link',
                link: true,
                hint: 'Tap to reset your password',
                onTap: () => navigateToScreen(context, ForgotPasswordScreen()),
                child: InkWell(
                  onTap: () => navigateToScreen(context, ForgotPasswordScreen()),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: Text(
                      S.of(context).forgotPass,
                      style: FontStyleThame.textStyle(
                        context: context,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontColor: ColorManager.secondColor,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: getAnimationDuration().inMilliseconds > 200 ? 24 : 16),

              // Enhanced Login Button with accessibility
              SizedBox(
                width: double.infinity,
                child: VCEnhancedButton(
                  onPressed: _isFormValid ? _handleLogin : null,
                  isLoading: widget.cubit.isLoggedIn,
                  loadingText: 'Finding your furry friends...',
                  semanticLabel: 'Login button',
                  tooltip: _isFormValid 
                      ? 'Tap to login' 
                      : 'Please complete the form to login',
                  animationDuration: getAnimationDuration(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormValid 
                        ? ColorManager.secondColor 
                        : Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.pets, size: 18, color: Colors.white),
                      const SizedBox(width: 8),
                      const Text(
                        'Sign in to Pet Paradise',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: getAnimationDuration().inMilliseconds > 200 ? 20 : 13),

              // Register Link with accessibility
              AccessibilityHelper.semanticWrapper(
                label: 'Register link section',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      S.of(context).haveNotAccount,
                      style: FontStyleThame.textStyle(
                        context: context,
                        fontSize: 14,
                        fontColor: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    AccessibilityHelper.semanticWrapper(
                      label: 'Register button',
                      button: true,
                      hint: 'Tap to create a new account',
                      onTap: () => navigateToScreen(context, const RegisterScreen()),
                      child: TextButton(
                        onPressed: () => navigateToScreen(context, const RegisterScreen()),
                        style: TextButton.styleFrom(
                          foregroundColor: ColorManager.secondColor,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        ),
                        child: Text(
                          S.of(context).register,
                          style: FontStyleThame.textStyle(
                            context: context,
                            fontSize: 14,
                            fontColor: ColorManager.secondColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Form Validation Status (for screen readers)
              if (!_isFormValid)
                AccessibilityHelper.semanticWrapper(
                  liveRegion: true,
                  hidden: true,
                  child: const Text(
                    'Form has validation errors. Please correct them before continuing.',
                    style: TextStyle(fontSize: 0),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

void navigateToimageUrl(String imageUrl) async {
  if (await canLaunch(imageUrl)) {
    await launch(imageUrl);
  } else {
    throw 'Could not launch $imageUrl';
  }
}
