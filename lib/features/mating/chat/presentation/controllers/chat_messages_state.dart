import 'package:equatable/equatable.dart';
import 'package:squeak/features/mating/chat/domain/entities/message_entity.dart';

abstract class ChatMessagesState extends Equatable {
  const ChatMessagesState();

  @override
  List<Object> get props => [];
}

class ChatMessagesInitial extends ChatMessagesState {}

class ChatMessagesLoading extends ChatMessagesState {}

class ChatMessagesLoaded extends ChatMessagesState {
  final List<MessageEntity> messages;

  const ChatMessagesLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class ChatMessagesError extends ChatMessagesState {
  final String message;

  const ChatMessagesError(this.message);

  @override
  List<Object> get props => [message];
}

class MessageSending extends ChatMessagesState {}

class MessageSent extends ChatMessagesState {
  final MessageEntity message;

  const MessageSent(this.message);

  @override
  List<Object> get props => [message];
}

class MessageSendError extends ChatMessagesState {
  final String message;

  const MessageSendError(this.message);

  @override
  List<Object> get props => [message];
}