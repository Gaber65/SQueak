import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/core/auth/enhanced_auth_validator.dart';
import 'package:squeak/core/service/global_widget/vc_loading_widget.dart';
import 'package:squeak/core/accessibility/accessibility_helper.dart';
import 'package:squeak/features/auth/register/presentation/cubit/register_cubit.dart';
import 'package:squeak/features/auth/login/presentation/pages/login_screen.dart';
import 'package:squeak/core/service/global_widget/country_code_selector.dart';
import 'package:squeak/core/service/global_widget/phone_number_field.dart';

class EnhancedRegisterView extends StatefulWidget {
  const EnhancedRegisterView({super.key, required this.cubit});

  final RegisterCubit cubit;

  @override
  State<EnhancedRegisterView> createState() => _EnhancedRegisterViewState();
}

class _EnhancedRegisterViewState extends State<EnhancedRegisterView>
    with AccessibilityMixin, TickerProviderStateMixin {
  ValidationResult? _nameValidation;
  ValidationResult? _emailValidation;
  ValidationResult? _passwordValidation;
  ValidationResult? _clinicCodeValidation;

  bool _isFormValid = false;
  bool _obscurePassword = true;
  bool _isCountrySelected = false;


  late AnimationController _shakeController;
  late AnimationController _fadeController;
  late AnimationController _countryFieldController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _countryFieldAnimation;


  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    _initializeFormValidation();
  }

  @override
  void dispose() {
    _disposeControllers();
    _stopCountryAnimation();
    super.dispose();
  }




  void _initializeAnimations() {
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    _countryFieldController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _countryFieldAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _countryFieldController, curve: Curves.easeInOut),
    )..addStatusListener((status) {
      if (!_isCountrySelected) {
        if (status == AnimationStatus.completed) {
          _countryFieldController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _countryFieldController.forward();
        }
      }
    });
  }

  void _startAnimations() {
    _fadeController.forward();
    _countryFieldController.forward();
  }

  void _initializeFormValidation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateFormValidity();
    });
  }

  void _disposeControllers() {
    _shakeController.dispose();
    _fadeController.dispose();
    _countryFieldController.dispose();
    super.dispose();
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

    _isFormValid =
        (_nameValidation?.isValid ?? false) &&
        (_emailValidation?.isValid ?? false) &&
        (_passwordValidation?.isValid ?? false) &&
        (_clinicCodeValidation?.isValid ?? false) &&
        widget.cubit.countryCode.isNotEmpty;

    debugPrint('Form valid: $_isFormValid');

    if (wasValid != _isFormValid) {
      setState(() {});
    }
  }

  void _stopCountryAnimation() {
    if (!_isCountrySelected) {
      setState(() {
        _isCountrySelected = true;
      });
      _countryFieldController.stop();
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
    HapticFeedback.lightImpact();
  }

  void _onRegisterPressed() async {
    if (!_isFormValid) {
      _shakeController.forward().then((_) {
        _shakeController.reset();
      });

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

    HapticFeedback.lightImpact();
    widget.cubit.register();
  }


  @override
  Duration getAnimationDuration({
    Duration? defaultDuration,
    Duration? reducedDuration,
  }) {
    return const Duration(milliseconds: 200);
  }

  double get _spacing => getAnimationDuration().inMilliseconds > 200 ? 20 : 13;
  double get _largeSpacing =>
      getAnimationDuration().inMilliseconds > 200 ? 24 : 16;
  double get _extraLargeSpacing =>
      getAnimationDuration().inMilliseconds > 200 ? 32 : 24;

  Color _getBorderColor(ValidationResult? validation) {
    if (validation?.isValid == true) {
      return ColorManager.green.withValues(alpha: 0.7);
    } else if (validation != null && !validation.isValid) {
      return ColorManager.red.withValues(alpha: 0.7);
    }
    return Theme.of(context).colorScheme.outlineVariant;
  }

  Widget _buildValidationIcon(ValidationResult? validation) {
    if (validation == null) return const SizedBox.shrink();

    return AnimatedSwitcher(
      duration: getAnimationDuration(),
      child:
          validation.isValid
              ? const Icon(
                Icons.check_circle,
                color: ColorManager.green,
                size: 16,
                key: ValueKey('valid'),
              )
              : const Icon(
                Icons.error,
                color: ColorManager.red,
                size: 16,
                key: ValueKey('invalid'),
              ),
    );
  }

  // ==================== UI Building Methods ====================

  Widget _buildWelcomeHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColorManager.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.pets, size: 32, color: ColorManager.primaryColor),
          ),
          const SizedBox(height: 16),
          Text(
            'Join the Pack!',
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
              fontColor: Theme.of(context).colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    required ValidationResult? validation,
    required VoidCallback onChanged,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getBorderColor(validation), width: 1.5),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(prefixIcon, size: 18),
          suffixIcon: suffixIcon ?? _buildValidationIcon(validation),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        onChanged: (_) => onChanged(),
        validator: (_) => null,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getBorderColor(_passwordValidation),
          width: 1.5,
        ),
      ),
      child: TextFormField(
        controller: widget.cubit.passwordController,
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          hintText: 'Enter your password',
          prefixIcon: const Icon(Icons.lock_outlined, size: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_passwordValidation?.isValid == true)
                Icon(Icons.check_circle, color: ColorManager.green, size: 20),
              IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).colorScheme.outline,
                ),
                onPressed: _togglePasswordVisibility,
              ),
            ],
          ),
        ),
        onChanged: (_) => _validatePassword(),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ScaleTransition(
            scale: _countryFieldAnimation,
            child: CountryCodeSelector(
              countries: widget.cubit.countries,
              registerCubit: widget.cubit,
              isValid: widget.cubit.countryCode.isNotEmpty,
              onCountryChanged: _updateFormValidity,
              onAnimationStop: _stopCountryAnimation,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 4,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    widget.cubit.countryCode.isNotEmpty
                        ? ColorManager.green.withValues(alpha: 0.7)
                        : Theme.of(context).colorScheme.outlineVariant,
                width: 1.5,
              ),
            ),
            child: PhoneNumberField(
              controller: widget.cubit.phoneController,
              hintText: S.of(context).phone_hint,
              isValid: widget.cubit.countryCode.isNotEmpty,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.of(context).phone_validation;
                }
                return null;
              },
              onChanged: _updateFormValidity,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: VcLoadingButton(
        onPressed: _isFormValid ? _onRegisterPressed : null,
        isLoading: widget.cubit.isRegister,
        backgroundColor:
            _isFormValid
                ? ColorManager.primaryColor
                : Theme.of(
                  context,
                ).colorScheme.outlineVariant.withValues(alpha: 0.6),
        borderRadius: 12,
        height: 56,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!widget.cubit.isRegister) ...[
              const Icon(Icons.pets, color: ColorManager.white, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              widget.cubit.isRegister
                  ? 'Creating Your Account...'
                  : S.of(context).register,
              style: const TextStyle(
                color: ColorManager.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Already part of the pack?',
                  style: FontStyleThame.textStyle(
                    context: context,
                    fontSize: 14,
                    fontColor: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
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
                    color: ColorManager.primaryColor.withValues(alpha: 0.3),
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
              final shakeOffset =
                  _shakeController.isAnimating
                      ? Offset(
                        _shakeController.value *
                            10 *
                            (1 - _shakeController.value * 2).abs(),
                        0,
                      )
                      : Offset.zero;

              return Transform.translate(
                offset: shakeOffset,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWelcomeHeader(),
                      SizedBox(height: _largeSpacing),

                      _buildInputField(
                        controller: widget.cubit.nameController,
                        hintText: S.of(context).enterName,
                        prefixIcon: Icons.person_outline,
                        validation: _nameValidation,
                        onChanged: _validateName,
                      ),
                      SizedBox(height: _spacing),

                      _buildInputField(
                        controller: widget.cubit.emailController,
                        hintText: S.of(context).enterUrEmail,
                        prefixIcon: Icons.email_outlined,
                        validation: _emailValidation,
                        onChanged: _validateEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: _spacing),

                      _buildPhoneField(),
                      SizedBox(height: _spacing),

                      _buildPasswordField(),
                      SizedBox(height: _spacing),

                      _buildInputField(
                        controller: widget.cubit.followCodeController,
                        hintText: S.of(context).followCode,
                        prefixIcon: Icons.local_hospital_outlined,
                        validation: _clinicCodeValidation,
                        onChanged: _validateClinicCode,
                      ),
                      SizedBox(height: _extraLargeSpacing),

                      _buildRegisterButton(),
                      SizedBox(height: _largeSpacing),

                      _buildLoginLink(),
                      SizedBox(height: _spacing),
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
