import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.id,
    required super.isGroup,
    required super.isPetChat,
    required super.name,
    required super.image,
    required super.groupImage,
    required super.petId,
    required super.matingId,
    required super.completeMarriageStatues,
    required super.createdAt,
    required super.lastMessageSendDateTime,
    required super.isBlock,
    required super.isBlockedByMe,
    required super.isBlockedByOther,
    required super.isReadOnly,

  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    // Print raw incoming JSON for full visibility
    try {
      if (kDebugMode) {
        print('📥 ChatModel.fromJson raw JSON: ${jsonEncode(json)}');
      }
    } catch (_) {
      // Fallback to simple print if encoding fails
      if (kDebugMode) {
        print('📥 ChatModel.fromJson raw JSON (fallback): $json');
      }
    }

    final model = ChatModel(
      id: json['id'] ?? '',
      isGroup: json['isGroup'] ?? false,
      isPetChat: json['isPetChat'] ?? false,
      name: json['name'] ?? 'Unknown',
      image: json['image'],
      groupImage: json['groupImage'],
      petId: json['petId'] ?? '',
      matingId: json['matingId'] ?? '',
      completeMarriageStatues: json['completeMarriageStatues'] ?? false,
      createdAt: json['createdAt'] ?? '',
      lastMessageSendDateTime: json['lastMessageSendDateTime'] ?? '',
      isBlock: json['isBlock'] ?? false,
      isBlockedByMe: json['isBlockedByMe'] ?? false,
      isBlockedByOther: json['isBlockedByOther'] ?? false,
      isReadOnly: json['isReadOnly'] ?? false,
    );

    if (kDebugMode) {
      print(
        '=====================================================================',
      );
    }
    if (kDebugMode) {
      print(
        '📥 ChatModel.fromJson parsed: isBlockByMe=${model.isBlockedByMe}, name=${model.name}, isBlockedByOther=${model.isBlockedByOther} 🐾',
      );
    }

    return model;
  }

  Map<String, dynamic> toJson() {
    final map = {
      'id': id,
      'isGroup': isGroup,
      'isPetChat': isPetChat,
      'name': name,
      'image': image,
      'groupImage': groupImage,
      'petId': petId,
      'matingId': matingId,
      'completeMarriageStatues': completeMarriageStatues,
      'createdAt': createdAt,
      'lastMessageSendDateTime': lastMessageSendDateTime,
      'isBlock': isBlock,
      'isBlockedByMe': isBlockedByMe,
      'isBlockedByOther': isBlockedByOther,
      'isReadOnly': isReadOnly,
    };
    try {
      if (kDebugMode) {
        print('==============={Blocked By Other}====================');
        print(map['isBlockedByOther']);
        print('📤 ChatModel.toJson JSON: ${jsonEncode(map)}');
      }
    } catch (_) {
      if (kDebugMode) {
        print('📤 ChatModel.toJson map (fallback): $map');
      }
    }

    return map;
  }

  static List<ChatModel> fromJsonList(List<dynamic> list) {
    if (kDebugMode) {
      print('🧾 ChatModel.fromJsonList: parsing ${list.length} item(s)');
    }
    return list.map((item) => ChatModel.fromJson(item)).toList();
  }
}
