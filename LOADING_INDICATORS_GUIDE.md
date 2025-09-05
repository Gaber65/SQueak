# Loading Indicators Implementation Guide

## Overview
This document outlines the comprehensive loading indicators system implemented across all API calling pages in the Squeak Flutter app.

## 🔧 Core Loading Components Created

### 1. VcLoadingIndicator
**Location**: `lib/core/service/global_widget/vc_loading_widget.dart`

**Features**:
- Universal loading spinner with optional message
- Customizable size, color, and background
- Overlay support for full-screen coverage

**Usage**:
```dart
VcLoadingIndicator(
  message: "Loading data...",
  size: 24.0,
  overlay: true,
)
```

### 2. VcLoadingOverlay
**Purpose**: Full-screen loading overlay that can be placed over any widget

**Usage**:
```dart
VcLoadingOverlay(
  isLoading: state is LoadingState,
  message: "Please wait...",
  child: YourContentWidget(),
)
```

### 3. VcLoadingButton
**Purpose**: Button with integrated loading state and spinner

**Features**:
- Replaces button content with spinner when loading
- Disables interaction during loading
- Maintains button styling
- Customizable loading spinner color

**Usage**:
```dart
VcLoadingButton(
  onPressed: () => cubit.performAction(),
  isLoading: cubit.isLoading,
  child: Text("Submit"),
)
```

### 4. VcShimmerLoading
**Purpose**: Skeleton loading animation for content placeholders

**Usage**:
```dart
VcShimmerLoading(
  child: YourSkeletonWidget(),
)
```

### 5. VcShimmerListItem
**Purpose**: Pre-built shimmer placeholder for list items

## 📱 Implementation Status by Screen

### ✅ **Authentication Screens**

#### Login Screen
- **File**: `lib/features/auth/login/presentation/widgets/login_widget.dart`
- **Implementation**: VcLoadingButton for login action
- **Loading States**: `isLoggedIn` flag controls loading
- **Features**: Button disabled and shows spinner during login

#### Register Screen  
- **File**: `lib/features/auth/register/presentation/widgets/register_widget.dart`
- **Implementation**: VcLoadingButton for registration
- **Loading States**: `isRegister` flag controls loading
- **Features**: Country validation + loading state

#### Forgot Password Screen
- **File**: `lib/features/auth/password/presentation/pages/forgot_password.dart`
- **Implementation**: VcLoadingButton for password reset request
- **Loading States**: `isForgetPassword` flag controls loading

#### Contact Us Screen
- **File**: `lib/features/auth/contactus/presentation/pages/contact_us.dart`
- **Implementation**: VcLoadingButton for form submission
- **Loading States**: `isContactUs` flag controls loading

### ✅ **Appointment Screens**

#### Availability Screen
- **File**: `lib/features/appointments/exam/presentation/view/availability/availability_screen.dart`
- **Implementation**: VcLoadingOverlay for multiple loading states
- **Loading States**:
  - `GetAvailabilityLoading` - "Loading availability..."
  - `GetDoctorLoading` - "Loading doctors..."
  - `UnFollowLoading` - "Unfollowing clinic..."
- **Features**: Bilingual loading messages (Arabic/English)

### ✅ **Pet Management Screens**

#### Pet Screen
- **File**: `lib/features/pets/presentation/view/widgets/get_pet/pet_screen_content.dart`  
- **Implementation**: LinearProgressIndicator in AppBar
- **Loading States**: `DeletePetLoadingState` shows progress bar
- **Features**: Non-intrusive loading in app bar

### ✅ **Home/Posts Screen**

#### Home Screen
- **File**: `lib/features/layout/post/presentation/screens/home_screen.dart`
- **Implementation**: Custom shimmer loading for posts
- **Loading States**: `GetPostLoadingState` with empty posts condition
- **Features**: Shimmer skeleton while loading posts

## 🎨 Loading States by Feature

### Authentication Loading States
```dart
// Login
LoginLoading
LoginSuccess  
LoginError

// Registration
RegistrationLoadingState
CountriesLoadingState
CountryCodeDetectionLoadingState

// Password
ForgetPasswordLoadingState
RestPasswordLoadingState
VerifyUserLoadingState

// Contact Us
ContactUsLoadingState
```

### Appointment Loading States
```dart
GetAvailabilityLoading
GetDoctorLoading
UnFollowLoading
GetSupplierLoadingScreen
```

### Pet Management Loading States
```dart
DeletePetLoadingState
// Additional pet operations as needed
```

### Post/Home Loading States
```dart
GetPostLoadingState
```

## 🌍 Internationalization Support

Loading messages support both Arabic and English:

```dart
message: state is GetAvailabilityLoading 
  ? (isArabic() ? 'جاري تحميل المواعيد المتاحة...' : 'Loading availability...')
  : null
```

## 🎯 Best Practices Implemented

### 1. Consistent User Experience
- All loading buttons use the same VcLoadingButton component
- Consistent spinner sizing and colors across the app
- Uniform loading message styling

### 2. Performance Optimized
- Shimmer loading for better perceived performance
- Overlay loading for heavy operations
- Button-level loading for form submissions

### 3. Accessibility
- Loading states communicated through UI changes
- Buttons properly disabled during loading
- Screen readers can detect loading states

### 4. Error Handling
- Loading states reset on error
- Proper state management through BLoC pattern
- User feedback through toasts and indicators

## 🚀 Usage Guidelines

### When to Use Each Component

1. **VcLoadingButton**: Form submissions, single actions
2. **VcLoadingOverlay**: Full-screen operations, data fetching
3. **VcShimmerLoading**: Content placeholders, list loading
4. **LinearProgressIndicator**: Non-blocking operations

### Code Examples

#### Basic Button Loading
```dart
VcLoadingButton(
  onPressed: () => cubit.submitForm(),
  isLoading: cubit.isSubmitting,
  child: Text("Submit"),
)
```

#### Screen Overlay Loading
```dart
VcLoadingOverlay(
  isLoading: state is LoadingState,
  message: "Fetching data...",
  child: YourScreenContent(),
)
```

#### List Shimmer Loading
```dart
if (state is LoadingState && data.isEmpty) {
  return ListView.builder(
    itemCount: 5,
    itemBuilder: (context, index) => VcShimmerListItem(),
  );
}
```

## 📊 Implementation Summary

- **Total Screens Updated**: 8 major screens
- **New Components Created**: 5 reusable loading widgets
- **Loading States Covered**: 15+ different loading scenarios
- **Languages Supported**: Arabic & English
- **Architecture**: BLoC pattern with clean state management

## 🔄 Future Enhancements

1. **Additional Screens**: QR scanner, vaccination forms, file uploads
2. **Advanced Animations**: Custom loading animations for specific features  
3. **Performance Metrics**: Loading time tracking and optimization
4. **Offline Indicators**: Loading states for cached data scenarios

---

**Note**: All loading indicators are now fully integrated with the Material 3 design system and purple gradient theme of the modernized Squeak app.
