// chat_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/mating/chat/presentation/screens/chat_screen.dart';
import '../../../../../core/service/main_service/presentation/controller/main_cubit/main_cubit.dart';
import '../../../../../core/service/service_locator/service_locator.dart';
import '../../../../../core/utils/theme/color_mangment/color_manager.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/chat_status.dart';
import '../../domain/usecases/get_messages_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../controllers/chat_list_cubit.dart';
import '../controllers/chat_list_state.dart';
import '../controllers/chat_messages_cubit.dart';
import '../widgets/chat_list_item.dart';
import '../widgets/status_filter_item.dart';

class ProfessionalChatListScreen extends StatelessWidget {
  const ProfessionalChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ChatListCubit>()..loadChats(),
      child: Scaffold(
        body: BlocConsumer<ChatListCubit, ChatListState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            var cubit = ChatListCubit.get(context);
            return Column(
              children: [
                // Status Filter Section
                _buildStatusFilter(cubit),
                const SizedBox(height: 8),
                // Chats List
                Expanded(
                  child: BlocBuilder<ChatListCubit, ChatListState>(
                    builder: (context, state) {
                      if (state is ChatListLoading) {
                        return _buildLoadingState();
                      } else if (state is ChatListError) {
                        return _buildErrorState(context, state);
                      } else if (state is ChatListLoaded) {
                        if (state.chats.isEmpty) {
                          return _buildEmptyState();
                        } else {
                          return _buildChatsList(state.chats);
                        }
                      } else {
                        return _buildEmptyState();
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusFilter(ChatListCubit cubit) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                StatusFilterItem(
                  title: 'All',
                  count: 12,
                  isActive: cubit.status == null,
                  onTap: () => cubit.loadChats(),
                ),
                StatusFilterItem(
                  title: 'active',
                  count: 8,
                  isActive: cubit.status?.name == 'active',
                  onTap: () => cubit.loadChats(status: ChatStatus.active),
                ),
                StatusFilterItem(
                  title: 'onMating',
                  count: 3,
                  isActive: cubit.status?.name == 'onMating',
                  onTap: () => cubit.loadChats(status: ChatStatus.onMating),
                ),
                StatusFilterItem(
                  title: 'completed',
                  count: 1,
                  isActive: cubit.status?.name == 'completed',
                  onTap: () => cubit.loadChats(status: ChatStatus.completed),
                ),
                StatusFilterItem(
                  title: 'blocked',
                  count: 0,
                  isActive: cubit.status?.name == 'blocked',
                  onTap: () => cubit.loadChats(status: ChatStatus.blocked),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.network(
            'https://lottie.host/71b548e6-5cb4-4edb-ad43-cee69b516f49/0BKYpwc1Vc.json',
            height: 300,
            width: 300,
          ),
          const SizedBox(height: 20),
          const Text(
            'Fetching your pet chats...',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, ChatListError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.network(
            'https://lottie.host/b1930cd0-34dc-4097-9233-a36331b2372b/Oqk8zoLEPO.json',
            height: 300,
            width: 300,
          ),
          const SizedBox(height: 16),
          Text(
            'Oops! Something went wrong',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          Text(
            'Error: ${state.message}',
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<ChatListCubit>().loadChats(),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Try Again',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.network(
            'https://lottie.host/efe816d3-f5da-499c-b0b5-ffc0cd6f713e/oj7UhZc4wU.json',
            height: 300,
            width: 300,
          ),

          const SizedBox(height: 20),
          const Text(
            'No chats yet!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start matching with other pets to begin chatting',
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChatsList(List<ChatEntity> chats) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 16),
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return ChatListItem(
          chat: chat,
          onTap: () {
            navigateToScreen(context, ProfessionalChatScreen(chat: chat));
          },
        );
      },
    );
  }
}
