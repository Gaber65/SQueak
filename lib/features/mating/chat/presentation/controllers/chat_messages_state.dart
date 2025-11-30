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


class MatingFinish extends ChatMessagesState {}
class MatingFinishSuccess extends ChatMessagesState {}

class MatingFinishError extends ChatMessagesState {
  final String message;

  const MatingFinishError(this.message);

  @override
  List<Object> get props => [message];
}

class RenameChat extends ChatMessagesState {}
class RenameChatSuccess extends ChatMessagesState {}
class RenameChatError extends ChatMessagesState {
  final String message;

  const RenameChatError(this.message);

  @override
  List<Object> get props => [message];
}


class BlockChat extends ChatMessagesState {}
class BlockChatSuccess extends ChatMessagesState {}
class BlockChatError extends ChatMessagesState {
  final String message;

  const BlockChatError(this.message);

  @override
  List<Object> get props => [message];
}


class RateMating extends ChatMessagesState {}
class RateMatingSuccess extends ChatMessagesState {}
class RateMatingError extends ChatMessagesState {
  final String message;

  const RateMatingError(this.message);

  @override
  List<Object> get props => [message];
}

class ClearChatLoading extends ChatMessagesState {}

class ClearChatSuccess extends ChatMessagesState {}
class ClearChatError extends ChatMessagesState {

  final String message;

  const ClearChatError(this.message);

  @override
  List<Object> get props => [message];
}

class DeleteMessageLoading extends ChatMessagesState {}
class DeleteMessageSuccess extends ChatMessagesState {}
class DeleteMessageError extends ChatMessagesState {

  final String message;

  const DeleteMessageError(this.message);

  @override
  List<Object> get props => [message];
}

class TypingStatusChanged extends ChatMessagesState {
  final bool isTyping;

  const TypingStatusChanged(this.isTyping);

  @override
  List<Object> get props => [isTyping];
}