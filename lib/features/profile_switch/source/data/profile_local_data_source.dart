// data/sources/profile_local_data_source.dart
import 'dart:convert';

import 'package:squeak/core/service/cache/shared_preferences/cache_helper.dart';
import 'package:squeak/core/utils/enums/profile_type.dart';
import 'package:squeak/features/pets/data/models/pet_model.dart';
import 'package:squeak/features/profile_switch/domain/entities/profile_type_entity.dart';
import 'package:squeak/features/settings/data/models/owner_model.dart';

const String activeProfileKey = 'ACTIVE_PROFILE';

abstract class ProfileSwitchLocalDataSource {
  Future<ActiveProfile?> getCachedProfile();
  Future<void> cacheProfile(ActiveProfile profile);
}

class ProfileSwitchLocalDataSourceImpl implements ProfileSwitchLocalDataSource {
  @override
  Future<ActiveProfile?> getCachedProfile() async {
    final data = CacheHelper.getData(activeProfileKey);
    if (data == null) return null;

    final decoded = json.decode(data);
    final type = ProfileType.values.firstWhere(
      (e) => e.toString() == decoded['type'],
    );

    if (type == ProfileType.user) {
      return ActiveProfile.user(OwnerModel.fromJson(decoded['user']));
    } else {
      return ActiveProfile.pet(PetData.fromJson(decoded['pet']));
    }
  }

  @override
  Future<void> cacheProfile(ActiveProfile profile) async {
    final map = {
      'type': profile.type.toString(),
      'user':
          profile.user != null ? (profile.user as OwnerModel).toJson() : null,
      'pet': profile.pet != null ? (profile.pet as PetData).toJson() : null,
    };
    await CacheHelper.saveData(activeProfileKey, json.encode(map));
  }
}
