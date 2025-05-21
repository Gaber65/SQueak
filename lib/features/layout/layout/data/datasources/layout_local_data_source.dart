import 'package:package_info_plus/package_info_plus.dart';
import 'package:squeak/core/error/failure.dart';

import '../../../../../core/network/error_message_model.dart';

abstract class LayoutLocalDataSource {
  Future<String> getCurrentAppVersion();
}

class LayoutLocalDataSourceImpl implements LayoutLocalDataSource {
  @override
  Future<String> getCurrentAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e) {
      throw ServerFailure(
        ErrorMessageModel(
          message: 'Failed to get current app version',
          statusCode: 0,
          errors: {},
          success: false,
        ),
      );
    }
  }
}
