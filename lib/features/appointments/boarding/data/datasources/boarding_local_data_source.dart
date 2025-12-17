import 'dart:convert';
import 'package:squeak/core/service/cache/shared_preferences/cache_helper.dart';

import '../../../../../core/error/exception.dart';
import '../models/boarding_entry_model.dart';

abstract class BoardingLocalDataSource {
  Future<List<BoardingEntryModel>> getCachedBoardingEntries();
  Future<void> cacheBoardingEntries(List<BoardingEntryModel> entries);
  Future<void> clearCache();
}

class BoardingLocalDataSourceImpl implements BoardingLocalDataSource {
  BoardingLocalDataSourceImpl();

  @override
  Future<List<BoardingEntryModel>> getCachedBoardingEntries() async {
    try {
      final cachedData = CacheHelper.getData('boardingEntry');
      if (cachedData != null) {
        final List<dynamic> jsonList = json.decode(cachedData);
        return jsonList
            .map((json) => BoardingEntryModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      throw LocalDatabaseException(
        errorMessage: 'Failed to get cached boarding entries: $e',
      );
    }
  }

  @override
  Future<void> cacheBoardingEntries(List<BoardingEntryModel> entries) async {
    try {
      final jsonString = json.encode(entries.map((e) => e.toJson()).toList());
      await CacheHelper.saveData('boardingEntry', jsonString);
    } catch (e) {
      throw LocalDatabaseException(
        errorMessage: 'Failed to cache boarding entries: $e',
      );
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await CacheHelper.removeData('boardingEntry');
    } catch (e) {
      throw LocalDatabaseException(errorMessage: 'Failed to clear cache: $e');
    }
  }
}
