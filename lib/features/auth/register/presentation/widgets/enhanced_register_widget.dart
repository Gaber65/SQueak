import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/core/auth/enhanced_auth_validator.dart';
import 'package:squeak/core/service/global_widget/vc_loading_widget.dart';
import 'package:squeak/core/accessibility/accessibility_helper.dart';
import 'package:squeak/core/service/global_widget/national_phone.dart';

import 'package:squeak/features/auth/register/presentation/cubit/register_cubit.dart';
import 'package:squeak/features/auth/login/presentation/pages/login_screen.dart';

class EnhancedRegisterView extends StatefulWidget {
  const EnhancedRegisterView({super.key, required this.cubit});

  final RegisterCubit cubit;

  @override
  State<EnhancedRegisterView> createState() => _EnhancedRegisterViewState();
}

class _EnhancedRegisterViewState extends State<EnhancedRegisterView> 
    with AccessibilityMixin, TickerProviderStateMixin {
  
  // Validation state variables
  ValidationResult? _nameValidation;
  ValidationResult? _emailValidation;
  ValidationResult? _passwordValidation;
  ValidationResult? _confirmPasswordValidation;
  ValidationResult? _clinicCodeValidation;
  
  bool _isFormValid = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  late AnimationController _shakeController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Controllers for confirmation password
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    // Initialize animations with reduced durations for better performance
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    ));
    
    // Start animations
    _fadeController.forward();
    
    // Initialize form validation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateFormValidity();
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _fadeController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Duration getAnimationDuration({Duration? defaultDuration, Duration? reducedDuration}) {
    // Reduced animation duration for better performance
    return const Duration(milliseconds: 200);
  }

  void _validateName() {
    setState(() {
      _nameValidation = EnhancedAuthValidator.validateName(
        widget.cubit.nameController.text,
      );
      _updateFormValidity();
    });
  }

  void _validateEmail() {
    setState(() {
      _emailValidation = EnhancedAuthValidator.validateEmail(
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
      _validateConfirmPassword(); // Also validate confirm password when password changes
      _updateFormValidity();
    });
  }

  void _validateConfirmPassword() {
    setState(() {
      _confirmPasswordValidation = EnhancedAuthValidator.validatePasswordConfirmation(
        widget.cubit.passwordController.text,
        _confirmPasswordController.text,
      );
      _updateFormValidity();
    });
  }

  void _validateClinicCode() {
    setState(() {
      _clinicCodeValidation = EnhancedAuthValidator.validateClinicCode(
        widget.cubit.followCodeController.text,
      );
      _updateFormValidity();
    });
  }

  void _updateFormValidity() {
    final wasValid = _isFormValid;
    
    _isFormValid = (_nameValidation?.isValid ?? false) && 
                   (_emailValidation?.isValid ?? false) && 
                   (_passwordValidation?.isValid ?? false) &&
                   (_confirmPasswordValidation?.isValid ?? false) &&
                   (_clinicCodeValidation?.isValid ?? false) &&
                   widget.cubit.countryCode.isNotEmpty;
    
    debugPrint('Form valid: $_isFormValid');
    
    if (wasValid != _isFormValid) {
      setState(() {});
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
    
    // Provide haptic feedback
    HapticFeedback.lightImpact();
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
    
    // Provide haptic feedback
    HapticFeedback.lightImpact();
  }

  void _onRegisterPressed() async {
    if (!_isFormValid) {
      _shakeController.forward().then((_) {
        _shakeController.reset();
      });
      
      // Provide haptic feedback for validation error
      HapticFeedback.heavyImpact();
      
      if (widget.cubit.countryCode.isEmpty) {
        infoToast(
          context,
          isArabic()
              ? 'يرجى اختيار دولتك قبل متابعة التسجيل.'
              : 'Please select your country before proceeding with registration.',
        );
      }
      return;
    }

    // Provide haptic feedback for successful validation
    HapticFeedback.lightImpact();
    
    // Trigger registration
    widget.cubit.register();
  }

  Widget _buildValidationIcon(ValidationResult? validation) {
    if (validation == null) return const SizedBox.shrink();
    
    return AnimatedSwitcher(
      duration: getAnimationDuration(),
      child: validation.isValid
          ? const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 16,
              key: ValueKey('valid'),
            )
          : const Icon(
              Icons.error,
              color: Colors.red,
              size: 16,
              key: ValueKey('invalid'),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.cubit.formKey,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: AnimatedBuilder(
            animation: _shakeController,
            builder: (context, child) {
              final shakeOffset = _shakeController.isAnimating
                  ? Offset(_shakeController.value * 10 * (1 - _shakeController.value * 2).abs(), 0)
                  : Offset.zero;
              
              return Transform.translate(
                offset: shakeOffset,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome Header
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Animated paw icon
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: ColorManager.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.pets,
                                size: 32,
                                color: ColorManager.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Join the Pack! 🐾',
                              style: FontStyleThame.textStyle(
                                context: context,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                fontColor: ColorManager.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Create your account to connect with the pet care community',
                              style: FontStyleThame.textStyle(
                                context: context,
                                fontSize: 16,
                                fontColor: Colors.grey.shade600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: getAnimationDuration().inMilliseconds > 200 ? 24 : 16),

                      // Enhanced Name Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _nameValidation?.isValid == false 
                                    ? Colors.red.shade300
                                    : _nameValidation?.isValid == true
                                        ? Colors.green.shade300
                                        : Colors.grey.shade300,
                                width: 1.5,
                              ),
                            ),
                            child: TextFormField(
                              controller: widget.cubit.nameController,
                              decoration: InputDecoration(
                                hintText: S.of(context).enterName,
                                prefixIcon: const Icon(Icons.person_outline, size: 18),
                                suffixIcon: _buildValidationIcon(_nameValidation),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, 
                                  vertical: 16,
                                ),
                              ),
                              onChanged: (value) => _validateName(),
                              validator: (value) => _nameValidation?.isValid == false 
                                  ? _nameValidation?.message 
                                  : null,
                            ),
                          ),
                          // Validation text removed - no longer showing text feedback under controls
                        ],
                      ),

                      SizedBox(height: getAnimationDuration().inMilliseconds > 200 ? 20 : 13),

                      // Enhanced Email Field
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
                                hintText: S.of(context).enterUrEmail,
                                prefixIcon: const Icon(Icons.email_outlined, size: 18),
                                suffixIcon: _buildValidationIcon(_emailValidation),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, 
                                  vertical: 16,
                                ),
                              ),
                              onChanged: (value) => _validateEmail(),
                              validator: (value) => _emailValidation?.isValid == false 
                                  ? _emailValidation?.message 
                                  : null,
                            ),
                          ),
                          // Validation text removed - no longer showing text feedback under controls
                        ],
                      ),

                      SizedBox(height: getAnimationDuration().inMilliseconds > 200 ? 20 : 13),

                      // Enhanced Phone Field
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: widget.cubit.countryCode.isNotEmpty
                                ? Colors.green.shade300
                                : Colors.grey.shade300,
                            width: 1.5,
                          ),
                        ),
                        child: PhoneTextField(
                          controller: widget.cubit.phoneController,
                          countries: widget.cubit.countries,
                          registerCubit: widget.cubit,
                        ),
                      ),

                      SizedBox(height: getAnimationDuration().inMilliseconds > 200 ? 20 : 13),

                      // Enhanced Password Field
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _passwordValidation?.isValid == true
                                ? Colors.green.shade300
                                : _passwordValidation != null && !_passwordValidation!.isValid
                                    ? Colors.red.shade300
                                    : Colors.grey.shade300,
                            width: 1.5,
                          ),
                        ),
                        child: TextFormField(
                          controller: widget.cubit.passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: Colors.grey.shade50,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_passwordValidation?.isValid == true)
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green.shade600,
                                    size: 20,
                                  ),
                                IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey.shade600,
                                  ),
                                  onPressed: _togglePasswordVisibility,
                                ),
                              ],
                            ),
                          ),
                          onChanged: (value) {
                            _validatePassword();
                          },
                        ),
                      ),                      SizedBox(height: getAnimationDuration().inMilliseconds > 200 ? 20 : 13),

                      // Enhanced Confirm Password Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _confirmPasswordValidation?.isValid == false 
                                    ? Colors.red.shade300
                                    : _confirmPasswordValidation?.isValid == true
                                        ? Colors.green.shade300
                                        : Colors.grey.shade300,
                                width: 1.5,
                              ),
                            ),
                            child: TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              decoration: InputDecoration(
                                hintText: 'Confirm your password',
                                prefixIcon: const Icon(Icons.lock_outlined, size: 18),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword 
                                        ? Icons.visibility_outlined 
                                        : Icons.visibility_off_outlined,
                                    size: 18,
                                  ),
                                  onPressed: _toggleConfirmPasswordVisibility,
                                  tooltip: _obscureConfirmPassword ? 'Show password' : 'Hide password',
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, 
                                  vertical: 16,
                                ),
                              ),
                              onChanged: (value) => _validateConfirmPassword(),
                              validator: (value) => _confirmPasswordValidation?.isValid == false 
                                  ? _confirmPasswordValidation?.message 
                                  : null,
                            ),
                          ),
                          // Validation text removed - no longer showing text feedback under controls
                        ],
                      ),

                      SizedBox(height: getAnimationDuration().inMilliseconds > 200 ? 20 : 13),

                      // Enhanced Clinic Code Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _clinicCodeValidation?.isValid == false 
                                    ? Colors.red.shade300
                                    : _clinicCodeValidation?.isValid == true
                                        ? Colors.green.shade300
                                        : Colors.grey.shade300,
                                width: 1.5,
                              ),
                            ),
                            child: TextFormField(
                              controller: widget.cubit.followCodeController,
                              decoration: InputDecoration(
                                hintText: S.of(context).followCode,
                                prefixIcon: const Icon(Icons.local_hospital_outlined, size: 18),
                                suffixIcon: _buildValidationIcon(_clinicCodeValidation),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, 
                                  vertical: 16,
                                ),
                              ),
                              onChanged: (value) => _validateClinicCode(),
                              validator: (value) => _clinicCodeValidation?.isValid == false 
                                  ? _clinicCodeValidation?.message 
                                  : null,
                            ),
                          ),
                          // Validation text removed - no longer showing text feedback under controls
                        ],
                      ),

                      SizedBox(height: getAnimationDuration().inMilliseconds > 200 ? 32 : 24),

                      // Enhanced Register Button
                      Container(
                        width: double.infinity,
                        child: VcLoadingButton(
                          onPressed: _isFormValid ? _onRegisterPressed : null,
                          isLoading: widget.cubit.isRegister,
                          backgroundColor: _isFormValid 
                              ? ColorManager.primaryColor 
                              : Colors.grey.shade400,
                          borderRadius: 12,
                          height: 56,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (!widget.cubit.isRegister) ...[
                                const Icon(Icons.pets, color: Colors.white, size: 20),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                widget.cubit.isRegister 
                                    ? 'Creating Your Account...' 
                                    : S.of(context).register,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: getAnimationDuration().inMilliseconds > 200 ? 24 : 16),

                      // Enhanced Login Link
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: Divider(color: Colors.grey.shade300)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    'Already part of the pack?',
                                    style: FontStyleThame.textStyle(
                                      context: context,
                                      fontSize: 14,
                                      fontColor: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                                Expanded(child: Divider(color: Colors.grey.shade300)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            AccessibilityHelper.semanticWrapper(
                              label: 'Switch to login screen',
                              button: true,
                              hint: 'Navigate to login if you already have an account',
                              child: InkWell(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  navigateToScreen(context, LoginScreen());
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24, 
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: ColorManager.primaryColor.withOpacity(0.3),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.login,
                                        size: 18,
                                        color: ColorManager.primaryColor,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        S.of(context).login,
                                        style: FontStyleThame.textStyle(
                                          context: context,
                                          fontSize: 14,
                                          fontColor: ColorManager.primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: getAnimationDuration().inMilliseconds > 200 ? 20 : 13),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
