# 🧪 Testing Documentation

## Overview

This document outlines the comprehensive testing strategy for the Squeak Flutter application, including unit tests, widget tests, integration tests, and testing best practices.

Note (2025-09): Recent UI-only updates include a theme palette change and a Home tip banner sourced from a local JSON asset. No API contracts changed; existing tests remain valid. Prefer snapshot (golden) tests for the new `DidYouKnowCard` variations and smoke tests for Home rendering.

## 🏗️ Testing Architecture

### Testing Pyramid Structure

```
    /\
   /  \          Integration Tests
  /____\         (E2E, API, User Flows)
 /      \        
/________\       Widget Tests
           \     (UI Components, Interactions)
            \    
_____________\   Unit Tests
              \  (Business Logic, Utils, Models)
```

### Test Categories

#### Unit Tests (70%)
- **Purpose**: Test individual functions, methods, and classes in isolation
- **Focus**: Business logic, data models, utilities, services
- **Location**: `test/unit/`
- **Tools**: `flutter_test`, `mockito`

#### Widget Tests (20%)
- **Purpose**: Test UI components and user interactions
- **Focus**: Widget rendering, user input, state changes
- **Location**: `test/widget/`
- **Tools**: `flutter_test`, `mockito`

#### Integration Tests (10%)
- **Purpose**: Test complete user workflows and API integrations
- **Focus**: End-to-end scenarios, API communication
- **Location**: `integration_test/`
- **Tools**: `integration_test`, `flutter_driver`

## 📁 Test Structure

```
test/
├── unit/
│   ├── core/
│   │   ├── service/
│   │   │   ├── api_service_test.dart
│   │   │   ├── auth_service_test.dart
│   │   │   └── notification_service_test.dart
│   │   ├── utils/
│   │   │   ├── validators_test.dart
│   │   │   ├── date_utils_test.dart
│   │   │   └── encryption_utils_test.dart
│   │   └── models/
│   │       ├── user_model_test.dart
│   │       ├── pet_model_test.dart
│   │       └── appointment_model_test.dart
│   ├── features/
│   │   ├── auth/
│   │   │   ├── cubit/
│   │   │   │   ├── login_cubit_test.dart
│   │   │   │   ├── register_cubit_test.dart
│   │   │   │   └── forgot_password_cubit_test.dart
│   │   │   └── repository/
│   │   │       └── auth_repository_test.dart
│   │   ├── pets/
│   │   │   ├── cubit/
│   │   │   │   ├── pets_cubit_test.dart
│   │   │   │   └── add_pet_cubit_test.dart
│   │   │   └── repository/
│   │   │       └── pets_repository_test.dart
│   │   └── appointments/
│   │       ├── cubit/
│   │       │   ├── appointments_cubit_test.dart
│   │       │   └── book_appointment_cubit_test.dart
│   │       └── repository/
│   │           └── appointments_repository_test.dart
│   └── helpers/
│       ├── mock_data.dart
│       ├── test_helpers.dart
│       └── pump_app.dart
├── widget/
│   ├── core/
│   │   └── global_widget/
│   │       ├── vc_loading_widget_test.dart
│   │       ├── vc_button_test.dart
│   │       └── vc_text_field_test.dart
│   ├── features/
│   │   ├── auth/
│   │   │   ├── login_page_test.dart
│   │   │   ├── register_page_test.dart
│   │   │   └── forgot_password_page_test.dart
│   │   ├── pets/
│   │   │   ├── pets_page_test.dart
│   │   │   ├── add_pet_page_test.dart
│   │   │   └── pet_profile_page_test.dart
│   │   └── appointments/
│   │       ├── appointments_page_test.dart
│   │       ├── book_appointment_page_test.dart
│   │       └── appointment_details_page_test.dart
│   └── helpers/
│       ├── widget_test_helpers.dart
│       └── golden_test_helpers.dart
└── integration_test/
    ├── app_test.dart
    ├── auth_flow_test.dart
    ├── pet_management_test.dart
    ├── appointment_booking_test.dart
    └── helpers/
        └── integration_test_helpers.dart
```

## 🧪 Unit Testing

### Testing BLoC/Cubit

#### Login Cubit Test Example
```dart
// test/unit/features/auth/cubit/login_cubit_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:squeak/features/auth/cubit/login_cubit.dart';
import 'package:squeak/features/auth/repository/auth_repository.dart';
import 'package:squeak/core/models/user_model.dart';

import 'login_cubit_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  group('LoginCubit', () {
    late LoginCubit loginCubit;
    late MockAuthRepository mockAuthRepository;
    
    setUp(() {
      mockAuthRepository = MockAuthRepository();
      loginCubit = LoginCubit(mockAuthRepository);
    });
    
    tearDown(() {
      loginCubit.close();
    });
    
    test('initial state is LoginInitial', () {
      expect(loginCubit.state, equals(LoginInitial()));
    });
    
    group('login', () {
      const email = 'test@example.com';
      const password = 'password123';
      const user = UserModel(
        id: '1',
        email: email,
        name: 'Test User',
      );
      
      blocTest<LoginCubit, LoginState>(
        'emits [LoginLoading, LoginSuccess] when login succeeds',
        build: () {
          when(mockAuthRepository.login(email, password))
              .thenAnswer((_) async => user);
          return loginCubit;
        },
        act: (cubit) => cubit.login(email, password),
        expect: () => [
          LoginLoading(),
          LoginSuccess(user),
        ],
        verify: (_) {
          verify(mockAuthRepository.login(email, password)).called(1);
        },
      );
      
      blocTest<LoginCubit, LoginState>(
        'emits [LoginLoading, LoginError] when login fails',
        build: () {
          when(mockAuthRepository.login(email, password))
              .thenThrow(Exception('Invalid credentials'));
          return loginCubit;
        },
        act: (cubit) => cubit.login(email, password),
        expect: () => [
          LoginLoading(),
          LoginError('Invalid credentials'),
        ],
      );
      
      blocTest<LoginCubit, LoginState>(
        'emits [LoginLoading, LoginError] when email is invalid',
        build: () => loginCubit,
        act: (cubit) => cubit.login('invalid-email', password),
        expect: () => [
          LoginLoading(),
          LoginError('Please enter a valid email address'),
        ],
        verify: (_) {
          verifyNever(mockAuthRepository.login(any, any));
        },
      );
    });
    
    group('logout', () {
      blocTest<LoginCubit, LoginState>(
        'emits [LoginInitial] when logout succeeds',
        build: () {
          when(mockAuthRepository.logout())
              .thenAnswer((_) async => {});
          return loginCubit;
        },
        act: (cubit) => cubit.logout(),
        expect: () => [LoginInitial()],
      );
    });
  });
}
```

### Testing Repository

#### Auth Repository Test Example
```dart
// test/unit/features/auth/repository/auth_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:squeak/features/auth/repository/auth_repository.dart';
import 'package:squeak/core/service/api_service.dart';
import 'package:squeak/core/models/user_model.dart';

import 'auth_repository_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  group('AuthRepository', () {
    late AuthRepository authRepository;
    late MockApiService mockApiService;
    
    setUp(() {
      mockApiService = MockApiService();
      authRepository = AuthRepository(mockApiService);
    });
    
    group('login', () {
      const email = 'test@example.com';
      const password = 'password123';
      
      test('returns UserModel when login is successful', () async {
        // Arrange
        final responseData = {
          'user': {
            'id': '1',
            'email': email,
            'name': 'Test User',
          },
          'token': 'mock_token',
        };
        
        when(mockApiService.post('/auth/login', data: {
          'email': email,
          'password': password,
        })).thenAnswer((_) async => responseData);
        
        // Act
        final result = await authRepository.login(email, password);
        
        // Assert
        expect(result, isA<UserModel>());
        expect(result.email, equals(email));
        expect(result.name, equals('Test User'));
        
        verify(mockApiService.post('/auth/login', data: {
          'email': email,
          'password': password,
        })).called(1);
      });
      
      test('throws exception when login fails', () async {
        // Arrange
        when(mockApiService.post('/auth/login', data: anyNamed('data')))
            .thenThrow(Exception('Network error'));
        
        // Act & Assert
        expect(
          () => authRepository.login(email, password),
          throwsException,
        );
      });
    });
    
    group('register', () {
      const userData = {
        'name': 'Test User',
        'email': 'test@example.com',
        'password': 'password123',
        'phone': '+1234567890',
      };
      
      test('returns UserModel when registration is successful', () async {
        // Arrange
        final responseData = {
          'user': {
            'id': '1',
            'email': userData['email'],
            'name': userData['name'],
          },
          'token': 'mock_token',
        };
        
        when(mockApiService.post('/auth/register', data: userData))
            .thenAnswer((_) async => responseData);
        
        // Act
        final result = await authRepository.register(userData);
        
        // Assert
        expect(result, isA<UserModel>());
        expect(result.email, equals(userData['email']));
        expect(result.name, equals(userData['name']));
      });
    });
  });
}
```

### Testing Models

#### User Model Test Example
```dart
// test/unit/core/models/user_model_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:squeak/core/models/user_model.dart';

void main() {
  group('UserModel', () {
    const testUserData = {
      'id': '1',
      'email': 'test@example.com',
      'name': 'Test User',
      'phone': '+1234567890',
      'is_verified': true,
      'created_at': '2024-01-01T00:00:00Z',
    };
    
    group('fromJson', () {
      test('should return a valid UserModel from JSON', () {
        // Act
        final result = UserModel.fromJson(testUserData);
        
        // Assert
        expect(result.id, equals('1'));
        expect(result.email, equals('test@example.com'));
        expect(result.name, equals('Test User'));
        expect(result.phone, equals('+1234567890'));
        expect(result.isVerified, isTrue);
        expect(result.createdAt, isA<DateTime>());
      });
      
      test('should handle missing optional fields', () {
        // Arrange
        final minimalData = {
          'id': '1',
          'email': 'test@example.com',
          'name': 'Test User',
        };
        
        // Act
        final result = UserModel.fromJson(minimalData);
        
        // Assert
        expect(result.id, equals('1'));
        expect(result.email, equals('test@example.com'));
        expect(result.name, equals('Test User'));
        expect(result.phone, isNull);
        expect(result.isVerified, isFalse);
        expect(result.createdAt, isNull);
      });
    });
    
    group('toJson', () {
      test('should return a valid JSON map', () {
        // Arrange
        final user = UserModel.fromJson(testUserData);
        
        // Act
        final result = user.toJson();
        
        // Assert
        expect(result['id'], equals('1'));
        expect(result['email'], equals('test@example.com'));
        expect(result['name'], equals('Test User'));
        expect(result['phone'], equals('+1234567890'));
        expect(result['is_verified'], isTrue);
        expect(result['created_at'], isA<String>());
      });
    });
    
    group('copyWith', () {
      test('should return a new instance with updated values', () {
        // Arrange
        final originalUser = UserModel.fromJson(testUserData);
        
        // Act
        final updatedUser = originalUser.copyWith(
          name: 'Updated Name',
          phone: '+9876543210',
        );
        
        // Assert
        expect(updatedUser.id, equals(originalUser.id));
        expect(updatedUser.email, equals(originalUser.email));
        expect(updatedUser.name, equals('Updated Name'));
        expect(updatedUser.phone, equals('+9876543210'));
        expect(updatedUser.isVerified, equals(originalUser.isVerified));
      });
    });
    
    group('equality', () {
      test('should be equal when all properties are the same', () {
        // Arrange
        final user1 = UserModel.fromJson(testUserData);
        final user2 = UserModel.fromJson(testUserData);
        
        // Assert
        expect(user1, equals(user2));
        expect(user1.hashCode, equals(user2.hashCode));
      });
      
      test('should not be equal when properties differ', () {
        // Arrange
        final user1 = UserModel.fromJson(testUserData);
        final user2 = user1.copyWith(name: 'Different Name');
        
        // Assert
        expect(user1, isNot(equals(user2)));
        expect(user1.hashCode, isNot(equals(user2.hashCode)));
      });
    });
  });
}
```

### Testing Utilities

#### Validator Utils Test Example
```dart
// test/unit/core/utils/validators_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:squeak/core/utils/validators.dart';

void main() {
  group('Validators', () {
    group('email validation', () {
      test('should return null for valid emails', () {
        const validEmails = [
          'test@example.com',
          'user.name@domain.co.uk',
          'firstname+lastname@company.org',
        ];
        
        for (final email in validEmails) {
          expect(Validators.email(email), isNull);
        }
      });
      
      test('should return error message for invalid emails', () {
        const invalidEmails = [
          '',
          'invalid',
          'test@',
          '@domain.com',
          'test.domain.com',
        ];
        
        for (final email in invalidEmails) {
          expect(Validators.email(email), isNotNull);
        }
      });
    });
    
    group('password validation', () {
      test('should return null for valid passwords', () {
        const validPasswords = [
          'Password123!',
          'MySecure123',
          'Test@1234',
        ];
        
        for (final password in validPasswords) {
          expect(Validators.password(password), isNull);
        }
      });
      
      test('should return error for passwords less than 8 characters', () {
        expect(Validators.password('Test123'), isNotNull);
      });
      
      test('should return error for passwords without numbers', () {
        expect(Validators.password('TestPassword'), isNotNull);
      });
      
      test('should return error for passwords without letters', () {
        expect(Validators.password('12345678'), isNotNull);
      });
    });
    
    group('phone validation', () {
      test('should return null for valid phone numbers', () {
        const validPhones = [
          '+1234567890',
          '+966512345678',
          '+44123456789',
        ];
        
        for (final phone in validPhones) {
          expect(Validators.phone(phone), isNull);
        }
      });
      
      test('should return error for invalid phone numbers', () {
        const invalidPhones = [
          '123456789',  // No country code
          '+123',       // Too short
          'abc123',     // Contains letters
          '',           // Empty
        ];
        
        for (final phone in invalidPhones) {
          expect(Validators.phone(phone), isNotNull);
        }
      });
    });
  });
}
```

## 🎯 Widget Testing

### Testing Custom Widgets

#### VcButton Widget Test Example
```dart
// test/widget/core/global_widget/vc_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:squeak/core/service/global_widget/vc_button.dart';
import '../../helpers/pump_app.dart';

void main() {
  group('VcButton', () {
    testWidgets('should display child widget', (tester) async {
      // Arrange
      const buttonText = 'Test Button';
      
      // Act
      await tester.pumpApp(
        VcButton(
          onPressed: () {},
          child: const Text(buttonText),
        ),
      );
      
      // Assert
      expect(find.text(buttonText), findsOneWidget);
    });
    
    testWidgets('should call onPressed when tapped', (tester) async {
      // Arrange
      var wasPressed = false;
      
      // Act
      await tester.pumpApp(
        VcButton(
          onPressed: () => wasPressed = true,
          child: const Text('Tap me'),
        ),
      );
      
      await tester.tap(find.byType(VcButton));
      await tester.pumpAndSettle();
      
      // Assert
      expect(wasPressed, isTrue);
    });
    
    testWidgets('should not call onPressed when disabled', (tester) async {
      // Arrange
      var wasPressed = false;
      
      // Act
      await tester.pumpApp(
        VcButton(
          onPressed: null,
          child: const Text('Disabled'),
        ),
      );
      
      await tester.tap(find.byType(VcButton));
      await tester.pumpAndSettle();
      
      // Assert
      expect(wasPressed, isFalse);
    });
    
    testWidgets('should show loading indicator when loading', (tester) async {
      // Act
      await tester.pumpApp(
        const VcButton(
          onPressed: null,
          isLoading: true,
          child: Text('Loading'),
        ),
      );
      
      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading'), findsNothing);
    });
    
    testWidgets('should have correct styling', (tester) async {
      // Act
      await tester.pumpApp(
        VcButton(
          onPressed: () {},
          child: const Text('Styled Button'),
        ),
      );
      
      // Assert
      final container = tester.widget<Container>(
        find.ancestor(
          of: find.text('Styled Button'),
          matching: find.byType(Container),
        ).first,
      );
      
      expect(container.decoration, isA<BoxDecoration>());
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, isA<BorderRadius>());
      expect(decoration.boxShadow, isNotNull);
    });
  });
}
```

### Testing Page Widgets

#### Login Page Widget Test Example
```dart
// test/widget/features/auth/login_page_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:squeak/features/auth/cubit/login_cubit.dart';
import 'package:squeak/features/auth/view/login_page.dart';
import '../../helpers/pump_app.dart';

import 'login_page_test.mocks.dart';

@GenerateMocks([LoginCubit])
void main() {
  group('LoginPage', () {
    late MockLoginCubit mockLoginCubit;
    
    setUp(() {
      mockLoginCubit = MockLoginCubit();
      when(mockLoginCubit.state).thenReturn(LoginInitial());
    });
    
    testWidgets('should display email and password fields', (tester) async {
      // Act
      await tester.pumpApp(
        BlocProvider<LoginCubit>.value(
          value: mockLoginCubit,
          child: const LoginPage(),
        ),
      );
      
      // Assert
      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);
    });
    
    testWidgets('should display login button', (tester) async {
      // Act
      await tester.pumpApp(
        BlocProvider<LoginCubit>.value(
          value: mockLoginCubit,
          child: const LoginPage(),
        ),
      );
      
      // Assert
      expect(find.byKey(const Key('login_button')), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });
    
    testWidgets('should call login when form is submitted', (tester) async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      
      // Act
      await tester.pumpApp(
        BlocProvider<LoginCubit>.value(
          value: mockLoginCubit,
          child: const LoginPage(),
        ),
      );
      
      // Enter email and password
      await tester.enterText(
        find.byKey(const Key('email_field')),
        email,
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        password,
      );
      
      // Tap login button
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();
      
      // Assert
      verify(mockLoginCubit.login(email, password)).called(1);
    });
    
    testWidgets('should show loading indicator when logging in', (tester) async {
      // Arrange
      when(mockLoginCubit.state).thenReturn(LoginLoading());
      
      // Act
      await tester.pumpApp(
        BlocProvider<LoginCubit>.value(
          value: mockLoginCubit,
          child: const LoginPage(),
        ),
      );
      
      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
    
    testWidgets('should show error message when login fails', (tester) async {
      // Arrange
      const errorMessage = 'Invalid credentials';
      when(mockLoginCubit.state).thenReturn(LoginError(errorMessage));
      
      // Act
      await tester.pumpApp(
        BlocProvider<LoginCubit>.value(
          value: mockLoginCubit,
          child: const LoginPage(),
        ),
      );
      
      // Assert
      expect(find.text(errorMessage), findsOneWidget);
    });
    
    testWidgets('should navigate to register page when link is tapped', (tester) async {
      // Act
      await tester.pumpApp(
        BlocProvider<LoginCubit>.value(
          value: mockLoginCubit,
          child: const LoginPage(),
        ),
      );
      
      await tester.tap(find.byKey(const Key('register_link')));
      await tester.pumpAndSettle();
      
      // Assert navigation would be verified through integration tests
      // or by mocking the Navigator
    });
  });
}
```

### Testing Helper

#### Pump App Helper
```dart
// test/helpers/pump_app.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:squeak/core/theme/app_theme.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    Locale locale = const Locale('en'),
    ThemeData? theme,
  }) async {
    await pumpWidget(
      MaterialApp(
        locale: locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('ar'),
        ],
        theme: theme ?? AppTheme.lightTheme,
        home: Material(child: widget),
      ),
    );
  }
}
```

## 🔗 Integration Testing

### App Integration Test Example
```dart
// integration_test/app_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:squeak/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('App Integration Tests', () {
    testWidgets('complete login flow', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();
      
      // Navigate to login if not already there
      if (find.text('Login').isPresent) {
        await tester.tap(find.text('Login'));
        await tester.pumpAndSettle();
      }
      
      // Enter credentials
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );
      
      // Submit form
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // Verify successful login
      expect(find.text('Welcome'), findsOneWidget);
    });
    
    testWidgets('complete pet management flow', (tester) async {
      // Login first
      await _performLogin(tester);
      
      // Navigate to pets
      await tester.tap(find.byIcon(Icons.pets));
      await tester.pumpAndSettle();
      
      // Add new pet
      await tester.tap(find.byKey(const Key('add_pet_fab')));
      await tester.pumpAndSettle();
      
      // Fill pet details
      await tester.enterText(
        find.byKey(const Key('pet_name_field')),
        'Fluffy',
      );
      await tester.tap(find.byKey(const Key('pet_type_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cat').last);
      await tester.pumpAndSettle();
      
      // Save pet
      await tester.tap(find.byKey(const Key('save_pet_button')));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      
      // Verify pet was added
      expect(find.text('Fluffy'), findsOneWidget);
    });
    
    testWidgets('complete appointment booking flow', (tester) async {
      // Login and navigate to appointments
      await _performLogin(tester);
      await tester.tap(find.byIcon(Icons.calendar_today));
      await tester.pumpAndSettle();
      
      // Book new appointment
      await tester.tap(find.byKey(const Key('book_appointment_fab')));
      await tester.pumpAndSettle();
      
      // Select clinic
      await tester.tap(find.byKey(const Key('clinic_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('VetCare Clinic').last);
      await tester.pumpAndSettle();
      
      // Select data
      await tester.tap(find.byKey(const Key('date_picker')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('15')); // Select 15th of current month
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      
      // Select time
      await tester.tap(find.byKey(const Key('time_slot')).first);
      await tester.pumpAndSettle();
      
      // Confirm booking
      await tester.tap(find.byKey(const Key('confirm_booking_button')));
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // Verify booking
      expect(find.text('Appointment Booked'), findsOneWidget);
    });
  });
}

Future<void> _performLogin(WidgetTester tester) async {
  // Check if already logged in
  if (find.text('Welcome').isPresent) return;
  
  // Navigate to login
  await tester.tap(find.text('Login'));
  await tester.pumpAndSettle();
  
  // Enter credentials
  await tester.enterText(
    find.byKey(const Key('email_field')),
    'test@example.com',
  );
  await tester.enterText(
    find.byKey(const Key('password_field')),
    'password123',
  );
  
  // Submit
  await tester.tap(find.byKey(const Key('login_button')));
  await tester.pumpAndSettle(const Duration(seconds: 3));
}

extension FinderExtensions on Finder {
  bool get isPresent => evaluate().isNotEmpty;
}
```

## 📊 Test Configuration

### pubspec.yaml Test Dependencies
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  bloc_test: ^9.1.5
  mockito: ^5.4.4
  build_runner: ^2.4.7
  golden_toolkit: ^0.15.0
  network_image_mock: ^2.1.1
```

### Test Coverage Configuration
```yaml
# analysis_options.yaml
analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "**/*.mocks.dart"
    - "**/l10n/**"

linter:
  rules:
    - prefer_const_constructors
    - avoid_print
    - prefer_single_quotes
```

### Test Scripts
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run only unit tests
flutter test test/unit/

# Run only widget tests
flutter test test/widget/

# Run integration tests
flutter test integration_test/

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html

# Generate mocks
flutter packages pub run build_runner build
```

## 🎯 Testing Best Practices

### 1. Test Structure (AAA Pattern)
```dart
test('description', () {
  // Arrange - Set up test data
  final input = 'test data';
  
  // Act - Execute the code under test
  final result = functionUnderTest(input);
  
  // Assert - Verify the result
  expect(result, expectedValue);
});
```

### 2. Test Naming Convention
```dart
// Good test names
'should return user when login is successful'
'should throw exception when email is invalid'
'should emit loading state when fetching data'

// Bad test names
'test login'
'check user'
'test 1'
```

### 3. Mock Data Management
```dart
// test/helpers/mock_data.dart
class MockData {
  static const userJson = {
    'id': '1',
    'email': 'test@example.com',
    'name': 'Test User',
  };
  
  static UserModel get user => UserModel.fromJson(userJson);
  
  static List<PetModel> get pets => [
    PetModel(id: '1', name: 'Fluffy', type: 'Cat'),
    PetModel(id: '2', name: 'Buddy', type: 'Dog'),
  ];
}
```

### 4. Test Performance Guidelines
- Keep tests fast (< 100ms for unit tests)
- Use `setUp()` and `tearDown()` appropriately
- Mock external dependencies
- Avoid testing implementation details

### 5. Coverage Goals
- **Unit Tests**: 80-90% coverage
- **Widget Tests**: 70-80% coverage
- **Integration Tests**: Critical user flows

### 6. Continuous Integration
```yaml
# .github/workflows/test.yml
name: Test
on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.3'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Run tests
        run: flutter test --coverage
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          file: coverage/lcov.info
```

## 🛠️ Testing Tools & Utilities

### 1. Golden Tests for UI
```dart
// test/widget/golden/login_page_golden_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  group('LoginPage Golden Tests', () {
    testGoldens('should match golden file', (tester) async {
      await tester.pumpWidgetBuilder(
        const LoginPage(),
        surfaceSize: const Size(375, 812), // iPhone X size
      );
      
      await screenMatchesGolden(tester, 'login_page');
    });
  });
}
```

### 2. Performance Testing
```dart
// test/performance/app_performance_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/scheduler.dart';

void main() {
  testWidgets('should maintain 60fps during scrolling', (tester) async {
    final binding = tester.binding;
    
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    
    // Start performance tracking
    final timeline = await binding.traceAction(() async {
      // Perform scroll action
      await tester.drag(
        find.byType(ListView),
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();
    });
    
    // Analyze performance
    final summary = TimelineSummary.summarize(timeline);
    expect(summary.averageFrameBuildTimeMillis, lessThan(16)); // 60fps
  });
}
```

### 3. Accessibility Testing
```dart
testWidgets('should be accessible', (tester) async {
  await tester.pumpApp(const LoginPage());
  
  // Check for accessibility guidelines
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  await expectLater(tester, meetsGuideline(textContrastGuideline));
});
```

---

This comprehensive testing documentation ensures robust, maintainable, and reliable code throughout the Squeak application development lifecycle.
