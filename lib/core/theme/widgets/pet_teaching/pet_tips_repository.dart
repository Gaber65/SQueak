import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'did_you_know_card.dart';

/// Model for a pet tip item
class PetTip {
  final DidYouKnowCategory category;
  final String title;
  final String content;

  const PetTip({
    required this.category,
    required this.title,
    required this.content,
  });

  static PetTip fromMap(Map<String, dynamic> map) {
    return PetTip(
      category: _parseCategory(map['category'] as String?),
      title: (map['title'] ?? '').toString(),
      content: (map['content'] ?? '').toString(),
    );
  }

  static DidYouKnowCategory _parseCategory(String? raw) {
    switch ((raw ?? '').toLowerCase()) {
      case 'health':
        return DidYouKnowCategory.health;
      case 'nutrition':
        return DidYouKnowCategory.nutrition;
      case 'behavior':
        return DidYouKnowCategory.behavior;
      case 'safety':
        return DidYouKnowCategory.safety;
      case 'grooming':
        return DidYouKnowCategory.grooming;
      default:
        return DidYouKnowCategory.health;
    }
  }
}

/// Lightweight repository to load tips from bundled asset
class PetTipsRepository {
  final String assetPath;
  const PetTipsRepository({this.assetPath = 'assets/content/pet_tips.json'});

  Future<List<PetTip>> loadTips() async {
    try {
      final jsonStr = await rootBundle.loadString(assetPath);
      final data = json.decode(jsonStr) as Map<String, dynamic>;
      final tips =
          (data['tips'] as List<dynamic>? ?? [])
              .whereType<Map<String, dynamic>>()
              .map(PetTip.fromMap)
              .toList();
      return tips;
    } catch (_) {
      return const <PetTip>[];
    }
  }
}
