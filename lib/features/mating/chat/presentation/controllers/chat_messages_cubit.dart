import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/features/mating/chat/domain/usecases/get_messages_usecase.dart';
import 'package:squeak/features/mating/chat/domain/usecases/send_message_usecase.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/usecases/parameters.dart';
import 'chat_messages_state.dart';

class ChatMessagesCubit extends Cubit<ChatMessagesState> {
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;

  ChatMessagesCubit({
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
  }) : super(ChatMessagesInitial());

  static get(BuildContext context) => BlocProvider.of<ChatMessagesCubit>(context);

  Future<void> loadMessages(String chatId) async {
    emit(ChatMessagesLoading());

    final result = await getMessagesUseCase(GetMessagesParameters(chatId: chatId));

    result.fold(
          (failure) => emit(ChatMessagesError(failure.toString())),
          (messages) => emit(ChatMessagesLoaded(messages)),
    );
  }

  Future<void> sendMessage({
    required String chatId,
    required String text,
    required bool isMe,
  }) async {
    emit(MessageSending());

    final result = await sendMessageUseCase(
      SendMessageParameters(chatId: chatId, text: text, isMe: isMe),
    );

    result.fold(
          (failure) => emit(MessageSendError(failure.toString())),
          (message) {
        final currentState = state;
        if (currentState is ChatMessagesLoaded) {
          final updatedMessages = List<MessageEntity>.from(currentState.messages)..add(message);
          emit(ChatMessagesLoaded(updatedMessages));
        }
        emit(MessageSent(message));
      },
    );
  }
}