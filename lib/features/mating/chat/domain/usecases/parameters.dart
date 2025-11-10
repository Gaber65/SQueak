class GetMessagesParameters {
  final String chatId;

  const GetMessagesParameters({required this.chatId});
}

class SendMessageParameters {
  final String description;
  final String? image;
  final String? video;
  final String? audio;
  final bool isRead;
  final String? conversationId;
  final String? fromPetId;
  final String? toPetId;

  const SendMessageParameters({
    required this.description,
    this.image,
    this.video,
    this.audio,
    this.isRead = true,
    this.conversationId,
    this.fromPetId,
    this.toPetId,
  });

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'image': image,
      'video': video,
      'audio': audio,
      'isRead': isRead,
      'ConversationId': conversationId,
      if (fromPetId != null) 'fromPetId': fromPetId,
      if (toPetId != null) 'toPetId': toPetId,
    };
  }
}

class BlockChatParameters {
  final String conversationId;
  final int statues;
  final int conversationType;

  const BlockChatParameters({
    required this.conversationId,
    required this.statues,
    required this.conversationType,
  });

  Map<String, dynamic> toJson() {
    return {
      'conversationId': conversationId,
      'statues': statues,
      'conversationType': conversationType,
    };
  }
}

class RenameChatParameters {
  final String conversationId;
  final String petId;
  final String newName;
  final int conversationType;

  const RenameChatParameters({
    required this.conversationId,
    required this.petId,
    required this.newName,
    required this.conversationType,
  });

  Map<String, dynamic> toJson() {
    return {
      'conversationId': conversationId,
      'petId': petId,
      'newName': newName,
      'conversationType': conversationType,
    };
  }
}

class RateMatingParameters {
  final String matingId;
  final int rate;
  final String rateComment;

  const RateMatingParameters({
    required this.matingId,
    required this.rate,
    required this.rateComment,
  });

  Map<String, dynamic> toJson() => {
    'matingId': matingId,
    'rate': rate,
    'rateComment': rateComment,
  };
}

class ClearChatParameters {
  final String conversationId;
  final bool onlyFromMe;

  ClearChatParameters({required this.conversationId, required this.onlyFromMe});
  Map<String, dynamic> toJson() {
    return {'conversationId': conversationId, 'deleteForMeOnly': onlyFromMe};
  }
}

class DeleteMessageParameters {
  final String conversationId;
  final bool onlyFromMe;
  final String messageId;

  DeleteMessageParameters({
    required this.conversationId,
    required this.onlyFromMe,
    required this.messageId,
  });
  Map<String, dynamic> toJson() {
    return {
      'conversationId': conversationId,
      'deleteForMeOnly': onlyFromMe,
      'messageId': messageId
      };
  }
}
