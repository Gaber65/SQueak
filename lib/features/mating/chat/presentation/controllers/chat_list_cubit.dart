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
    : super(ChatListInitial()) {
    // _listenToSignalR();
  }

  static ChatListCubit get(context) => BlocProvider.of(context);

  // void _listenToSignalR() {
  //   signalRService.connectToGeneralHub().catchError((e) {
  //     debugPrint('❌ Failed to connect to GeneralHub: $e');
  //   });

  //   signalRService.connectToConversationHub().catchError((e) {
  //     debugPrint('❌ Failed to connect to ConversationHub: $e');
  //   });

  //   _signalSubscription = signalEventStream.stream.listen((event) {
  //     debugPrint("🔔 Event received: $event");

  //     if (event.hub == "GeneralHub") {
  //       switch (event.method) {
  //         case "FriendIsTyping":
  //           emit(ChatListTypingUpdated(friendsTyping));
  //           break;
  //         case "ChatListUpdated":
  //           // ممكن تعمل loadChats هنا لو عايز تحدث القائمة
  //           break;
  //       }
  //     }

  //     if (event.hub == "ConversationHub") {
  //       switch (event.method) {
  //         case "ReceiveMessage":
  //         case "NewMessage":
  //           // لو عايز تحدث الـ chat list فورًا
  //           loadChats("petId"); // ضع الـ petId المناسب
  //           break;
  //         case "SetTyping":
  //           emit(ChatListTypingUpdated(friendsTyping));
  //           break;
  //       }
  //     }
  //   });
  // }

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
