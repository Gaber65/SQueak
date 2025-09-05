# 🛠️ Maintenance & Troubleshooting Guide

## Overview

This document provides comprehensive guidance for maintaining, troubleshooting, and supporting the Squeak Flutter application throughout its lifecycle.

## 📋 Maintenance Checklist

### Daily Maintenance
- [ ] Monitor application performance metrics
- [ ] Check error logs and crash reports
- [ ] Review user feedback and support tickets
- [ ] Verify API health and response times
- [ ] Monitor Firebase quota usage

### Weekly Maintenance
- [ ] Update dependencies for security patches
- [ ] Review and merge approved pull requests
- [ ] Analyze user behavior and app analytics
- [ ] Test critical user flows on staging
- [ ] Backup database and user data

### Monthly Maintenance
- [ ] Flutter framework updates
- [ ] iOS/Android SDK updates
- [ ] Dependencies major version updates
- [ ] Performance optimization review
- [ ] Security audit and vulnerability scan
- [ ] Review and update documentation

### Quarterly Maintenance
- [ ] Complete architecture review
- [ ] Code quality assessment
- [ ] User experience audit
- [ ] Third-party service review
- [ ] Disaster recovery testing
- [ ] Team knowledge sharing sessions

## 🚨 Common Issues & Solutions

### 🔧 Development Issues

#### Flutter Version Conflicts
```bash
# Symptoms
- Build failures after Flutter updates
- Unexpected behavior in development
- Package compatibility issues

# Solutions
# 1. Check current Flutter version
flutter --version

# 2. Update Flutter
flutter upgrade

# 3. Clean and rebuild
flutter clean
flutter pub get
flutter pub upgrade

# 4. Reset Flutter if needed
flutter channel stable
flutter upgrade --force
```

#### Dependency Conflicts
```bash
# Symptoms
- Pub get failures
- Version solving errors
- Runtime dependency errors

# Solutions
# 1. Clear pub cache
flutter pub cache clean

# 2. Delete pubspec.lock and rebuild
rm pubspec.lock
flutter pub get

# 3. Override specific versions
dependency_overrides:
  package_name: ^1.0.0

# 4. Use pub deps to analyze
flutter pub deps
```

#### iOS Build Issues
```bash
# Symptoms
- CocoaPods errors
- Xcode build failures
- Simulator launch issues

# Solutions
# 1. Clean iOS build
cd ios
rm -rf Pods
rm Podfile.lock
pod cache clean --all
pod install

# 2. Clean Xcode derived data
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# 3. Reset iOS simulator
xcrun simctl erase all

# 4. Update CocoaPods
sudo gem install cocoapods
```

#### Android Build Issues
```bash
# Symptoms
- Gradle build failures
- APK/AAB generation errors
- Emulator connection issues

# Solutions
# 1. Clean Android build
cd android
./gradlew clean

# 2. Update Gradle wrapper
./gradlew wrapper --gradle-version 8.0

# 3. Clear Android cache
rm -rf ~/.gradle/caches
rm -rf ~/.android/cache

# 4. Reset Android emulator
$ANDROID_HOME/emulator/emulator -avd YOUR_AVD -wipe-data
```

### 🌐 Production Issues

#### API Connection Problems
```dart
// Symptoms
- Network timeouts
- Authentication failures
- Server errors

// Solutions
// 1. Implement retry logic
class ApiService {
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  
  Future<Response> _retryRequest(
    Future<Response> Function() request,
  ) async {
    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        return await request();
      } catch (e) {
        if (attempt == maxRetries - 1) rethrow;
        await Future.delayed(retryDelay * (attempt + 1));
      }
    }
    throw Exception('Max retries exceeded');
  }
}

// 2. Add connection monitoring
class ConnectionService {
  static Stream<bool> get connectionStream =>
      Connectivity().onConnectivityChanged.map(
        (result) => result != ConnectivityResult.none,
      );
  
  static Future<bool> hasConnection() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
```

#### Performance Issues
```dart
// Symptoms
- App lag and stuttering
- High memory usage
- Battery drain

// Solutions
// 1. Optimize widget rebuilds
class OptimizedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyCubit, MyState>(
      buildWhen: (previous, current) => 
          previous.relevantData != current.relevantData,
      builder: (context, state) {
        // Only rebuild when necessary
        return const Widget();
      },
    );
  }
}

// 2. Implement lazy loading
class LazyListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        // Items built on demand
        return ListTile(title: Text(items[index]));
      },
    );
  }
}

// 3. Use AutomaticKeepAliveClientMixin for expensive widgets
class ExpensiveWidget extends StatefulWidget {
  @override
  _ExpensiveWidgetState createState() => _ExpensiveWidgetState();
}

class _ExpensiveWidgetState extends State<ExpensiveWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  
  @override
  Widget build(BuildContext context) {
    super.build(context); // Must call
    return const ExpensiveWidget();
  }
}
```

#### Firebase Issues
```dart
// Symptoms
- Authentication failures
- Firestore connection errors
- Cloud messaging not working

// Solutions
// 1. Check Firebase configuration
class FirebaseChecker {
  static Future<void> validateSetup() async {
    try {
      // Test Firebase Core
      await Firebase.initializeApp();
      print('✅ Firebase Core initialized');
      
      // Test Authentication
      await FirebaseAuth.instance.signInAnonymously();
      print('✅ Firebase Auth working');
      
      // Test Firestore
      await FirebaseFirestore.instance
          .collection('test')
          .doc('test')
          .set({'timestamp': FieldValue.serverTimestamp()});
      print('✅ Firestore working');
      
      // Test Messaging
      final token = await FirebaseMessaging.instance.getToken();
      print('✅ FCM Token: $token');
      
    } catch (e) {
      print('❌ Firebase Error: $e');
    }
  }
}

// 2. Implement offline support
class OfflineFirestore {
  static Future<void> enableOfflinePersistence() async {
    await FirebaseFirestore.instance.enablePersistence();
    
    // Configure offline settings
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }
}
```

### 📱 Platform-Specific Issues

#### iOS-Specific Problems
```swift
// Symptoms
- App Store rejection
- iOS-specific crashes
- Device-specific issues

// Solutions
// 1. Info.plist configuration
<!-- ios/Runner/Info.plist -->
<dict>
    <!-- Camera permission -->
    <key>NSCameraUsageDescription</key>
    <string>This app needs camera access to scan QR codes</string>
    
    <!-- Photo library permission -->
    <key>NSPhotoLibraryUsageDescription</key>
    <string>This app needs photo access to select pet images</string>
    
    <!-- Location permission -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>This app needs location access to find nearby clinics</string>
</dict>

// 2. Memory management
class MemoryManager {
    static func handleMemoryWarning() {
        // Clear image caches
        SDImageCache.shared.clearMemory()
        
        // Clear other caches
        URLCache.shared.removeAllCachedResponses()
    }
}
```

#### Android-Specific Problems
```xml
<!-- Symptoms -->
<!-- - Google Play rejection -->
<!-- - Android-specific crashes -->
<!-- - Permission issues -->

<!-- Solutions -->
<!-- 1. AndroidManifest.xml configuration -->
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Camera permission -->
    <uses-permission android:name="android.permission.CAMERA" />
    
    <!-- Photo library permission -->
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    
    <!-- Network permissions -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    
    <!-- Notification permission (Android 13+) -->
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    
    <application
        android:name="io.flutter.app.FlutterApplication"
        android:label="Squeak"
        android:icon="@mipmap/ic_launcher"
        android:usesCleartextTraffic="true">
        
        <!-- FileProvider for image sharing -->
        <provider
            android:name="androidx.core.content.FileProvider"
            android:authorities="${applicationId}.fileprovider"
            android:grantUriPermissions="true"
            android:exported="false">
            <meta-data
                android:name="android.support.FILE_PROVIDER_PATHS"
                android:resource="@xml/file_paths" />
        </provider>
    </application>
</manifest>
```

## 🔍 Debugging Tools & Techniques

### Flutter Inspector
```bash
# Enable Flutter Inspector
flutter run --debug

# Widget tree inspection
# 1. Open Flutter Inspector in IDE
# 2. Click on widgets to inspect
# 3. View widget properties and constraints
# 4. Analyze layout issues
```

### Performance Profiling
```bash
# CPU Profiling
flutter run --profile
# Open DevTools in browser
# Go to Performance tab
# Record and analyze performance

# Memory Profiling
flutter run --debug
# Open DevTools
# Go to Memory tab
# Monitor memory usage and leaks
```

### Network Debugging
```dart
// Add network interceptor
class NetworkInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST: ${options.method} ${options.uri}');
    print('HEADERS: ${options.headers}');
    print('DATA: ${options.data}');
    super.onRequest(options, handler);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE: ${response.statusCode}');
    print('DATA: ${response.data}');
    super.onResponse(response, handler);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('ERROR: ${err.message}');
    print('RESPONSE: ${err.response?.data}');
    super.onError(err, handler);
  }
}
```

### Logging System
```dart
// Comprehensive logging
class AppLogger {
  static const String _logFile = 'app_logs.txt';
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
  );
  
  static void debug(String message) {
    _logger.d(message);
    _writeToFile('DEBUG', message);
  }
  
  static void info(String message) {
    _logger.i(message);
    _writeToFile('INFO', message);
  }
  
  static void warning(String message) {
    _logger.w(message);
    _writeToFile('WARNING', message);
  }
  
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
    _writeToFile('ERROR', message);
    
    // Send to crash reporting
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }
  
  static Future<void> _writeToFile(String level, String message) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_logFile');
      final timestamp = DateTime.now().toIso8601String();
      await file.writeAsString(
        '[$timestamp] $level: $message\n',
        mode: FileMode.append,
      );
    } catch (e) {
      print('Failed to write log: $e');
    }
  }
  
  static Future<String> getLogs() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_logFile');
      return await file.readAsString();
    } catch (e) {
      return 'No logs available';
    }
  }
}
```

## 📊 Monitoring & Alerting

### Health Check System
```dart
// App health monitoring
class HealthChecker {
  static Future<HealthStatus> checkAppHealth() async {
    final checks = <String, bool>{};
    
    // Check network connectivity
    checks['network'] = await _checkNetwork();
    
    // Check Firebase connection
    checks['firebase'] = await _checkFirebase();
    
    // Check API endpoints
    checks['api'] = await _checkAPI();
    
    // Check local storage
    checks['storage'] = await _checkStorage();
    
    final allHealthy = checks.values.every((healthy) => healthy);
    
    return HealthStatus(
      isHealthy: allHealthy,
      checks: checks,
      timestamp: DateTime.now(),
    );
  }
  
  static Future<bool> _checkNetwork() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
  
  static Future<bool> _checkFirebase() async {
    try {
      await FirebaseFirestore.instance
          .collection('health')
          .doc('check')
          .get();
      return true;
    } catch (_) {
      return false;
    }
  }
  
  static Future<bool> _checkAPI() async {
    try {
      final response = await Dio().get('/health');
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
  
  static Future<bool> _checkStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('health_check', DateTime.now().toString());
      return true;
    } catch (_) {
      return false;
    }
  }
}

class HealthStatus {
  final bool isHealthy;
  final Map<String, bool> checks;
  final DateTime timestamp;
  
  HealthStatus({
    required this.isHealthy,
    required this.checks,
    required this.timestamp,
  });
}
```

### Performance Metrics
```dart
// Performance monitoring
class PerformanceMetrics {
  static final Map<String, int> _operationCounts = {};
  static final Map<String, Duration> _operationTimes = {};
  
  static Future<T> measureOperation<T>(
    String operationName,
    Future<T> Function() operation,
  ) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      final result = await operation();
      _recordSuccess(operationName, stopwatch.elapsed);
      return result;
    } catch (e) {
      _recordError(operationName, stopwatch.elapsed);
      rethrow;
    }
  }
  
  static void _recordSuccess(String operation, Duration duration) {
    _operationCounts[operation] = (_operationCounts[operation] ?? 0) + 1;
    _operationTimes[operation] = duration;
    
    // Log slow operations
    if (duration.inMilliseconds > 1000) {
      AppLogger.warning('Slow operation: $operation took ${duration.inMilliseconds}ms');
    }
  }
  
  static void _recordError(String operation, Duration duration) {
    AppLogger.error('Failed operation: $operation failed after ${duration.inMilliseconds}ms');
  }
  
  static Map<String, dynamic> getMetrics() {
    return {
      'operation_counts': _operationCounts,
      'operation_times': _operationTimes.map(
        (key, value) => MapEntry(key, value.inMilliseconds),
      ),
    };
  }
}
```

## 🔄 Data Recovery & Backup

### Local Data Backup
```dart
// Local data backup system
class DataBackup {
  static const String _backupDir = 'backups';
  
  static Future<void> createBackup() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final backupPath = '${directory.path}/$_backupDir';
      final backupDir = Directory(backupPath);
      
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }
      
      // Backup SharedPreferences
      await _backupSharedPreferences(backupPath);
      
      // Backup local database
      await _backupLocalDatabase(backupPath);
      
      // Backup user files
      await _backupUserFiles(backupPath);
      
      AppLogger.info('Backup created successfully');
    } catch (e) {
      AppLogger.error('Backup failed: $e');
    }
  }
  
  static Future<void> _backupSharedPreferences(String backupPath) async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final data = <String, dynamic>{};
    
    for (final key in keys) {
      data[key] = prefs.get(key);
    }
    
    final file = File('$backupPath/shared_preferences.json');
    await file.writeAsString(jsonEncode(data));
  }
  
  static Future<void> _backupLocalDatabase(String backupPath) async {
    // Backup SQLite database if used
    final dbPath = await getDatabasesPath();
    final dbFile = File('$dbPath/app_database.db');
    
    if (await dbFile.exists()) {
      final backupFile = File('$backupPath/database.db');
      await dbFile.copy(backupFile.path);
    }
  }
  
  static Future<void> _backupUserFiles(String backupPath) async {
    // Backup user images and documents
    final directory = await getApplicationDocumentsDirectory();
    final userFiles = Directory('${directory.path}/user_files');
    
    if (await userFiles.exists()) {
      final backupFiles = Directory('$backupPath/user_files');
      await backupFiles.create(recursive: true);
      
      await for (final file in userFiles.list(recursive: true)) {
        if (file is File) {
          final relativePath = path.relative(file.path, from: userFiles.path);
          final backupFile = File('${backupFiles.path}/$relativePath');
          await backupFile.parent.create(recursive: true);
          await file.copy(backupFile.path);
        }
      }
    }
  }
  
  static Future<void> restoreBackup() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final backupPath = '${directory.path}/$_backupDir';
      
      // Restore SharedPreferences
      await _restoreSharedPreferences(backupPath);
      
      // Restore database
      await _restoreLocalDatabase(backupPath);
      
      // Restore user files
      await _restoreUserFiles(backupPath);
      
      AppLogger.info('Backup restored successfully');
    } catch (e) {
      AppLogger.error('Restore failed: $e');
    }
  }
  
  static Future<void> _restoreSharedPreferences(String backupPath) async {
    final file = File('$backupPath/shared_preferences.json');
    if (!await file.exists()) return;
    
    final data = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    final prefs = await SharedPreferences.getInstance();
    
    for (final entry in data.entries) {
      final value = entry.value;
      if (value is String) {
        await prefs.setString(entry.key, value);
      } else if (value is int) {
        await prefs.setInt(entry.key, value);
      } else if (value is double) {
        await prefs.setDouble(entry.key, value);
      } else if (value is bool) {
        await prefs.setBool(entry.key, value);
      } else if (value is List<String>) {
        await prefs.setStringList(entry.key, value);
      }
    }
  }
  
  static Future<void> _restoreLocalDatabase(String backupPath) async {
    final backupFile = File('$backupPath/database.db');
    if (!await backupFile.exists()) return;
    
    final dbPath = await getDatabasesPath();
    final dbFile = File('$dbPath/app_database.db');
    await backupFile.copy(dbFile.path);
  }
  
  static Future<void> _restoreUserFiles(String backupPath) async {
    final backupFiles = Directory('$backupPath/user_files');
    if (!await backupFiles.exists()) return;
    
    final directory = await getApplicationDocumentsDirectory();
    final userFiles = Directory('${directory.path}/user_files');
    await userFiles.create(recursive: true);
    
    await for (final file in backupFiles.list(recursive: true)) {
      if (file is File) {
        final relativePath = path.relative(file.path, from: backupFiles.path);
        final targetFile = File('${userFiles.path}/$relativePath');
        await targetFile.parent.create(recursive: true);
        await file.copy(targetFile.path);
      }
    }
  }
}
```

## 📞 Support & Escalation

### Support Ticket System
```dart
// In-app support system
class SupportSystem {
  static Future<void> submitBugReport({
    required String title,
    required String description,
    required String userEmail,
    List<File>? attachments,
  }) async {
    try {
      // Collect system information
      final deviceInfo = await _collectDeviceInfo();
      final appLogs = await AppLogger.getLogs();
      final healthStatus = await HealthChecker.checkAppHealth();
      
      // Create support ticket
      final ticket = {
        'title': title,
        'description': description,
        'user_email': userEmail,
        'device_info': deviceInfo,
        'app_logs': appLogs,
        'health_status': healthStatus,
        'timestamp': DateTime.now().toIso8601String(),
        'app_version': await _getAppVersion(),
        'flutter_version': await _getFlutterVersion(),
      };
      
      // Submit to support system
      await _submitTicket(ticket, attachments);
      
      AppLogger.info('Support ticket submitted successfully');
    } catch (e) {
      AppLogger.error('Failed to submit support ticket: $e');
      rethrow;
    }
  }
  
  static Future<Map<String, dynamic>> _collectDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    
    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return {
        'platform': 'iOS',
        'version': iosInfo.systemVersion,
        'model': iosInfo.model,
        'name': iosInfo.name,
      };
    } else if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return {
        'platform': 'Android',
        'version': androidInfo.version.release,
        'model': androidInfo.model,
        'manufacturer': androidInfo.manufacturer,
      };
    }
    
    return {'platform': 'Unknown'};
  }
  
  static Future<String> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return '${packageInfo.version}+${packageInfo.buildNumber}';
  }
  
  static Future<String> _getFlutterVersion() async {
    // This would require additional implementation
    return 'Flutter 3.24.3';
  }
  
  static Future<void> _submitTicket(
    Map<String, dynamic> ticket,
    List<File>? attachments,
  ) async {
    // Submit to your support system API
    // This could be Zendesk, Freshdesk, or custom solution
  }
}
```

### Emergency Procedures
```dart
// Emergency response system
class EmergencyResponse {
  static Future<void> handleCriticalError(dynamic error, StackTrace stack) async {
    // 1. Log the error
    AppLogger.error('CRITICAL ERROR: $error', error, stack);
    
    // 2. Report to crash analytics
    await FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    
    // 3. Create automatic backup
    await DataBackup.createBackup();
    
    // 4. Notify development team
    await _notifyDevTeam(error, stack);
    
    // 5. Show user-friendly error message
    await _showErrorDialog(error);
  }
  
  static Future<void> _notifyDevTeam(dynamic error, StackTrace stack) async {
    // Send alert to development team
    // This could be Slack, email, or monitoring system
  }
  
  static Future<void> _showErrorDialog(dynamic error) async {
    // Show user-friendly error dialog with recovery options
  }
}
```

## 📚 Knowledge Base

### Common Error Messages
```
Error: "DioException: SocketException: Failed host lookup"
Solution: Check network connectivity and API endpoint configuration

Error: "MissingPluginException: No implementation found for method"
Solution: Run 'flutter clean' and 'flutter pub get', then restart

Error: "Firebase: No Firebase App '[DEFAULT]' has been created"
Solution: Ensure Firebase.initializeApp() is called before using Firebase services

Error: "Unhandled Exception: NoSuchMethodError"
Solution: Check for null values and proper type casting

Error: "RangeError: Index out of range"
Solution: Validate list bounds before accessing elements
```

### Performance Optimization Tips
```dart
// 1. Use const constructors
const Text('Hello World')

// 2. Avoid rebuilding widgets unnecessarily
class OptimizedBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyCubit, MyState>(
      listenWhen: (previous, current) => 
          previous.status != current.status,
      buildWhen: (previous, current) => 
          previous.data != current.data,
      listener: (context, state) {
        // Handle side effects
      },
      builder: (context, state) {
        // Build UI
        return Container();
      },
    );
  }
}

// 3. Use RepaintBoundary for complex widgets
RepaintBoundary(
  child: ComplexAnimatedWidget(),
)

// 4. Optimize images
Image.asset(
  'assets/image.jpg',
  cacheWidth: 300,
  cacheHeight: 200,
)
```

### Best Practices Summary
1. **Always handle errors gracefully**
2. **Use proper state management**
3. **Implement offline support**
4. **Monitor performance metrics**
5. **Keep dependencies updated**
6. **Write comprehensive tests**
7. **Document code changes**
8. **Use version control effectively**
9. **Implement proper logging**
10. **Plan for scalability**

---

This maintenance and troubleshooting guide provides comprehensive coverage for keeping the Squeak Flutter application running smoothly and resolving issues quickly when they arise.
