import 'package:flutter/material.dart';

/// Enhanced authentication input validator with real-time feedback
class EnhancedAuthValidator {
  /// Validates email with detailed feedback
  static ValidationResult validateEmail(String email) {
    if (email.isEmpty) {
      return ValidationResult(
        isValid: false,
        message: 'Email is required',
        severity: ValidationSeverity.error,
      );
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return ValidationResult(
        isValid: false,
        message: 'Please enter a valid email address',
        severity: ValidationSeverity.error,
      );
    }

    return ValidationResult(isValid: true, message: 'Valid email');
  }

  /// Validate email or phone number input
  static ValidationResult validateEmailOrPhone(String input) {
    if (input.trim().isEmpty) {
      return ValidationResult(
        isValid: false,
        message: 'Please enter your email or phone number',
        severity: ValidationSeverity.error,
      );
    }

    final cleanInput = input.trim();

    // Check if input is an email
    if (cleanInput.contains('@')) {
      final emailResult = validateEmail(cleanInput);
      return emailResult.copyWith(metadata: {'inputType': 'email'});
    }

    // Check if input is a phone number
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
    if (phoneRegex.hasMatch(cleanInput)) {
      final phoneResult = validatePhone(cleanInput);
      return phoneResult.copyWith(metadata: {'inputType': 'phone'});
    }

    return ValidationResult(
      isValid: false,
      message: 'Please enter a valid email address or phone number',
      severity: ValidationSeverity.error,
    );
  }

  static ValidationResult validatePhone(String phone) {
    if (phone.isEmpty) {
      return ValidationResult(
        isValid: false,
        message: 'Phone number is required',
        severity: ValidationSeverity.error,
      );
    }

    // Enhanced phone validation with international support
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleanPhone.length < 10 || cleanPhone.length > 15) {
      return ValidationResult(
        isValid: false,
        message: 'Phone number must be 10-15 digits',
        severity: ValidationSeverity.error,
      );
    }

    return ValidationResult(isValid: true, message: 'Valid phone number');
  }

  /// Enhanced password validation with strength indicator
  
  static ValidationResult validatePassword(String password) {
    if (password.isEmpty) {
      return ValidationResult(
        isValid: false,
        message: 'Password is required',
        severity: ValidationSeverity.error,
      );
    }

    if (password.length < 6) {
      return ValidationResult(
        isValid: false,
        message: 'Password must be at least 6 characters',
        severity: ValidationSeverity.error,
      );
    }

    // No need for strength check, accept any kind of password
    return ValidationResult(
      isValid: true,
      message: 'Password accepted',
      severity: ValidationSeverity.success,
    );
  }

  /// Validates name with detailed feedback
  static ValidationResult validateName(String name) {
    if (name.trim().isEmpty) {
      return ValidationResult(
        isValid: false,
        message: 'Name is required',
        severity: ValidationSeverity.error,
      );
    }

    if (name.trim().length < 2) {
      return ValidationResult(
        isValid: false,
        message: 'Name must be at least 2 characters',
        severity: ValidationSeverity.error,
      );
    }

    if (name.trim().length > 50) {
      return ValidationResult(
        isValid: false,
        message: 'Name must be less than 50 characters',
        severity: ValidationSeverity.error,
      );
    }

    // Check for valid name characters (letters, spaces, apostrophes, hyphens)
    if (!RegExp(r"^[a-zA-Z\s'-]+$").hasMatch(name.trim())) {
      return ValidationResult(
        isValid: false,
        message:
            'Name can only contain letters, spaces, apostrophes, and hyphens',
        severity: ValidationSeverity.error,
      );
    }

    return ValidationResult(isValid: true, message: 'Valid name');
  }

  /// Validates password confirmation
  // static ValidationResult validatePasswordConfirmation(String password, String confirmPassword) {
  //   if (confirmPassword.isEmpty) {
  //     return ValidationResult(
  //       isValid: false,
  //       message: 'Please confirm your password',
  //       severity: ValidationSeverity.error,
  //     );
  //   }

  //   if (password != confirmPassword) {
  //     return ValidationResult(
  //       isValid: false,
  //       message: 'Passwords do not match',
  //       severity: ValidationSeverity.error,
  //     );
  //   }
  //   return ValidationResult(isValid: true, message: 'Passwords match');
  // }
  /// Validates clinic code
  static ValidationResult validateClinicCode(String clinicCode) {
    if (clinicCode.trim().isEmpty) {
      return ValidationResult(
        isValid: false,
        message: 'Clinic code is required',
        severity: ValidationSeverity.error,
      );
    }

    if (clinicCode.trim().length < 3) {
      return ValidationResult(
        isValid: false,
        message: 'Clinic code must be at least 3 characters',
        severity: ValidationSeverity.error,
      );
    }

    if (clinicCode.trim().length > 20) {
      return ValidationResult(
        isValid: false,
        message: 'Clinic code must be less than 20 characters',
        severity: ValidationSeverity.error,
      );
    }

    // Allow alphanumeric characters, hyphens, and underscores
    if (!RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(clinicCode.trim())) {
      return ValidationResult(
        isValid: false,
        message:
            'Clinic code can only contain letters, numbers, hyphens, and underscores',
        severity: ValidationSeverity.error,
      );
    }

    return ValidationResult(isValid: true, message: 'Valid clinic code');
  }
}

/// Validation result with comprehensive information
class ValidationResult {
  final bool isValid;
  final String? message;
  final ValidationSeverity severity;
  final Map<String, dynamic>? metadata;

  const ValidationResult({
    required this.isValid,
    this.message,
    this.severity = ValidationSeverity.info,
    this.metadata,
  });

  /// Create a copy with optional parameter changes
  ValidationResult copyWith({
    bool? isValid,
    String? message,
    ValidationSeverity? severity,
    Map<String, dynamic>? metadata,
  }) {
    return ValidationResult(
      isValid: isValid ?? this.isValid,
      message: message ?? this.message,
      severity: severity ?? this.severity,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() => 'ValidationResult(isValid: $isValid, message: $message)';
}

enum ValidationSeverity { success, info, warning, error }
