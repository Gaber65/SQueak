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
      return emailResult.copyWith(
        metadata: {'inputType': 'email'},
      );
    }
    
    // Check if input is a phone number
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]+$');
    if (phoneRegex.hasMatch(cleanInput)) {
      final phoneResult = validatePhone(cleanInput);
      return phoneResult.copyWith(
        metadata: {'inputType': 'phone'},
      );
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
    
    if (password.length < 8) {
      return ValidationResult(
        isValid: false,
        message: 'Password must be at least 8 characters',
        severity: ValidationSeverity.error,
      );
    }
    
    // Password strength calculation
    int strength = 0;
    if (password.length >= 8) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
    if (RegExp(r'[a-z]').hasMatch(password)) strength++;
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength++;
    
    String strengthText = '';
    Color strengthColor = Colors.red;
    
    if (strength >= 4) {
      strengthText = 'Strong password';
      strengthColor = Colors.green;
    } else if (strength >= 3) {
      strengthText = 'Good password';
      strengthColor = Colors.orange;
    } else {
      strengthText = 'Weak password - add uppercase, numbers, symbols';
      strengthColor = Colors.red;
    }
    
    return ValidationResult(
      isValid: strength >= 3,
      message: strengthText,
      severity: strength >= 3 ? ValidationSeverity.success : ValidationSeverity.warning,
      metadata: {'strength': strength, 'color': strengthColor},
    );
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
