# 🚀 Deployment & DevOps Documentation

## Overview

This document outlines the complete deployment strategy, CI/CD pipelines, and DevOps practices for the Squeak Flutter application across iOS, Android, and Web platforms.

## 🏗️ Infrastructure Overview

### Platform Targets
- **iOS**: App Store (Production), TestFlight (Staging)
- **Android**: Google Play Store (Production), Internal Testing (Staging)
- **Web**: Firebase Hosting (Production), Preview Channels (Staging)

### Environment Structure
```
Production Environment
├── iOS App Store
├── Google Play Store
├── Web (squeak.app)
└── Backend APIs (Production)

Staging Environment
├── TestFlight (iOS)
├── Google Play Internal Testing
├── Web Preview (staging.squeak.app)
└── Backend APIs (Staging)

Development Environment
├── Local Development
├── Firebase Emulators
├── Local Backend
└── Device Testing
```

## 📱 Mobile App Deployment

### iOS Deployment

#### Prerequisites
```bash
# Install required tools
brew install cocoapods
sudo gem install fastlane

# Xcode Command Line Tools
xcode-select --install

# Certificates and Provisioning Profiles
# - Apple Developer Program membership
# - Distribution Certificate
# - App Store Provisioning Profile
```

#### iOS Build Configuration
```yaml
# ios/Flutter/Release.xcconfig
#include "Generated.xcconfig"

# App Store specific configurations
FLUTTER_BUILD_MODE=release
FLUTTER_TARGET=lib/main.dart

# Code signing
CODE_SIGN_IDENTITY=iPhone Distribution
PROVISIONING_PROFILE_SPECIFIER=Squeak App Store Profile
DEVELOPMENT_TEAM=YOUR_TEAM_ID
```

#### Simulator/Debug Notes
- Hot reload on iOS simulators requires local network/Bonjour permissions configured in `Info.plist`. This project includes the required keys so `flutter run` supports hot reload out of the box.
- Ensure the iOS simulator has network access and the device is discoverable for `flutter run -d '<simulator name>'`.

### macOS (Debug)
- If running the macOS app locally, CocoaPods Firebase requires macOS 10.15 or newer. The Podfile has been updated to `platform :osx, '10.15'`.
- After changing pods, run:
  - `flutter clean`
  - `flutter pub get`
  - `cd macos && pod install && cd ..`

### Assets
- All static content must be declared in `pubspec.yaml` under `flutter/assets`.
- Pet tips are bundled at `assets/content/pet_tips.json` and used by the Home tip banner.

#### Fastlane iOS Setup
```ruby
# ios/fastlane/Fastfile
default_platform(:ios)

platform :ios do
  before_all do
    setup_circle_ci if ENV['CI']
  end

  desc "Build and upload to TestFlight"
  lane :beta do
    # Increment build number
    increment_build_number(xcodeproj: "Runner.xcodeproj")
    
    # Build archive
    build_app(
      scheme: "Runner",
      configuration: "Release",
      export_method: "app-store",
      export_options: {
        provisioningProfiles: {
          "com.squeak.app" => "Squeak App Store Profile"
        }
      }
    )
    
    # Upload to TestFlight
    upload_to_testflight(
      skip_waiting_for_build_processing: true,
      changelog: "Latest changes from development"
    )
    
    # Notify team
    slack(
      message: "New iOS build uploaded to TestFlight! 🚀",
      channel: "#deployments"
    )
  end

  desc "Deploy to App Store"
  lane :release do
    # Increment version
    increment_version_number(xcodeproj: "Runner.xcodeproj")
    increment_build_number(xcodeproj: "Runner.xcodeproj")
    
    # Build and upload
    build_app(
      scheme: "Runner",
      configuration: "Release",
      export_method: "app-store"
    )
    
    # Upload to App Store Connect
    upload_to_app_store(
      force: true,
      reject_if_possible: true,
      skip_metadata: false,
      skip_screenshots: false,
      submit_for_review: false
    )
    
    # Create GitHub release
    github_release = set_github_release(
      repository_name: "yourusername/squeak-flutter",
      api_token: ENV["GITHUB_TOKEN"],
      name: "iOS v#{get_version_number}",
      tag_name: "ios-v#{get_version_number}",
      description: "iOS App Store release"
    )
    
    # Notify team
    slack(
      message: "iOS app deployed to App Store! 📱",
      channel: "#releases"
    )
  end

  error do |lane, exception|
    slack(
      message: "iOS deployment failed: #{exception.message}",
      channel: "#deployments",
      success: false
    )
  end
end
```

#### iOS App Store Metadata
```
# ios/fastlane/metadata/en-US/
├── description.txt
├── keywords.txt
├── marketing_url.txt
├── name.txt
├── privacy_url.txt
├── promotional_text.txt
├── release_notes.txt
├── subtitle.txt
└── support_url.txt

# ios/fastlane/screenshots/en-US/
├── iPhone-6.7-Display/
├── iPhone-6.5-Display/
├── iPhone-5.5-Display/
├── iPad-Pro-12.9-Display/
└── iPad-Pro-11-Display/
```

### Android Deployment

#### Prerequisites
```bash
# Install Android SDK and tools via Android Studio
# Or use command line tools

# Install fastlane
sudo gem install fastlane

# Google Play Console setup
# - Google Play Developer Account
# - Service Account JSON key
# - App signing key
```

#### Android Build Configuration
```gradle
// android/app/build.gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        applicationId "com.squeak.app"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }
    
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
    
    flavorDimensions "default"
    productFlavors {
        production {
            dimension "default"
            applicationIdSuffix ""
            manifestPlaceholders = [appName: "Squeak"]
        }
        staging {
            dimension "default"
            applicationIdSuffix ".staging"
            manifestPlaceholders = [appName: "Squeak Staging"]
        }
    }
}
```

#### Fastlane Android Setup
```ruby
# android/fastlane/Fastfile
default_platform(:android)

platform :android do
  desc "Deploy to Google Play Internal Testing"
  lane :internal do
    # Build APK/AAB
    gradle(
      task: "clean bundleProductionRelease",
      project_dir: "android/"
    )
    
    # Upload to Internal Testing
    upload_to_play_store(
      track: 'internal',
      aab: '../build/app/outputs/bundle/productionRelease/app-production-release.aab',
      skip_upload_metadata: true,
      skip_upload_images: true,
      skip_upload_screenshots: true
    )
    
    # Notify team
    slack(
      message: "New Android build uploaded to Internal Testing! 🤖",
      channel: "#deployments"
    )
  end

  desc "Deploy to Google Play Store"
  lane :production do
    # Build production bundle
    gradle(
      task: "clean bundleProductionRelease",
      project_dir: "android/"
    )
    
    # Upload to Production
    upload_to_play_store(
      track: 'production',
      aab: '../build/app/outputs/bundle/productionRelease/app-production-release.aab',
      release_status: 'draft', # Change to 'completed' for immediate release
    )
    
    # Create GitHub release
    github_release = set_github_release(
      repository_name: "yourusername/squeak-flutter",
      api_token: ENV["GITHUB_TOKEN"],
      name: "Android v#{get_version_name}",
      tag_name: "android-v#{get_version_name}",
      description: "Android Play Store release"
    )
    
    # Notify team
    slack(
      message: "Android app deployed to Play Store! 📱",
      channel: "#releases"
    )
  end

  desc "Deploy to Firebase App Distribution"
  lane :firebase do
    # Build debug APK for testing
    gradle(
      task: "assembleProductionDebug",
      project_dir: "android/"
    )
    
    # Upload to Firebase App Distribution
    firebase_app_distribution(
      app: ENV["FIREBASE_APP_ID_ANDROID"],
      apk_path: "../build/app/outputs/apk/production/debug/app-production-debug.apk",
      groups: "qa-team, beta-testers",
      release_notes: "Latest development build"
    )
  end

  error do |lane, exception|
    slack(
      message: "Android deployment failed: #{exception.message}",
      channel: "#deployments",
      success: false
    )
  end
end
```

## 🌐 Web Deployment

### Firebase Hosting Setup
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase in project
firebase init hosting
```

#### Firebase Configuration
```json
{
  "hosting": [
    {
      "target": "production",
      "public": "build/web",
      "ignore": [
        "firebase.json",
        "**/.*",
        "**/node_modules/**"
      ],
      "rewrites": [
        {
          "source": "**",
          "destination": "/index.html"
        }
      ],
      "headers": [
        {
          "source": "**/*.@(eot|otf|ttf|ttc|woff|font.css)",
          "headers": [
            {
              "key": "Access-Control-Allow-Origin",
              "value": "*"
            }
          ]
        },
        {
          "source": "**/*.@(js|css)",
          "headers": [
            {
              "key": "Cache-Control",
              "value": "max-age=604800"
            }
          ]
        }
      ]
    },
    {
      "target": "staging",
      "public": "build/web",
      "ignore": [
        "firebase.json",
        "**/.*",
        "**/node_modules/**"
      ]
    }
  ]
}
```

#### Web Build Script
```bash
#!/bin/bash
# scripts/build_web.sh

set -e

echo "🌐 Building Flutter Web App..."

# Clean previous builds
flutter clean
flutter pub get

# Build for web with optimizations
flutter build web \
  --web-renderer canvaskit \
  --release \
  --dart-define=FLUTTER_WEB_CANVASKIT_URL=https://unpkg.com/canvaskit-wasm@0.35.0/bin/ \
  --base-href "/"

echo "✅ Web build completed!"

# Optimize build
echo "🔧 Optimizing build..."

# Compress assets
find build/web -name "*.js" -exec gzip -k {} \;
find build/web -name "*.css" -exec gzip -k {} \;
find build/web -name "*.html" -exec gzip -k {} \;

echo "✅ Build optimization completed!"
```

#### Web Deployment Pipeline
```yaml
# .github/workflows/deploy-web.yml
name: Deploy Web

on:
  push:
    branches: [ main ]
    paths: [ 'lib/**', 'web/**', 'pubspec.yaml' ]

jobs:
  deploy-web:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.3'
          channel: 'stable'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Run tests
        run: flutter test
      
      - name: Build web
        run: |
          flutter build web --release \
            --web-renderer canvaskit \
            --base-href "/"
      
      - name: Deploy to Firebase
        uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: '${{ secrets.GITHUB_TOKEN }}'
          firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT }}'
          projectId: squeak-flutter
          channelId: live
```

## 🔄 CI/CD Pipelines

### GitHub Actions Workflow
```yaml
# .github/workflows/ci-cd.yml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

env:
  FLUTTER_VERSION: '3.24.3'

jobs:
  analyze:
    name: Code Analysis
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          channel: 'stable'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Verify formatting
        run: dart format --output=none --set-exit-if-changed .
      
      - name: Analyze project source
        run: flutter analyze
      
      - name: Run tests
        run: flutter test --coverage
      
      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3
        with:
          file: coverage/lcov.info

  build-ios:
    name: Build iOS
    runs-on: macos-latest
    needs: analyze
    if: github.ref == 'refs/heads/main'
    
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          channel: 'stable'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Setup iOS dependencies
        run: |
          cd ios
          pod install
      
      - name: Build iOS
        run: |
          flutter build ios --release --no-codesign
      
      - name: Upload iOS artifact
        uses: actions/upload-artifact@v3
        with:
          name: ios-build
          path: build/ios/

  build-android:
    name: Build Android
    runs-on: ubuntu-latest
    needs: analyze
    if: github.ref == 'refs/heads/main'
    
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      
      - name: Setup Java
        uses: actions/setup-java@v3
        with:
          distribution: 'temurin'
          java-version: '17'
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          channel: 'stable'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Setup Android signing
        run: |
          echo "${{ secrets.ANDROID_KEYSTORE }}" | base64 -d > android/app/keystore.jks
          echo "storePassword=${{ secrets.KEYSTORE_PASSWORD }}" >> android/key.properties
          echo "keyPassword=${{ secrets.KEY_PASSWORD }}" >> android/key.properties
          echo "keyAlias=${{ secrets.KEY_ALIAS }}" >> android/key.properties
          echo "storeFile=keystore.jks" >> android/key.properties
      
      - name: Build Android APK
        run: flutter build apk --release
      
      - name: Build Android AAB
        run: flutter build appbundle --release
      
      - name: Upload Android artifacts
        uses: actions/upload-artifact@v3
        with:
          name: android-build
          path: |
            build/app/outputs/apk/release/
            build/app/outputs/bundle/release/

  deploy-staging:
    name: Deploy to Staging
    runs-on: ubuntu-latest
    needs: [build-ios, build-android]
    if: github.ref == 'refs/heads/develop'
    
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      
      - name: Deploy iOS to TestFlight
        run: |
          # iOS TestFlight deployment
          echo "Deploying iOS to TestFlight..."
      
      - name: Deploy Android to Internal Testing
        run: |
          # Android Internal Testing deployment
          echo "Deploying Android to Internal Testing..."
      
      - name: Deploy Web to Staging
        run: |
          # Web staging deployment
          echo "Deploying Web to staging..."

  deploy-production:
    name: Deploy to Production
    runs-on: ubuntu-latest
    needs: [build-ios, build-android]
    if: github.ref == 'refs/heads/main' && contains(github.event.head_commit.message, '[release]')
    
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      
      - name: Deploy iOS to App Store
        env:
          MATCH_PASSWORD: ${{ secrets.MATCH_PASSWORD }}
          FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD: ${{ secrets.FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD }}
        run: |
          cd ios
          fastlane release
      
      - name: Deploy Android to Play Store
        env:
          SUPPLY_JSON_KEY_DATA: ${{ secrets.SUPPLY_JSON_KEY_DATA }}
        run: |
          cd android
          fastlane production
      
      - name: Deploy Web to Production
        uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: '${{ secrets.GITHUB_TOKEN }}'
          firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT }}'
          projectId: squeak-flutter
          channelId: live
```

## 🔧 Environment Configuration

### Environment Variables
```bash
# .env.development
FLUTTER_ENV=development
API_BASE_URL=http://localhost:8000/api
FIREBASE_PROJECT_ID=squeak-flutter-dev
ENABLE_LOGGING=true
USE_EMULATORS=true

# .env.staging
FLUTTER_ENV=staging
API_BASE_URL=https://api-staging.squeak.app
FIREBASE_PROJECT_ID=squeak-flutter-staging
ENABLE_LOGGING=true
USE_EMULATORS=false

# .env.production
FLUTTER_ENV=production
API_BASE_URL=https://api.squeak.app
FIREBASE_PROJECT_ID=squeak-flutter
ENABLE_LOGGING=false
USE_EMULATORS=false
```

### Build Scripts
```bash
#!/bin/bash
# scripts/build_all.sh

set -e

echo "🚀 Building Squeak App for all platforms..."

# Clean workspace
flutter clean
flutter pub get

# Run tests
echo "🧪 Running tests..."
flutter test

# Build iOS
echo "📱 Building iOS..."
flutter build ios --release --no-codesign

# Build Android APK
echo "🤖 Building Android APK..."
flutter build apk --release

# Build Android AAB
echo "📦 Building Android AAB..."
flutter build appbundle --release

# Build Web
echo "🌐 Building Web..."
flutter build web --release

echo "✅ All builds completed successfully!"
```

### Release Script
```bash
#!/bin/bash
# scripts/release.sh

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <version>"
    echo "Example: $0 1.2.0"
    exit 1
fi

VERSION=$1

echo "🚀 Preparing release v$VERSION..."

# Update version in pubspec.yaml
sed -i '' "s/^version: .*/version: $VERSION+$(($(data +%s) / 60))/" pubspec.yaml

# Commit version bump
git add pubspec.yaml
git commit -m "chore: bump version to $VERSION"

# Create tag
git tag "v$VERSION"

# Push changes
git push origin main --tags

echo "✅ Release v$VERSION prepared!"
echo "GitHub Actions will handle the deployment."
```

## 📊 Monitoring & Analytics

### Performance Monitoring
```dart
// lib/core/monitoring/performance_monitoring.dart
import 'package:firebase_performance/firebase_performance.dart';

class PerformanceMonitoring {
  static final FirebasePerformance _performance = FirebasePerformance.instance;
  
  static Future<void> initialize() async {
    await _performance.setPerformanceCollectionEnabled(true);
  }
  
  static Trace startTrace(String name) {
    return _performance.newTrace(name);
  }
  
  static HttpMetric startHttpMetric(String url, String method) {
    return _performance.newHttpMetric(url, HttpMethod.values.firstWhere(
      (m) => m.toString().split('.').last.toUpperCase() == method.toUpperCase(),
    ));
  }
}
```

### Crash Reporting
```dart
// lib/core/monitoring/crash_reporting.dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class CrashReporting {
  static Future<void> initialize() async {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    
    // Pass all uncaught errors to Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    
    // Pass all uncaught asynchronous errors to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
  
  static void recordError(dynamic error, StackTrace? stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
  }
  
  static void log(String message) {
    FirebaseCrashlytics.instance.log(message);
  }
  
  static void setUserIdentifier(String identifier) {
    FirebaseCrashlytics.instance.setUserIdentifier(identifier);
  }
}
```

## 🔐 Security & Secrets Management

### GitHub Secrets Configuration
```yaml
# Required GitHub Secrets
ANDROID_KEYSTORE: # Base64 encoded keystore file
KEYSTORE_PASSWORD: # Keystore password
KEY_PASSWORD: # Key password
KEY_ALIAS: # Key alias

IOS_CERTIFICATE: # Base64 encoded certificate
IOS_CERTIFICATE_PASSWORD: # Certificate password
IOS_PROVISIONING_PROFILE: # Base64 encoded provisioning profile

FIREBASE_SERVICE_ACCOUNT: # Firebase service account JSON
FIREBASE_APP_ID_ANDROID: # Firebase Android app ID
FIREBASE_APP_ID_IOS: # Firebase iOS app ID

SLACK_WEBHOOK_URL: # Slack notifications
GITHUB_TOKEN: # GitHub API token

FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD: # App Store Connect password
SUPPLY_JSON_KEY_DATA: # Google Play Console service account
```

### Environment-specific Configurations
```dart
// lib/core/config/environment_config.dart
abstract class EnvironmentConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.squeak.app',
  );
  
  static const String firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: 'squeak-flutter',
  );
  
  static const bool enableLogging = bool.fromEnvironment(
    'ENABLE_LOGGING',
    defaultValue: false,
  );
  
  static const bool useEmulators = bool.fromEnvironment(
    'USE_EMULATORS',
    defaultValue: false,
  );
}
```

## 📈 Deployment Metrics

### Success Criteria
- **Build Success Rate**: >95%
- **Deployment Time**: <15 minutes
- **Rollback Time**: <5 minutes
- **Test Coverage**: >80%
- **Performance**: No regression

### Monitoring Dashboard
```yaml
# Deployment metrics to track
metrics:
  - build_duration
  - test_success_rate
  - deployment_frequency
  - lead_time_for_changes
  - mean_time_to_recovery
  - change_failure_rate
```

## 🚨 Rollback Procedures

### Immediate Rollback
```bash
# iOS Rollback (App Store Connect)
# 1. Go to App Store Connect
# 2. Select the previous version
# 3. Re-submit for review

# Android Rollback (Play Console)
# 1. Go to Play Console
# 2. Create release with previous AAB
# 3. Roll out to 100%

# Web Rollback (Firebase)
firebase hosting:channel:deploy CHANNEL_ID --only=hosting:production
```

### Automated Rollback
```yaml
# Auto-rollback on high error rate
alert_rules:
  - alert: HighErrorRate
    expr: error_rate > 0.05
    for: 2m
    annotations:
      summary: "High error rate detected"
      description: "Error rate is {{ $value }}"
    labels:
      severity: critical
      action: rollback
```

---

This comprehensive deployment and DevOps documentation ensures reliable, secure, and scalable deployments across all platforms with proper monitoring, rollback procedures, and automation.
