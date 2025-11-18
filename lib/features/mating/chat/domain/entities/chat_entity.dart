import 'package:squeak/features/mating/chat/domain/entities/message_entity.dart';

class ChatEntity {
  final String id;
  final bool isGroup;
  final bool isPetChat;
  final String name;
  final String? image;
  final String? groupImage;
  final String petId;
  final String matingId;
  final bool completeMarriageStatues;
  final String createdAt;
  final String lastMessageSendDateTime;
  final bool isBlock;
  final bool isBlockedByMe; 
  final bool isBlockedByOther; 
  final bool isReadOnly;
  final int unreadedCount;
  final MessageEntity? lastMessage;

  const ChatEntity({
    required this.id,
    required this.isGroup,
    required this.isPetChat,
    required this.name,
    required this.image,
    required this.groupImage,
    required this.petId,
    required this.matingId,
    required this.completeMarriageStatues,
    required this.createdAt,
    required this.lastMessageSendDateTime,
    required this.isBlock,
    required  this.isBlockedByMe,
    required this.isBlockedByOther,
    required this.isReadOnly,
    required this.unreadedCount,
     this.lastMessage,
  });
}