import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_entity.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_status.dart';
import 'package:squeak/features/mating/chat/domain/usecases/get_chats_usecase.dart';
import 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  final GetChatsUseCase getChatsUseCase;

  List<ChatEntity> allChats = [];
  Map<String, bool> friendsTyping = {};

  ChatListCubit({required this.getChatsUseCase, required Object signalRService})
    : super(ChatListInitial());

  static ChatListCubit get(context) => BlocProvider.of(context);


  Future<void> loadChats(String petId, {ChatStatus? status}) async {
    emit(ChatListLoading());
    final result = await getChatsUseCase(petId);

    result.fold((failure) => emit(ChatListError(failure.toString())), (chats) {
      allChats = chats;
      emit(ChatListLoaded(allChats));
    });
  }

  @override
  Future<void> close() {
    // _signalSubscription?.cancel();
    return super.close();
  }
}
