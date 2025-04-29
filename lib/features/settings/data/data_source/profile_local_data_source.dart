import 'package:squeak/core/service/cache/shared_preferences/cache_helper.dart';

abstract class ProfileLocalDataSource {
  Future<void> cacheCountryId(dynamic countryId);
  dynamic getCountryId();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  ProfileLocalDataSourceImpl();

  @override
  Future<void> cacheCountryId(dynamic countryId) async {
    await CacheHelper.saveData('countryId', countryId);
  }

  @override
  dynamic getCountryId() {
    return CacheHelper.getData('countryId');
  }
}
