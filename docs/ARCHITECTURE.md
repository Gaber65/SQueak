# 🏗️ Squeak App Architecture Documentation

## Overview

This document provides a comprehensive overview of the Squeak Flutter application architecture, design patterns, and implementation strategies.

## 🎯 Architecture Principles

### Clean Architecture
The app follows Clean Architecture principles with clear separation of concerns:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Presentation   │────│    Domain       │────│      Data       │
│     Layer       │    │     Layer       │    │     Layer       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### Core Principles
- **Dependency Inversion**: High-level modules don't depend on low-level modules
- **Separation of Concerns**: Each layer has specific responsibilities
- **Testability**: Easy unit testing through dependency injection
- **Maintainability**: Modular structure for easy maintenance
- **Scalability**: Architecture supports app growth

## 📁 Project Structure

### Directory Organization
```
lib/
├── core/                          # Shared functionality
│   ├── error/                     # Error handling
│   │   ├── exception.dart         # Custom exceptions
│   │   └── failures.dart          # Failure classes
│   ├── network/                   # Networking
│   │   ├── dio.dart               # HTTP client setup
│   │   └── network_info.dart      # Network connectivity
│   ├── service/                   # Global services
│   │   ├── global_function/       # Utility functions
│   │   ├── global_widget/         # Reusable widgets
│   │   └── service_locator/       # Dependency injection
│   └── utils/                     # Utilities
│       ├── theme/                 # App theming
│       │   └── widgets/           # Design system and pet teaching widgets
│       ├── constants/             # App constants
│       └── helpers/               # Helper functions
├── features/                      # Feature modules
│   ├── auth/                      # Authentication
│   │   ├── data/                  # Data layer
│   │   │   ├── datasources/       # Remote/local data sources
│   │   │   ├── models/            # Data models
│   │   │   └── repositories/      # Repository implementations
│   │   ├── domain/                # Domain layer
│   │   │   ├── entities/          # Business entities
│   │   │   ├── repositories/      # Repository contracts
│   │   │   └── usecases/          # Business use cases
│   │   └── presentation/          # Presentation layer
│   │       ├── cubit/             # State management
│   │       ├── pages/             # Screen widgets
│   │       └── widgets/           # Reusable UI components
│   └── [other features]/          # Similar structure
└── generated/                     # Generated files
    └── intl/                      # Localization files
```

### UI Refresh Notes (2025-09)
- Pets-First UX refresh was applied as a presentation-layer change only.
- Theming centralized via `ColorManager` and `AppTheme` moved to a clinical blue→purple palette.
- A lightweight `PetTipsRepository` reads tips from bundled JSON at `assets/content/pet_tips.json` for Did-You-Know cards; no backend dependency.

## 🧩 Layer Architecture

### 1. Presentation Layer

#### Responsibilities
- UI rendering and user interactions
- State management with BLoC/Cubit
- Navigation and routing
- Input validation and formatting

#### Key Components
```dart
// State Management
abstract class AuthState extends Equatable {}
class AuthCubit extends Cubit<AuthState> { ... }

// UI Components
class LoginScreen extends StatelessWidget { ... }
class VcButton extends StatelessWidget { ... }
```

#### Implementation Pattern
```dart
class FeatureCubit extends Cubit<FeatureState> {
  final UseCase useCase;
  
  FeatureCubit({required this.useCase}) : super(FeatureInitial());
  
  Future<void> performAction() async {
    emit(FeatureLoading());
    
    final result = await useCase.call(params);
    
    result.fold(
      (failure) => emit(FeatureError(failure.message)),
      (data) => emit(FeatureSuccess(data)),
    );
  }
}
```

### 2. Domain Layer

#### Responsibilities
- Business logic and rules
- Entity definitions
- Repository contracts
- Use case implementations

#### Key Components
```dart
// Entities
class PetEntity extends Equatable {
  final int id;
  final String name;
  final String type;
  // ...
}

// Repository Contracts
abstract class PetRepository {
  Future<Either<Failure, List<PetEntity>>> getOwnerPets();
  Future<Either<Failure, PetEntity>> addPet(PetEntity pet);
}

// Use Cases
class GetOwnerPetsUseCase {
  final PetRepository repository;
  
  GetOwnerPetsUseCase(this.repository);
  
  Future<Either<Failure, List<PetEntity>>> call() {
    return repository.getOwnerPets();
  }
}
```

### 3. Data Layer

#### Responsibilities
- External data sources (API, database)
- Data models and serialization
- Repository implementations
- Caching strategies

#### Key Components
```dart
// Data Models
class PetModel extends PetEntity {
  const PetModel({required super.id, required super.name, ...});
  
  factory PetModel.fromJson(Map<String, dynamic> json) { ... }
  Map<String, dynamic> toJson() { ... }
}

// Data Sources
abstract class PetRemoteDataSource {
  Future<List<PetModel>> getOwnerPets();
}

class PetRemoteDataSourceImpl implements PetRemoteDataSource {
  final DioFinalHelper client;
  
  @override
  Future<List<PetModel>> getOwnerPets() async {
    final response = await client.getData(method: '/pets/owner');
    return (response.data['data'] as List)
        .map((json) => PetModel.fromJson(json))
        .toList();
  }
}

// Repository Implementation
class PetRepositoryImpl implements PetRepository {
  final PetRemoteDataSource remoteDataSource;
  final PetLocalDataSource localDataSource;
  
  PetRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  
  @override
  Future<Either<Failure, List<PetEntity>>> getOwnerPets() async {
    try {
      final pets = await remoteDataSource.getOwnerPets();
      await localDataSource.cachePets(pets);
      return Right(pets);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
```

## 🔄 State Management

### BLoC Pattern Implementation

#### Why BLoC?
- **Predictable**: Unidirectional data flow
- **Testable**: Easy to unit test business logic
- **Separation**: Clear separation of UI and business logic
- **Reactive**: Stream-based reactive programming

#### Cubit vs BLoC
```dart
// Simple state changes - use Cubit
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);
  
  void increment() => emit(state + 1);
}

// Complex state management - use BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }
}
```

#### State Classes Structure
```dart
abstract class FeatureState extends Equatable {
  const FeatureState();
  
  @override
  List<Object?> get props => [];
}

class FeatureInitial extends FeatureState {}
class FeatureLoading extends FeatureState {}
class FeatureSuccess extends FeatureState {
  final DataType data;
  const FeatureSuccess(this.data);
  
  @override
  List<Object?> get props => [data];
}
class FeatureError extends FeatureState {
  final String message;
  const FeatureError(this.message);
  
  @override
  List<Object?> get props => [message];
}
```

### State Management Best Practices

#### 1. State Composition
```dart
class PetState extends Equatable {
  final List<PetEntity> pets;
  final bool isLoading;
  final String? error;
  final PetEntity? selectedPet;
  
  const PetState({
    this.pets = const [],
    this.isLoading = false,
    this.error,
    this.selectedPet,
  });
  
  PetState copyWith({
    List<PetEntity>? pets,
    bool? isLoading,
    String? error,
    PetEntity? selectedPet,
  }) {
    return PetState(
      pets: pets ?? this.pets,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedPet: selectedPet ?? this.selectedPet,
    );
  }
  
  @override
  List<Object?> get props => [pets, isLoading, error, selectedPet];
}
```

#### 2. Event Handling
```dart
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  
  Future<void> login(String email, String password) async {
    if (state is AuthLoading) return; // Prevent duplicate requests
    
    emit(AuthLoading());
    
    try {
      final result = await loginUseCase.call(
        LoginParams(email: email, password: password),
      );
      
      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (user) => emit(AuthSuccess(user)),
      );
    } catch (e) {
      emit(AuthError('Unexpected error occurred'));
    }
  }
}
```

## 🔌 Dependency Injection

### Service Locator Pattern

#### Setup with GetIt
```dart
final sl = GetIt.instance;

Future<void> init() async {
  // Features
  _initAuth();
  _initPets();
  
  // Core
  _initCore();
  
  // External
  await _initExternal();
}

void _initAuth() {
  // Cubit
  sl.registerFactory(() => AuthCubit(
    loginUseCase: sl(),
    logoutUseCase: sl(),
  ));
  
  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  
  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
  
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );
}
```

#### Registration Types
- **Factory**: New instance every time `sl<T>()`
- **LazySingleton**: Single instance, created when first accessed
- **Singleton**: Single instance, created immediately

### Dependency Graph
```
┌─────────────┐
│   Screen    │
└──────┬──────┘
       │ inject
┌──────▼──────┐
│    Cubit    │
└──────┬──────┘
       │ inject
┌──────▼──────┐
│  Use Case   │
└──────┬──────┘
       │ inject
┌──────▼──────┐
│ Repository  │
└──────┬──────┘
       │ inject
┌──────▼──────┐
│Data Source  │
└─────────────┘
```

## 🌐 Data Flow

### Request Flow
```
UI Event → Cubit → UseCase → Repository → DataSource → API
```

### Response Flow
```
API Response → DataSource → Repository → UseCase → Cubit → UI Update
```

### Detailed Flow Example
```dart
// 1. UI Event
onPressed: () => context.read<PetCubit>().loadPets()

// 2. Cubit Method
Future<void> loadPets() async {
  emit(PetLoading());
  
  final result = await getOwnerPetsUseCase.call();
  
  result.fold(
    (failure) => emit(PetError(failure.message)),
    (pets) => emit(PetLoaded(pets)),
  );
}

// 3. Use Case
Future<Either<Failure, List<PetEntity>>> call() {
  return repository.getOwnerPets();
}

// 4. Repository
Future<Either<Failure, List<PetEntity>>> getOwnerPets() async {
  try {
    final pets = await remoteDataSource.getOwnerPets();
    return Right(pets);
  } catch (e) {
    return Left(ServerFailure(e.message));
  }
}

// 5. Data Source
Future<List<PetModel>> getOwnerPets() async {
  final response = await client.getData(method: '/pets/owner');
  return (response.data['data'] as List)
      .map((json) => PetModel.fromJson(json))
      .toList();
}
```

## 🔧 Error Handling

### Error Architecture
```dart
// Base Failure Class
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);
  
  @override
  List<Object> get props => [message];
}

// Specific Failures
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
```

### Exception Handling
```dart
// Custom Exceptions
class ServerException implements Exception {
  final ErrorMessageModel errorMessageModel;
  const ServerException(this.errorMessageModel);
}

// Error Model
class ErrorMessageModel extends Equatable {
  final String message;
  final Map<String, List<String>> errors;
  
  const ErrorMessageModel({
    required this.message,
    required this.errors,
  });
  
  factory ErrorMessageModel.fromJson(Map<String, dynamic> json) {
    return ErrorMessageModel(
      message: json['message'] ?? 'Unknown error',
      errors: Map<String, List<String>>.from(
        json['errors']?.map((key, value) => 
          MapEntry(key, List<String>.from(value))) ?? {},
      ),
    );
  }
}
```

### Global Error Handling
```dart
// In Repository
try {
  final response = await remoteDataSource.getData();
  return Right(response);
} on ServerException catch (e) {
  return Left(ServerFailure(e.errorMessageModel.message));
} on SocketException {
  return Left(NetworkFailure('No internet connection'));
} catch (e) {
  return Left(ServerFailure('Unexpected error: ${e.toString()}'));
}
```

## 🔒 Security Architecture

### Authentication Flow
```dart
class TokenManager {
  static Future<void> saveToken(String token, int expiresIn, String refreshToken) {
    // Save to secure storage
  }
  
  static Future<bool> isAccessTokenExpired() {
    // Check token expiration
  }
  
  static Future<void> refreshToken() {
    // Refresh expired token
  }
}
```

### Request Interceptor
```dart
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Check token validity
    if (await TokenManager.isAccessTokenExpired()) {
      await TokenManager.refreshToken();
    }
    
    // Add auth header
    final token = await CacheHelper.getData('token');
    options.headers['Authorization'] = 'Bearer $token';
    
    handler.next(options);
  }
}
```

## 🎨 UI Architecture

### Widget Composition
```dart
// Atomic Design Pattern
atoms/      # Basic UI elements (buttons, inputs)
molecules/  # Simple UI combinations
organisms/  # Complex UI sections
templates/  # Page layouts
pages/      # Complete screens
```

### Custom Widget Structure
```dart
class VcButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final ButtonStyle? style;
  
  const VcButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.style,
  });
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style ?? _defaultStyle(context),
      child: isLoading 
        ? const CircularProgressIndicator()
        : child,
    );
  }
}
```

### Responsive Design
```dart
class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  
  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= 768) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}
```

## 📊 Performance Optimization

### Memory Management
```dart
class PetCubit extends Cubit<PetState> {
  StreamSubscription? _subscription;
  
  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
```

### Image Optimization
```dart
// Use FastCachedNetworkImage
FastCachedImage(
  url: imageUrl,
  fit: BoxFit.cover,
  placeholder: (context, url) => const ShimmerWidget(),
  errorWidget: (context, url, error) => const ErrorWidget(),
)
```

### List Performance
```dart
// Use ListView.builder for large lists
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return PetCard(pet: items[index]);
  },
)

// Use ListView.separated for better performance
ListView.separated(
  itemCount: items.length,
  separatorBuilder: (context, index) => const Divider(),
  itemBuilder: (context, index) => PetCard(pet: items[index]),
)
```

## 🧪 Testing Architecture

### Test Structure
```
test/
├── unit/
│   ├── core/
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   └── pets/
│   └── helpers/
├── widget/
└── integration/
```

### Testing Patterns
```dart
// Unit Test Example
group('AuthCubit', () {
  late AuthCubit authCubit;
  late MockLoginUseCase mockLoginUseCase;
  
  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    authCubit = AuthCubit(loginUseCase: mockLoginUseCase);
  });
  
  test('should emit [AuthLoading, AuthSuccess] when login succeeds', () async {
    // arrange
    when(() => mockLoginUseCase.call(any()))
        .thenAnswer((_) async => const Right(userEntity));
    
    // act
    authCubit.login('test@email.com', 'password');
    
    // assert
    await expectLater(
      authCubit.stream,
      emitsInOrder([AuthLoading(), AuthSuccess(userEntity)]),
    );
  });
});
```

## 🔮 Scalability Considerations

### Feature Modularity
- Each feature is self-contained
- Minimal dependencies between features
- Easy to add/remove features
- Clear interfaces between modules

### Code Organization
- Consistent naming conventions
- Clear folder structure
- Separation of concerns
- Reusable components

### Performance Scaling
- Lazy loading of features
- Efficient state management
- Optimized build configurations
- Memory leak prevention

---

This architecture provides a solid foundation for the Squeak app, ensuring maintainability, testability, and scalability as the application grows.
