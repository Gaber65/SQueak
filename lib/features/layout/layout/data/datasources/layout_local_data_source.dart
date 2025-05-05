import 'package:package_info_plus/package_info_plus.dart';
import 'package:squeak/core/error/failure.dart';


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
      throw ServerFailure('Failed to get current app version');
    }
  }
}
