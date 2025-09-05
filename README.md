# 🐾 Squeak - Pet Care Management App

## Overview

Squeak is a comprehensive pet care management application built with Flutter, designed to connect pet owners with veterinary clinics and provide a complete digital solution for pet health management.

## 📱 App Features

### Core Functionality
- **Pet Profile Management**: Add, edit, and manage multiple pet profiles
- **Veterinary Clinic Integration**: Connect with and follow veterinary clinics
- **Appointment Booking**: Schedule and manage veterinary appointments
- **Medical Records**: Digital storage of pet medical history and documents
- **Vaccination Tracking**: Monitor vaccination schedules and reminders
- **QR Code Integration**: Quick pet identification and clinic linking
- **Multi-language Support**: Arabic and English localization
- **Real-time Notifications**: Firebase-powered push notifications

### User Experience
- **Material 3 Design**: Modern UI with purple gradient theme
- **Responsive Design**: Optimized for various screen sizes
- **Smooth Animations**: Enhanced user interactions with Lottie and custom animations
- **Loading States**: Comprehensive loading indicators for all API operations
- **Offline Support**: Local data caching and offline functionality

## 🏗️ Architecture

### Design Pattern
- **Clean Architecture**: Separation of concerns with domain, data, and presentation layers
- **BLoC State Management**: Reactive state management using flutter_bloc
- **Dependency Injection**: Service locator pattern with get_it
- **Repository Pattern**: Data abstraction with local and remote data sources

### Project Structure
```
lib/
├── core/                          # Core functionality and utilities
│   ├── network/                   # API and networking
│   ├── service/                   # Global services and widgets
│   ├── utils/                     # Utilities and helpers
│   └── error/                     # Error handling
├── features/                      # Feature modules
│   ├── auth/                      # Authentication
│   ├── pets/                      # Pet management
│   ├── appointments/              # Appointment booking
│   ├── layout/                    # Main app layout
│   ├── vaccination/               # Vaccination tracking
│   ├── qr/                        # QR code functionality
│   └── vetcare/                   # Veterinary care
└── generated/                     # Generated files (localization, etc.)
```

## 🛠️ Technical Stack

### Frontend
- **Framework**: Flutter 3.29.1
- **Language**: Dart 3.7.0
- **State Management**: BLoC/Cubit pattern
- **Navigation**: Flutter Navigator 2.0
- **UI Components**: Material 3 with custom components

### Backend Integration
- **API Communication**: Dio HTTP client
- **Authentication**: JWT token-based authentication
- **File Upload**: Multipart form data handling
- **Caching**: Shared preferences and SQLite

### Firebase Services
- **Cloud Firestore**: Real-time database
- **Firebase Messaging**: Push notifications
- **Firebase Analytics**: User behavior tracking

### Key Dependencies
- `flutter_bloc`: State management
- `dio`: HTTP networking
- `get_it`: Dependency injection
- `shared_preferences`: Local storage
- `image_picker`: Media handling
- `geolocator`: Location services
- `firebase_messaging`: Push notifications
- `shimmer`: Loading animations
- `lottie`: Vector animations

## 🎨 Design System

### Color Palette
```dart
// Primary Colors
primaryColor: #5B6CFF → #7A57D1 (Purple gradient)
secondaryColor: #FF7029 (Orange accent)

// UI Colors
backgroundColor: #F8F9FA
surfaceColor: #FFFFFF
errorColor: #DC3545
successColor: #28A745
```

### Typography
- **Font Family**: Google Fonts (Roboto/Inter)
- **Localization**: Supports Arabic RTL layout
- **Responsive Text**: Scales based on device size

### Components
- **VcButton**: Modern elevated buttons with loading states
- **VcTextField**: Custom input fields with validation
- **VcCard**: Consistent card components
- **VcLoadingIndicator**: Universal loading components

## 🌍 Internationalization

### Supported Languages
- **English (en)**: Default language
- **Arabic (ar)**: RTL layout support

### Implementation
- Flutter Intl plugin for localization
- ARB files for translation management
- Dynamic language switching
- RTL layout adaptation

## 🔐 Security Features

### Authentication
- JWT token-based authentication
- Automatic token refresh
- Secure token storage
- Session management

### Data Protection
- HTTPS API communication
- Input validation and sanitization
- Error handling and logging
- Secure file upload

## 📊 Performance Optimizations

### Loading & Caching
- Shimmer loading animations
- Image caching with FastCachedNetworkImage
- SQLite local database
- Efficient list rendering with pagination

### Memory Management
- Proper disposal of controllers and streams
- Optimized image loading
- Background task management
- Memory leak prevention

## 🚀 Getting Started

### Prerequisites
- Flutter 3.29.1 or higher
- Dart 3.7.0 or higher
- iOS 11.0+ / Android API 21+
- Xcode (for iOS development)
- Android Studio (for Android development)

### Installation
1. Clone the repository
```bash
git clone [repository-url]
cd SqueakFlutter
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure Firebase
- Add `google-services.json` for Android
- Add `GoogleService-Info.plist` for iOS

4. Run the app
```bash
flutter run
```

### Development Setup
- Follow the setup guide in `HowToRun.md`
- Configure your IDE with Flutter/Dart plugins
- Set up debugging and testing environment

## 📱 Device Compatibility

### Supported Devices
- **iPhone**: iOS 11.0+ (all screen sizes)
- **Android**: API 21+ (phones and tablets)
- **Screen Sizes**: Responsive design for all form factors

### Performance Targets
- **App Launch**: < 3 seconds
- **API Response**: < 2 seconds
- **Smooth Animations**: 60 FPS
- **Memory Usage**: < 100MB baseline

## 🤝 Contributing

### Development Standards
- Follow Dart/Flutter style guide
- Use BLoC pattern for state management
- Implement proper error handling
- Write comprehensive tests
- Document complex functionality

### Code Review Process
- All changes require review
- Automated testing must pass
- Follow commit message conventions
- Update documentation as needed

## 📄 Documentation

- **API Documentation**: See `docs/API.md`
- **Architecture Guide**: See `docs/ARCHITECTURE.md`
- **Setup Instructions**: See `HowToRun.md`
- **Loading Indicators**: See `LOADING_INDICATORS_GUIDE.md`

## 📞 Support

For technical support or questions:
- Email: support@squeak.app
- Documentation: [Internal Wiki]
- Issue Tracking: [Internal System]

---

**Built with ❤️ for pet lovers everywhere**
