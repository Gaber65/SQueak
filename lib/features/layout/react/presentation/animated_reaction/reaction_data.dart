import '../../domain/repo/base_react_repo.dart';

class ReactionData {
  // Array indices match UI display order
  // UI: 0=happy, 1=sad, 2=love, 3=angry, 4=like
  // Backend: 1=happy, 2=sad, 3=love, 4=angry, 5=like

  static List<String> facebookReactionIcon = [
    "assets/react/cat/haha.gif", // happy - ReactType.happy (1)
    "assets/react/cat/sad.gif", // sad - ReactType.sad (2)
    "assets/react/cat/love.gif", // love - ReactType.love (3)
    "assets/react/cat/angry.gif", // angry - ReactType.angry (4)
    "assets/react/cat/like.gif", // like - ReactType.like (5)
  ];

  static List<String> facebookReactionImage = [
    "assets/react/cat/haha.jpg", // happy
    "assets/react/cat/sad.jpg", // sad
    "assets/react/cat/love.jpg", // love
    "assets/react/cat/angry.jpg", // angry
    "assets/react/cat/like_fill_cat.jpg", // like
  ];

  static String activeReactionImage = "assets/react/cat/like_fill_cat.jpg";
  static String unActiveReactionImage = "assets/react/cat/like_gap_cat.jpg";

  static List<String> facebookNameText = [
    'haha', // happy - UI index 0
    'sad', // sad - UI index 1
    'love', // love - UI index 2
    'angry', // angry - UI index 3
    'like', // like - UI index 4
  ];

  /// Get icon for a ReactType
  static String getIconForReactType(ReactType type) {
    if (type == ReactType.none) return unActiveReactionImage;

    final uiIndex = type.uiIndex;
    if (uiIndex != null &&
        uiIndex >= 0 &&
        uiIndex < facebookReactionIcon.length) {
      return facebookReactionIcon[uiIndex];
    }

    return unActiveReactionImage;
  }

  /// Get image for a ReactType
  static String getImageForReactType(ReactType type) {
    if (type == ReactType.none) return unActiveReactionImage;
    if (type == ReactType.like) return activeReactionImage;

    final uiIndex = type.uiIndex;
    if (uiIndex != null &&
        uiIndex >= 0 &&
        uiIndex < facebookReactionImage.length) {
      return facebookReactionImage[uiIndex];
    }

    return unActiveReactionImage;
  }

  /// Get display name for a ReactType
  static String getNameForReactType(ReactType type) {
    final uiIndex = type.uiIndex;
    if (uiIndex != null && uiIndex >= 0 && uiIndex < facebookNameText.length) {
      return facebookNameText[uiIndex];
    }

    return type.displayName;
  }

  /// Convert UI index to ReactType
  static ReactType uiIndexToReactType(int uiIndex) {
    return ReactType.fromUiIndex(uiIndex);
  }

  /// Convert ReactType to UI index
  static int? reactTypeToUiIndex(ReactType type) {
    return type.uiIndex;
  }

  /// Get all ReactTypes for UI display (excluding none)
  static List<ReactType> get uiReactTypes {
    return ReactType.validReactions;
  }

  /// Check if a backend value is a valid reaction (1-5)
  static bool isValidBackendValue(int value) {
    return value >= 1 && value <= 5;
  }
}
