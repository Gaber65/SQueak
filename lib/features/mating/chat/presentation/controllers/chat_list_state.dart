import 'package:equatable/equatable.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_entity.dart';

abstract class ChatListState extends Equatable {
  const ChatListState();

  @override
  List<Object> get props => [];
}

class ChatListInitial extends ChatListState {}

class ChatListLoading extends ChatListState {}

class ChatListLoaded extends ChatListState {
  final List<ChatEntity> chats;

  const ChatListLoaded(this.chats);

  @override
  List<Object> get props => [chats];
}

class ChatListError extends ChatListState {
  final String message;

  const ChatListError(this.message);

  @override
  List<Object> get props => [message];
}