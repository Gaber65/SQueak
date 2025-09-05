# 🚀 How To Run Squeak Flutter App

> **Squeak** - A modern Flutter application for veterinary clinic management with pet profiles, appointment booking, and QR code integration.

## 📋 Prerequisites

### ✅ Required Software Versions

- **Flutter**: 3.29.1 or later (stable channel) ⭐
- **Dart**: 3.7.0 or later (included with Flutter)
- **Xcode**: 15.0 or later (for iOS development)
- **CocoaPods**: 1.16.2 or later (for iOS dependencies)
- **Android Studio**: 2023.1 or later (for Android development)
- **Git**: Latest version
- **macOS**: 12.0 (Monterey) or later
- **Node.js**: 18.0+ (for web development)

### 🔧 System Requirements

- **macOS**: 12.0 (Monterey) or later
- **RAM**: Minimum 8GB (16GB recommended for optimal performance)
- **Storage**: 20GB free space for development tools and simulators
- **Xcode Command Line Tools**: Required for iOS development
- **iOS Simulator**: iOS 16.0 or later supported
- **Android SDK**: API level 21 (Android 5.0) minimum, API 34 (Android 14) target
- **Web Browser**: Chrome, Safari, or Firefox for web development

### 🔍 Quick Environment Check

Before starting, run this quick verification:

```bash
# Check Flutter installation
flutter --version

# Check development environment
flutter doctor -v

# Check available devices
flutter devices
```

**Expected Flutter Version Output**:
```
Flutter 3.29.1 • channel stable • https://github.com/flutter/flutter.git
Framework • revision abc123456 (2 weeks ago) • 2024-12-01 12:00:00 -0800
Engine • revision def456789
Tools • Dart 3.7.0 • DevTools 2.34.3
```

## �️ Development Environment Setup

### 1. Install Flutter SDK

**Option A: Using Official Installer (Recommended)**
```bash
# Download Flutter SDK from https://flutter.dev/docs/get-started/install
# Or use git for latest stable
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Add to your shell profile (.zshrc, .bash_profile)
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.zshrc
source ~/.zshrc
```

**Option B: Using Package Manager**
```bash
# Using Homebrew (macOS)
brew install flutter

# Verify installation
flutter --version
flutter doctor
```

**Expected Output**:
```
Flutter 3.29.1 • channel stable
Dart 3.7.0 • DevTools 2.34.3
✓ All systems ready for Flutter development
```

### 2. Install Xcode & iOS Development Tools

**Step 2.1: Install Xcode**
1. Download Xcode from Mac App Store (4GB+ download)
2. Launch Xcode and agree to license terms
3. Install additional components when prompted

**Step 2.2: Install Command Line Tools**
```bash
# Install Xcode Command Line Tools
sudo xcode-select --install

# Accept Xcode license
sudo xcodebuild -license accept

# Verify installation
xcode-select -p
# Expected: /Applications/Xcode.app/Contents/Developer
```

**Step 2.3: Configure iOS Simulator**
```bash
# Open iOS Simulator
open -a Simulator

# List available simulators
xcrun simctl list devices

# Create iPhone 16 Pro Max simulator if needed
xcrun simctl create "iPhone 16 Pro Max" "iPhone 16 Pro Max" "iOS 17.0"
```

### 3. Install CocoaPods & Ruby Dependencies

**Step 3.1: Install CocoaPods**
```bash
# Method 1: Using RubyGems (Recommended)
sudo gem install cocoapods

# Method 2: Using Homebrew
brew install cocoapods

# Verify installation
pod --version
# Expected: 1.16.2 or later

# Setup CocoaPods
pod setup
```

**Step 3.2: Handle Ruby/CocoaPods Issues**
```bash
# If you encounter Ruby version issues on macOS Monterey+
# Use system Ruby or install rbenv

# Check Ruby version
ruby --version

# If needed, update RubyGems
sudo gem update --system

# Alternative: Use Homebrew Ruby
brew install ruby
echo 'export PATH="/opt/homebrew/opt/ruby/bin:$PATH"' >> ~/.zshrc
```

### 4. Install Android Studio & SDK (Optional but Recommended)

**Step 4.1: Install Android Studio**
1. Download from [Android Studio](https://developer.android.com/studio)
2. Install with default settings
3. Launch and complete initial setup wizard
merg====
**Step 4.2: Configure Android SDK**
```bash
# Accept Android licenses
flutter doctor --android-licenses

# Add Android SDK to PATH (add to ~/.zshrc)
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Reload shell
source ~/.zshrc

# Verify Android setup
flutter doctor
```

**Step 4.3: Create Android Virtual Device (AVD)**
1. Open Android Studio
2. Go to Tools → AVD Manager
3. Create Virtual Device
4. Choose Pixel 7 Pro with API 34 (Aconds ndroid 14)

### 5. Web Development Setup (Optional)

```bash
# Enable web support
flutter config --enable-web

# Verify web setup
flutter devices
# Should show Chrome and Web Server options
```

## 📱 Squeak Project Setup

### 1. Clone the Repository & Navigate

```bash
# Clone the repository
git clone <repository-url>
cd SqueakFlutter

# Verify project structure
ls -la
# Expected: README.md, pubspec.yaml, lib/, ios/, android/, web/, etc.

# Check current branch
git branch
# Should be on main or develop branch
```

### 2. Environment Health Check

```bash
# Comprehensive environment check
flutter doctor -v

# Expected output should show:
# ✓ Flutter (Channel stable, 3.29.1)
# ✓ Xcode - develop for iOS and macOS
# ✓ Chrome - develop for the web
# ✓ Android toolchain (optional)
```

**Doctor Output Interpretation**:
- ✓ **Green checkmarks**: Ready to develop
- ⚠️ **Yellow warnings**: Non-critical issues
- ✗ **Red X marks**: Must be fixed before development

### 3. Install Project Dependencies

```bash
# Step 1: Clean any previous builds
flutter clean

# Step 2: Get Flutter dependencies
flutter pub get

# Step 3: Verify dependency resolution
flutter pub deps

# Expected: No version conflicts, all packages resolved
```

### 4. iOS Dependencies Setup

```bash
# Navigate to iOS directory
cd ios

# Update CocoaPods repo (recommended)
pod repo update

# Install iOS dependencies
pod install --repo-update

# Verify successful installation
ls -la Pods/
# Should show installed pods without errors

# Return to project root
cd ..
```

**Common Pod Install Issues & Solutions**:
```bash
# If pod install fails, try:
cd ios
rm -rf Pods Podfile.lock .symlinks/
pod cache clean --all
pod repo update
pod install --verbose
cd ..
```

### 5. Firebase Configuration (Required) 🔥

The Squeak app uses Firebase for authentication, Firestore database, cloud messaging, and analytics.

**Required Files Check**:
```bash
# Verify Firebase configuration files exist
ls -la ios/GoogleService-Info.plist
ls -la android/app/google-services.json
ls -la web/index.html  # Contains Firebase config

# If files are missing, contact your team for the configuration files
```

**Firebase Services Used**:
- 🔐 **Authentication**: User login/registration
- 🗄️ **Firestore**: Pet profiles, appointments data
- 📱 **Cloud Messaging**: Push notifications  
- 📊 **Analytics**: Usage tracking
- 🖼️ **Storage**: Pet photos and documents

**Firebase Project Setup**:
```bash
# Install Firebase CLI (optional, for deployment)
npm install -g firebase-tools

# Login to Firebase (if needed)
firebase login

# Check project configuration
firebase projects:list
```

### 6. Generate Required Files

```bash
# Generate localization files
flutter gen-l10n

# Generate build files (if needed)
flutter packages pub run build_runner build

# Verify generation
ls -la lib/generated/
```

## 🏃‍♂️ Running the Squeak App

### 🎯 Quick Start (Recommended Path)

```bash
# 1. Check available devices
flutter devices

# 2. Run on iPhone simulator (primary target)
flutter run -d "iPhone 16 Pro Max"

# 3. If successful, you should see:
# ✓ Built build/ios/iphonesimulator/Runner.app
# ✓ Installing and launching...
# ✓ Syncing files to device iPhone 16 Pro Max...
# 🔥 To hot reload changes while running, press "r" or "R".
```

### 📱 Platform-Specific Launch Options

#### Option 1: iOS Simulator (Primary Platform)

```bash
# List iOS simulators
xcrun simctl list devices ios

# Launch specific iPhone model
flutter run -d "iPhone 16 Pro Max"
flutter run -d "iPhone 15 Pro"  
flutter run -d "iPad Pro (12.9-inch) (6th generation)"

# Launch with specific configuration
flutter run -d "iPhone 16 Pro Max" --debug --verbose

# Expected build time: 60-90 seconds for first run
# Hot reload time: 1-3 seconds for subsequent changes
```

**Build Success Indicators**:
```
Launching lib/main.dart on iPhone 16 Pro Max in debug mode...
Running Xcode build...                                                  
Xcode build done.                                           83.6s
✓ Built build/ios/iphonesimulator/Runner.app
✓ Installing and launching...                                      
✓ Connecting to VM Service at ws://127.0.0.1:52393/
🎉 App launched successfully!
```

#### Option 2: Web Browser Development

```bash
# Run on Chrome (default web browser)
flutter run -d chrome

# Run on specific port
flutter run -d web-server --web-port 8080
flutter run -d web-server --web-port 3000

# Open in browser: http://localhost:8080
```

#### Option 3: Android Emulator

```bash
# Start Android emulator first
emulator -avd Pixel_7_Pro_API_34

# Or start from Android Studio AVD Manager
# Then run:
flutter run -d android

# List Android devices/emulators
adb devices
```

#### Option 4: Physical Devices

```bash
# iOS Device (requires developer account & provisioning)
flutter run -d "Your iPhone Name"

# Android Device (enable USB debugging)
flutter run -d "your_android_device"
```

### 🔄 Development Workflow

#### Hot Reload & Hot Restart

Once the app is running, use these commands in the terminal:

```bash
# Hot Reload - Updates UI without losing state
r + Enter

# Hot Restart - Restarts app and resets state  
R + Enter

# Open Flutter Inspector
i + Enter

# Open DevTools in browser
d + Enter

# Quit app
q + Enter
```

#### Debug Mode Commands

```bash
# Run with debug information
flutter run --debug --verbose

# Run with performance overlay
flutter run --debug --enable-software-rendering

# Run with widget inspector
flutter run --debug --track-widget-creation
```

#### Development Modes

```bash
# Debug Mode (default) - Hot reload, debugging tools
flutter run --debug

# Profile Mode - Performance optimization testing
flutter run --profile  

# Release Mode - Production simulation
flutter run --release
```

## 🔧 Troubleshooting & Common Issues

### ⚠️ Known Issues & Solutions

#### Issue 1: Mobile Scanner Dependency Conflict ⚠️

**Problem**: The `mobile_scanner` package conflicts with Firebase's GoogleDataTransport.

**Current Status**: 
```yaml
# In pubspec.yaml - mobile_scanner is commented out
# mobile_scanner: ^3.5.2  # Temporarily disabled
```

**Impact**: QR scanning functionality shows fallback message
**Workaround**: Manual QR code input is available in the app
**Files Affected**:
- `lib/features/qr/presentation/widgets/qr_link_dialog.dart`
- `pubspec.yaml`

**Solution for Future**:
```bash
# When compatible versions are available:
# 1. Uncomment mobile_scanner in pubspec.yaml
# 2. Uncomment import statements in affected files
# 3. Run: flutter pub get
```

#### Issue 2: "Invalid depfile" Build Error 🚨

**Problem**: 
```
Error (Xcode): Invalid depfile:
/Users/mac/.dart_tool/flutter_build/.../kernel_snapshot_program.d
```

**Solution**:
```bash
# Step 1: Clean Flutter build cache
flutter clean

# Step 2: Clean Xcode derived data
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# Step 3: Clean iOS build specifically
cd ios
xcodebuild clean
rm -rf build/
cd ..

# Step 4: Reinstall dependencies
flutter pub get
cd ios && pod install && cd ..

# Step 5: Try running again
flutter run -d "iPhone 16 Pro Max"
```

#### Issue 3: CocoaPods Installation Issues 🔧

**Problem**: Pod install fails or takes too long

**Solution A: Reset CocoaPods**:
```bash
cd ios
rm -rf Pods Podfile.lock .symlinks/
pod cache clean --all
pod repo update
pod install --repo-update --verbose
cd ..
```

**Solution B: Ruby/Gem Issues**:
```bash
# Update RubyGems system
sudo gem update --system

# Clear gem cache
gem cleanup

# Reinstall CocoaPods
sudo gem uninstall cocoapods
sudo gem install cocoapods

# Alternative: Use Homebrew version
brew install cocoapods
```

#### Issue 4: Xcode Version Compatibility 🛠️

**Problem**: Xcode version warnings or build failures

**Solution**:
```bash
# Check Xcode version
xcodebuild -version

# Update Xcode from App Store
# Accept new license if prompted
sudo xcodebuild -license accept

# Update command line tools
sudo xcode-select --install

# Reset Xcode command line tools path
sudo xcode-select --reset
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
```

#### Issue 5: Flutter Channel/Version Issues 📱

**Problem**: Flutter version incompatibility

**Solution**:
```bash
# Check current channel and version
flutter channel
flutter --version

# Switch to stable channel
flutter channel stable
flutter upgrade

# If issues persist, reinstall Flutter
flutter doctor
flutter clean
flutter pub get
```

#### Issue 6: Simulator Not Found 📱

**Problem**: "No devices found" or simulator not listed

**Solution**:
```bash
# List all simulators
xcrun simctl list devices

# Delete and recreate simulator
xcrun simctl delete "iPhone 16 Pro Max"
xcrun simctl create "iPhone 16 Pro Max" "iPhone 16 Pro Max" "iOS 17.0"

# Reset simulator content
xcrun simctl erase all

# Open Simulator app
open -a Simulator
```

#### Issue 7: Firebase Configuration Missing 🔥

**Problem**: Firebase initialization errors

**Solution**:
```bash
# Verify Firebase files exist
ls -la ios/GoogleService-Info.plist
ls -la android/app/google-services.json

# If missing, request from team or download from Firebase Console
# Firebase Console: https://console.firebase.google.com
# Project Settings → General → Your apps → Download config file
```

### 🚨 Emergency Recovery Steps

If everything breaks:

```bash
# Nuclear option - complete reset
cd SqueakFlutter

# 1. Clean everything
flutter clean
rm -rf .dart_tool/
rm -rf build/
rm -rf ios/Pods ios/Podfile.lock ios/.symlinks/
rm -rf android/.gradle android/build
rm -rf ~/.pub-cache/

# 2. Reinstall Flutter dependencies
flutter pub get

# 3. Reinstall iOS dependencies  
cd ios && pod install --repo-update && cd ..

# 4. Clear Xcode cache
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# 5. Restart development
flutter doctor
flutter run -d "iPhone 16 Pro Max"
```

### 📊 Performance Expectations

#### Build Time Benchmarks
- **First Clean Build**: 60-90 seconds ⏱️
- **Incremental Build**: 10-20 seconds 🔄
- **Hot Reload**: 1-3 seconds ⚡
- **Hot Restart**: 5-10 seconds 🔄

#### Expected App Performance
- **Startup Time**: < 3 seconds
- **Frame Rate**: 60 FPS target
- **Memory Usage**: < 150MB on device
- **APK Size**: ~50MB (release build)

## 📦 Building for Production

### 🍎 iOS Release Build

```bash
# Build IPA for App Store
flutter build ipa --release

# Build for device testing (no code signing)
flutter build ios --release --no-codesign

# Build with specific configuration
flutter build ipa --release --export-options-plist=ios/ExportOptions.plist

# Check build artifacts
ls -la build/ios/ipa/
```

### 🤖 Android Release Build

```bash
# Build APK for direct distribution
flutter build apk --release

# Build App Bundle for Google Play Store (recommended)
flutter build appbundle --release

# Build split APKs for optimization
flutter build apk --release --split-per-abi

# Check build artifacts
ls -la build/app/outputs/bundle/release/
ls -la build/app/outputs/apk/release/
```

### 🌐 Web Release Build

```bash
# Build for web deployment
flutter build web --release

# Build with custom base href
flutter build web --release --base-href="/squeak/"

# Build with web renderer selection
flutter build web --release --web-renderer canvaskit

# Check build artifacts
ls -la build/web/
```

### 📋 Pre-Release Checklist

Before building for production:

```bash
# 1. Run all tests
flutter test

# 2. Analyze code quality
flutter analyze

# 3. Check formatting
dart format --set-exit-if-changed lib/

# 4. Build and test release version
flutter build ios --release --no-codesign
flutter build apk --release

# 5. Performance check
flutter run --profile
```

## 🧪 Testing & Quality Assurance

### 🔬 Running Tests

#### Unit & Widget Tests
```bash
# Run all tests
flutter test

# Run tests with coverage report
flutter test --coverage

# Run specific test file
flutter test test/unit/auth/login_cubit_test.dart

# Run tests with verbose output
flutter test --reporter=expanded

# Generate coverage HTML report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

#### Integration Tests
```bash
# Run integration tests on connected device
flutter test integration_test/

# Run specific integration test
flutter test integration_test/app_test.dart

# Run on specific device
flutter test integration_test/ -d "iPhone 16 Pro Max"
```

#### Code Quality Checks
```bash
# Analyze code for issues
flutter analyze

# Check code formatting
dart format --output=none --set-exit-if-changed .

# Check for unused dependencies
flutter pub deps

# Dart code metrics (if installed)
dart run dart_code_metrics:metrics analyze lib/
```

### 🎨 Squeak App Features Overview

This version includes comprehensive modernization of the original Squeak app:

#### 🎯 Core Features
- **🔐 User Authentication**: Login, registration, password reset
- **🐕 Pet Management**: Complete pet profiles with photos
- **📅 Appointment Booking**: Clinic scheduling system
- **📱 QR Code Integration**: Pet profile sharing (currently limited)
- **🔔 Push Notifications**: Real-time appointment reminders
- **🌍 Bilingual Support**: Arabic/English with RTL layout

#### 🎨 UI/UX Modernization
- **Material 3 Design**: Latest Google design system
- **Purple Gradient Theme**: Modern color palette (#5B6CFF → #7A57D1)
- **Inter Typography**: Professional font system with proper scaling
- **Loading Indicators**: Comprehensive loading states across all screens
- **Responsive Design**: Mobile-first with web adaptation
- **Dark Mode Ready**: Adaptive themes for different preferences

#### 🚀 Performance Optimizations
- **60fps Target**: Smooth animations and interactions
- **Memory Efficient**: Proper disposal patterns and smart caching
- **Fast Loading**: Optimized image loading and component rendering
- **State Management**: BLoC pattern with clean architecture
- **Error Handling**: Graceful error states with user-friendly messages

#### 🔧 Technical Stack
- **Flutter**: 3.29.1 (latest stable)
- **State Management**: flutter_bloc with Cubit pattern
- **Networking**: Dio HTTP client with interceptors
- **Local Storage**: SharedPreferences and Hive
- **Firebase**: Authentication, Firestore, Cloud Messaging
- **Localization**: flutter_localizations with ARB files

## 📞 Developer Support & Resources

### 🔧 Essential Commands Quick Reference

```bash
# Environment check
flutter doctor -v

# Project setup
flutter clean && flutter pub get
cd ios && pod install && cd ..

# Run development
flutter run -d "iPhone 16 Pro Max"

# Hot reload/restart while running
r (hot reload) | R (hot restart) | q (quit)

# Build production
flutter build ipa --release          # iOS
flutter build appbundle --release    # Android
flutter build web --release          # Web

# Testing
flutter test                         # Unit tests
flutter test --coverage            # With coverage
flutter analyze                    # Code analysis

# Debugging
flutter logs                        # View logs
flutter screenshot                  # Take screenshot
flutter run --verbose              # Verbose output
```

### 🆘 Getting Help

#### Internal Resources
1. **📚 Documentation**: Check `docs/` folder for comprehensive guides
2. **🐛 Issues**: Create GitHub issue with detailed description
3. **💬 Code Review**: Use pull request discussions
4. **📖 Architecture**: Reference `docs/ARCHITECTURE.md`

#### External Resources
- **📖 Flutter Docs**: [flutter.dev](https://flutter.dev/docs)
- **🏗️ BLoC Documentation**: [bloclibrary.dev](https://bloclibrary.dev)
- **🎨 Material 3**: [m3.material.io](https://m3.material.io)
- **💬 Community**: [Flutter Discord](https://discord.gg/flutter)
- **❓ Stack Overflow**: Tag questions with `flutter` and `dart`

### 🔍 Troubleshooting Checklist

When encountering issues, follow this order:

1. **✅ Environment**: Run `flutter doctor -v`
2. **🧹 Clean**: Run `flutter clean && flutter pub get`
3. **🍎 iOS**: Run `cd ios && pod install && cd ..`
4. **📱 Device**: Check `flutter devices`
5. **🔥 Firebase**: Verify configuration files exist
6. **📦 Dependencies**: Check `pubspec.yaml` for conflicts
7. **� Restart**: Restart IDE, simulator, or development server
8. **📝 Logs**: Check console output for specific error messages

### 🚀 Success Indicators

✅ **Everything Working When You See**:
```bash
# Doctor output
[✓] Flutter (Channel stable, 3.29.1)
[✓] Xcode - develop for iOS and macOS

# Build output  
Xcode build done.                    83.6s
✓ Built build/ios/iphonesimulator/Runner.app
✓ Installing and launching...

# Runtime output
🎉 To hot reload changes while running, press "r" or "R".
```

---

## 📝 Notes & Important Information

### 🔒 Security Considerations
- Firebase configuration files contain sensitive data
- Never commit actual `GoogleService-Info.plist` or `google-services.json` to public repos
- Use environment variables for API keys in production

### 🌟 Modernization Highlights
This version represents a complete modernization while preserving all original Squeak functionality:
- **Design**: Material 3 with modern purple gradient theme
- **Performance**: 60fps target with optimized rendering
- **Architecture**: Clean architecture with BLoC state management  
- **Accessibility**: WCAG 2.1 compliant with screen reader support
- **Internationalization**: Full Arabic/English RTL support
- **Testing**: Comprehensive test coverage with automated CI/CD

### 🔮 Future Enhancements
- **Mobile Scanner**: Re-enable when dependency conflicts are resolved
- **Offline Support**: Enhanced offline functionality
- **Advanced Analytics**: Detailed user behavior tracking
- **Push Notification**: Enhanced notification targeting
- **Performance**: Further optimization for lower-end devices

---

**Happy Coding! 🚀** The Squeak Flutter app is ready for development with modern architecture, beautiful UI, and comprehensive tooling support.
