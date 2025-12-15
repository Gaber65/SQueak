import 'package:flutter/foundation.dart';
import 'package:squeak/core/utils/enums/env_enums.dart';
import 'package:squeak/core/service/main_service/presentation/widgets/init_functions.dart';

/// Global debug utility functions
class DebugUtils {
  /// Environment-aware debug print that respects the current environment
  /// Disables all debug prints when environment is production
  static void debugPrintEnv(String message) {
    if (kDebugMode && InitFunctions.currentEnvironment != Environment.pro) {
      debugPrint(message);
    }
  }

  /// Check if debug prints are enabled for current environment
  static bool get isDebugEnabled {
    return kDebugMode && InitFunctions.currentEnvironment != Environment.pro;
  }
}
