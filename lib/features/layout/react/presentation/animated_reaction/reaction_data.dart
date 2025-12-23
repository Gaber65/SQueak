class ReactionData {
  // Indexes correspond to ReactType enum order
  static List<String> facebookReactionIcon = [
    "assets/react/cat/haha.gif", // ReactType.happy
    "assets/react/cat/sad.gif", // ReactType.sad
    "assets/react/cat/love.gif", // ReactType.love
    "assets/react/cat/angry.gif", // ReactType.angry
    "assets/react/cat/like.gif", // ReactType.like
  ];

  static List<String> facebookReactionImage = [
    "assets/react/cat/haha.jpg", // ReactType.happy
    "assets/react/cat/sad.jpg", // ReactType.sad
    "assets/react/cat/love.jpg", // ReactType.love
    "assets/react/cat/angry.jpg", // ReactType.angry
    "assets/react/cat/like_fill_cat.jpg", // ReactType.like
  ];
  static String activeReactionImage = "assets/react/cat/like_fill_cat.jpg";
  static String unActiveReactionImage = "assets/react/cat/like_gap_cat.jpg";
}
