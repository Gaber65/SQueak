import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_entity.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_status.dart';
import 'package:squeak/features/mating/chat/domain/usecases/get_chats_usecase.dart';
import 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  final GetChatsUseCase getChatsUseCase;

  ChatListCubit({required this.getChatsUseCase}) : super(ChatListInitial());

  static ChatListCubit get(BuildContext context) =>
      BlocProvider.of<ChatListCubit>(context);

  List<ChatEntity> allChats = [];

  Future<void> loadChats(String petId, {ChatStatus? status}) async {
    emit(ChatListLoading());
    final result = await getChatsUseCase(petId);

    result.fold((failure) => emit(ChatListError(failure.toString())), (chats) {
      emit(ChatListLoaded(chats));
    });
  }
}
