import 'package:squeak/features/mating/chat/domain/entities/message_entity.dart';

abstract class ChatAppState {}

class ChatAppInitial extends ChatAppState {}

class ChatAppLoading extends ChatAppState {}

class ChatAppConnected extends ChatAppState {}

class ChatAppError extends ChatAppState {
  final String message;
  ChatAppError(this.message);
}

// Connection events
class ConnectionRegistered extends ChatAppState {
  final Map<String, dynamic> data;
  ConnectionRegistered(this.data);
}

// Friend status events
class FriendOnlineStatusChanged extends ChatAppState {
  final String petId;
  final bool isOnline;
  FriendOnlineStatusChanged(this.petId, this.isOnline);
}

class FriendTypingInGeneral extends ChatAppState {
  final String petId;
  final bool isTyping;
  FriendTypingInGeneral(this.petId, this.isTyping);
}

// Unread count events
class UnreadCountUpdated extends ChatAppState {
  final String conversationId;
  final int count;
  UnreadCountUpdated(this.conversationId, this.count);
}

// Conversation events
class JoiningConversation extends ChatAppState {
  final String conversationId;
  JoiningConversation(this.conversationId);
}

class ConversationJoined extends ChatAppState {
  final String conversationId;
  final List<String> unreadMessageIds;
  ConversationJoined(this.conversationId, this.unreadMessageIds);
}

class ConversationLeft extends ChatAppState {}

class PetJoinedConversation extends ChatAppState {
  final Map<String, dynamic> data;
  PetJoinedConversation(this.data);
}

class PetLeftConversation extends ChatAppState {
  final Map<String, dynamic> data;
  PetLeftConversation(this.data);
}

class FriendTypingInConversation extends ChatAppState {
  final String conversationId;
  final String petId;
  final bool isTyping;
  FriendTypingInConversation(this.conversationId, this.petId, this.isTyping);
}

// Message events
class MessageReceived extends ChatAppState {
  final String conversationId;
  final MessageEntity message;
  MessageReceived(this.conversationId, this.message);
}

class MessageSentOffline extends ChatAppState {
  final String conversationId;
  final MessageEntity message;
  MessageSentOffline(this.conversationId, this.message);
}

class MessageSentUnread extends ChatAppState {
  final String conversationId;
  final MessageEntity message;
  MessageSentUnread(this.conversationId, this.message);
}

class MessagesMarkedAsRead extends ChatAppState {
  final String conversationId;
  MessagesMarkedAsRead(this.conversationId);
}

// Read status events
class SingleMessageRead extends ChatAppState {
  final String conversationId;
  final String messageId;
  SingleMessageRead(this.conversationId, this.messageId);
}

class AllMessagesRead extends ChatAppState {
  final String conversationId;
  AllMessagesRead(this.conversationId);
}

class MessageStatusChanged extends ChatAppState {
  final String messageId;
  final bool isRead;
  MessageStatusChanged(this.messageId, this.isRead);
}

// Periodic polling events
class UnreadCountsPolled extends ChatAppState {
  final Map<String, int> counts;
  final DateTime timestamp;
  UnreadCountsPolled(this.counts) : timestamp = DateTime.now();
}

class NewMessageDetected extends ChatAppState {
  final DateTime timestamp;
  NewMessageDetected() : timestamp = DateTime.now();
}
