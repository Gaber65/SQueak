import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_status.dart';
import 'package:squeak/features/mating/chat/domain/usecases/get_chats_usecase.dart';
import '../../domain/usecases/parameters.dart';
import 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  final GetChatsUseCase getChatsUseCase;

  ChatListCubit({required this.getChatsUseCase}) : super(ChatListInitial());

  static get(BuildContext context) => BlocProvider.of<ChatListCubit>(context);

  ChatStatus? status;

  Future<void> loadChats({ChatStatus? status}) async {
    emit(ChatListLoading());

    final result = await getChatsUseCase(GetChatsParameters(status: status));
    this.status = status;
    print(status);
    result.fold(
      (failure) => emit(ChatListError(failure.toString())),
      (chats) => emit(ChatListLoaded(chats)),
    );
  }

  void filterChatsByStatus(ChatStatus status) {
    final currentState = state;
    if (currentState is ChatListLoaded) {
      final filteredChats =
          currentState.chats.where((chat) => chat.status == status).toList();
      emit(ChatListLoaded(filteredChats));
    }
  }
}
