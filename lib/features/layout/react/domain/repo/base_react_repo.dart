import 'package:dartz/dartz.dart';
import 'package:squeak/features/layout/react/domain/entities/react_entities.dart';

import '../../../../../core/error/failure.dart';

abstract class BaseReactRepo {
  Future<Either<Failure, ReactionSummary>> getAllReactOnPost(String postId);

  Future<Either<Failure, ReactionActionResult>> reactOnPost(ReactParams params);
}

class ReactParams {
  final String postId;
  int reactType;
  final String? petId;

  ReactParams({
    required this.postId,
    required this.petId,
    required this.reactType,
  });

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'dateTimeInUTC': DateTime.now().toUtc().toIso8601String(),
      'petId': petId!.isEmpty ? null : petId,
      'reactType': reactType,
    };
  }
}


enum ReactType {
  none(0),
  happy(1),
  sad(2),
  love(3),
  angry(4),
  like(5);

  final int value;
  const ReactType(this.value);

  /// Convert int (from API or DB) to ReactType
  static ReactType fromInt(int? value) {
    if (value == null) return ReactType.none;

    return ReactType.values.firstWhere(
          (type) => type.value == value,
      orElse: () => ReactType.none,
    );
  }

  /// Convert from UI index (0-4) to ReactType
  /// UI: 0=happy, 1=sad, 2=love, 3=angry, 4=like
  static ReactType fromUiIndex(int uiIndex) {
    if (uiIndex < 0 || uiIndex > 4) return ReactType.none;
    return fromInt(uiIndex + 1);
  }

  /// Convert this ReactType to UI index
  /// Returns null for ReactType.none
  int? get uiIndex {
    if (this == ReactType.none) return null;
    return value - 1;
  }

  /// Check if this is a valid reaction (not none)
  bool get isValidReaction => this != ReactType.none;

  /// Get display name for this reaction
  String get displayName {
    switch (this) {
      case ReactType.happy:
        return 'haha';
      case ReactType.sad:
        return 'sad';
      case ReactType.love:
        return 'love';
      case ReactType.angry:
        return 'angry';
      case ReactType.like:
        return 'like';
      case ReactType.none:
        return 'none';
    }
  }

  /// Get display emoji/icon name for this reaction
  String get emojiName {
    switch (this) {
      case ReactType.happy:
        return '😄';
      case ReactType.sad:
        return '😢';
      case ReactType.love:
        return '❤️';
      case ReactType.angry:
        return '😠';
      case ReactType.like:
        return '👍';
      case ReactType.none:
        return '';
    }
  }

  /// Check if this reaction is positive
  bool get isPositive {
    return this == ReactType.happy ||
        this == ReactType.love ||
        this == ReactType.like;
  }

  /// Check if this reaction is negative
  bool get isNegative {
    return this == ReactType.sad ||
        this == ReactType.angry;
  }

  /// Get color for this reaction (useful for UI)
  int get colorValue {
    switch (this) {
      case ReactType.happy:
        return 0xFFFFD700; // Gold/Yellow
      case ReactType.sad:
        return 0xFF1E90FF; // DodgerBlue
      case ReactType.love:
        return 0xFFFF1493; // DeepPink
      case ReactType.angry:
        return 0xFFFF4500; // OrangeRed
      case ReactType.like:
        return 0xFF0080FF; // Facebook Blue
      case ReactType.none:
        return 0xFF808080; // Grey
    }
  }

  /// Compare two ReactTypes
  bool isSameAs(ReactType other) {
    return value == other.value;
  }

  /// Check if this is greater than another ReactType
  bool isGreaterThan(ReactType other) {
    return value > other.value;
  }

  /// Check if this is less than another ReactType
  bool isLessThan(ReactType other) {
    return value < other.value;
  }

  @override
  String toString() {
    return 'ReactType.$name($value)';
  }

  /// Parse from string (useful for serialization)
  static ReactType? fromString(String value) {
    try {
      // Try to parse as "ReactType.name(value)"
      if (value.contains('(')) {
        final name = value.split('(').first;
        return ReactType.values.firstWhere((e) => e.name == name);
      }
      // Try to parse as just the name
      return ReactType.values.firstWhere((e) => e.name == value);
    } catch (e) {
      return null;
    }
  }

  /// Get all valid reaction types (excluding none)
  static List<ReactType> get validReactions {
    return ReactType.values.where((type) => type != ReactType.none).toList();
  }

  /// Get all UI indices for valid reactions
  static List<int> get validUiIndices {
    return validReactions.map((type) => type.uiIndex!).toList();
  }
}

/// Extension for int to easily convert to ReactType
extension IntToReactType on int {
  ReactType toReactType() {
    return ReactType.fromInt(this);
  }

  /// Convert to UI index (for arrays)
  int? toReactUiIndex() {
    return ReactType.fromInt(this).uiIndex;
  }
}

/// Extension for nullable int
extension NullableIntToReactType on int? {
  ReactType toReactTypeOrNone() {
    return ReactType.fromInt(this);
  }
}
