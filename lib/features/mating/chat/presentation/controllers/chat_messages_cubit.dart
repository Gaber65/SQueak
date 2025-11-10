import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/friendship/domain/entities/send_friend_message_parameters.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/usecases/clear_conversation_use_case.dart';
import '../../domain/usecases/parameters.dart';
import '../../domain/usecases/rate_mating_use_case.dart';
import 'chat_messages_state.dart';

class ChatMessagesCubit extends Cubit<ChatMessagesState> {
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final FinishMatingUseCase startMatingUseCase;
  final BlockChatUseCase blockChatUseCase;
  final RenameChatUseCase renameChatUseCase;
  final RateMatingUseCase rateMatingUseCase;

  ChatMessagesCubit({
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
    required this.startMatingUseCase,
    required this.blockChatUseCase,
    required this.renameChatUseCase,
    required this.rateMatingUseCase,
  }) : super(ChatMessagesInitial());

  static get(BuildContext context) =>
      BlocProvider.of<ChatMessagesCubit>(context);

  List<MessageEntity> messagesList = [];
  Future<void> loadMessages(String chatId) async {
   
   
    // If chatId is empty, this is a new conversation - don't load messages
    if (chatId.isEmpty) {
     
     emit(ChatMessagesLoaded([]));
      return;
    }
    
    emit(ChatMessagesLoading());

    final result = await getMessagesUseCase(
      GetMessagesParameters(chatId: chatId),
    );

    result.fold((failure) {
     
     emit(ChatMessagesError(failure.toString()));
    }, (messages) {
     
     messagesList = messages.reversed.toList();
      emit(ChatMessagesLoaded(messages));
    });
  }

  Future<void> sendMessage({
    required String chatId,
    required String text,
    required bool isMe,
    String? fromPetId,
    String? toPetId,
  }) async {
    emit(MessageSending());

   
   
    // Use friendship send message if fromPetId and toPetId are provided (new friend conversation)
    if (fromPetId != null && toPetId != null) {
     
      final friendMessageUseCase = sl<SendFriendMessageUseCase>();
      
      final result = await friendMessageUseCase(
        SendFriendPetMessageParameters(
          description: text,
          conversationId: chatId.isEmpty ? null : chatId,
          fromPetId: fromPetId,
          toPetId: toPetId,
          isRead: true,
        ),
      );

      result.fold((failure) {
       
       emit(MessageSendError(failure.toString()));
      }, (response) {
        
        
        // Create message entity from response
        final message = MessageEntity(
          description: text,
          isRead: true,
          fromUserId: fromPetId,
          toUserId: toPetId,
          createdAt: DateTime.now(),
          toMe: false,
        );
        
        messagesList.add(message);
        emit(MessageSent(message));
      });
    } else {
      // Use regular mating message
    
     final result = await sendMessageUseCase(
        SendMessageParameters(
          description: text,
          conversationId: chatId.isEmpty ? null : chatId,
          fromPetId: fromPetId,
          toPetId: toPetId,
          isRead: true,
        ),
      );

      result.fold((failure) {
       
        emit(MessageSendError(failure.toString()));
      }, (message) {
       
       messagesList.add(message);
        emit(MessageSent(message));
      });
    }
  }

  Future<void> finishMating(FinishMatingParameters matingId) async {
    emit(MatingFinish());

    final result = await startMatingUseCase(matingId);

    result.fold((failure) => emit(MatingFinishError(failure.toString())), (
      message,
    ) {
      emit(MatingFinishSuccess());
    });
  }

  Future<bool> blockChat(BlockChatParameters parameters) async {
    emit(BlockChat());

    final result = await blockChatUseCase(parameters);

    final isSuccess = result.fold(
      (failure) {
        emit(BlockChatError(extractFirstErrorAuth(failure.error)));
        return false;
      },
      (message) {
        emit(BlockChatSuccess());
        return true;
      },
    );
    return isSuccess;
  }

  Future<bool> renameChat(RenameChatParameters parameters) async {
    emit(RenameChat());

    final result = await renameChatUseCase(parameters);

    final isSuccess = result.fold(
      (failure) {
        emit(RenameChatError(extractFirstErrorAuth(failure.error)));
        return false;
      },
      (message) {
        emit(RenameChatSuccess());
        return true;
      },
    );
    return isSuccess;
  }

  bool isRating = false;
  Future<bool> rateMating(RateMatingParameters parameters) async {
    isRating = true;
    emit(RateMating());

    final result = await rateMatingUseCase(parameters);

    final isSuccess = result.fold(
      (failure) {
        isRating = false;
        emit(RateMatingError(extractFirstErrorAuth(failure.error)));
        return false;
      },
      (message) {
        isRating = false;
        emit(RateMatingSuccess());
        return true;
      },
    );
    return isSuccess;
  }

Future<void> clearMessages(ClearChatParameters parameters) async {
    emit(ClearChatLoading());

    final clearConversationUseCase = sl<ClearConversationUseCase>();
    // Debug: log clear chat parameters
    // print('CUBIT.clearMessages -> params: ${parameters.toJson()}');
    final result = await clearConversationUseCase(parameters);

    result.fold(
      (failure) {
        emit(ClearChatError(failure.toString()));
      },
      (isSuccess) {
        if (isSuccess) {
          messagesList.clear();
          emit(ClearChatSuccess());
        } else {
          emit(ClearChatError('Failed to clear chat'));
        }
      },
    );
  }
}
