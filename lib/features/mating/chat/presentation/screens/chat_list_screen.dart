import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:squeak/core/service/global_widget/loading_widget.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/core/service/signalr/signalr_service.dart';
// removed unused imports; `MatingChatListTile` handles chat navigation
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import '../../../../../core/utils/enums/profile_type.dart';
import '../../../../profile_switch/Presentation/cubit/switch_profile_state.dart';
import '../../../../settings/persentaion/controller/setting_cubit.dart';
import '../../../layoutMating/presentation/screens/widgets/profile_switcher_builder.dart';
import '../../domain/entities/chat_entity.dart';
import '../controllers/chat_list_state.dart';
import '../widgets/mating_chat_list_tile.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final SignalRService _signalRService = SignalRService();

  @override
  void initState() {
    super.initState();
    // Connect to General Hub when chat list screen opens
    _connectToGeneralHub();
  }

  @override
  void dispose() {
    // Disconnect from General Hub when chat list screen closes
    _disconnectFromGeneralHub();
    super.dispose();
  }

  // Connect to General Hub for chat list updates
  Future<void> _connectToGeneralHub() async {
    try {
      await _signalRService.connectToGeneralHub();
    } catch (e) {
      debugPrint('❌ Failed to connect to General Hub: $e');
    }
  }

  // Disconnect from General Hub
  Future<void> _disconnectFromGeneralHub() async {
    try {
      await _signalRService.disconnectFromGeneralHub();
    } catch (e) {
      debugPrint('❌ Failed to disconnect from General Hub: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ChatListCubit>()),
        BlocProvider(create: (_) => sl<PetCubit>()..getOwnerPets()),
        BlocProvider(create: (_) => sl<SettingCubit>()..getOwnerData()),
        BlocProvider(create: (_) => sl<SwitchProfileCubit>()..loadProfile()),
      ],
      child: const _ChatListView(),
    );
  }
}

class _ChatListView extends StatelessWidget {
  const _ChatListView();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      body: BlocConsumer<ChatListCubit, ChatListState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ChatListCubit.get(context);
          return BlocSelector<
            SwitchProfileCubit,
            SwitchProfileState,
            PetEntities?
          >(
            selector: (state) {
              if (state is ProfileLoaded &&
                  state.profile.type == ProfileType.pet) {
                cubit.loadChats(state.profile.pet!.petId!);
                return state.profile.pet;
              }
              return null;
            },
            builder: (context, activePet) {
              return CustomScrollView(
                slivers: [
                  _buildModernAppBar(context, theme, isDark, s),
                  SliverToBoxAdapter(
                    child: BlocBuilder<ChatListCubit, ChatListState>(
                      builder: (context, state) {
                        if (state is ChatListLoading) {
                          return DogLoadingStateWidget(
                            theme: theme,
                            isDark: isDark,
                            s: s,
                            text: s.loadingPetsChats,
                          );
                        } else if (state is ChatListError) {
                          return _buildErrorState(
                            context,
                            theme,
                            isDark,
                            state,
                            s,
                          );
                        } else if (state is ChatListLoaded) {
                          if (state.chats.isEmpty) {
                            return _buildEmptyState(context, theme, isDark, s);
                          } else {
                            return RefreshIndicator(
                              onRefresh: () async {
                                if (activePet?.petId != null) {
                                  await cubit.loadChats(activePet!.petId!);
                                }
                              },
                              child: _buildChatsList(
                                context,
                                activePet?.petId ?? '',
                                state.chats,
                                theme,
                                isDark,
                              ),
                            );
                          }
                        }

                        return _buildEmptyState(context, theme, isDark, s);
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildModernAppBar(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    S s,
  ) {
    return SliverAppBar(
      floating: true,
      centerTitle: true,
      pinned: true,
      elevation: 0,
      title: Text(
        s.allChats,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
      backgroundColor: Colors.transparent,
      actions: [buildProfileSwitcher(context)],
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:
                isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: theme.colorScheme.onSurface,
            size: 18,
          ),
        ),
        onPressed: () => navigateAndFinish(context, LayoutScreen()),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    ChatListError state,
    S s,
  ) {
    return Container(
      height: MediaQuery.of(context).size.height - 200,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.network(
              'https://lottie.host/b1930cd0-34dc-4097-9233-a36331b2372b/Oqk8zoLEPO.json',
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 24),
            _buildGlassCard(
              theme,
              isDark,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      s.somethingWentWrong,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${s.errorColon} ${state.message}',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    _buildModernButton(
                      context,
                      theme,
                      isDark,
                      label: s.tryAgain,
                      icon: Icons.refresh_rounded,
                      onPressed:
                          () => context.read<ChatListCubit>().loadChats(''),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    S s,
  ) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.network(
              'https://lottie.host/efe816d3-f5da-499c-b0b5-ffc0cd6f713e/oj7UhZc4wU.json',
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 24),
            _buildGlassCard(
              theme,
              isDark,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      s.noChatsYet,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      s.startMatchingToChat,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatsList(
    BuildContext context,
    String petId,
    List<ChatEntity> chats,
    ThemeData theme,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: chats.map((chat) {
          return MatingChatListTile(
            chat: chat,
            petId: petId,
            onNavigateComplete: () async => ChatListCubit.get(context).loadChats(petId),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGlassCard(
    ThemeData theme,
    bool isDark, {
    required Widget child,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:
                  isDark
                      ? [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.05),
                      ]
                      : [
                        Colors.white.withOpacity(0.9),
                        Colors.white.withOpacity(0.7),
                      ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color:
                  isDark
                      ? Colors.white.withOpacity(0.2)
                      : Colors.black.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildModernButton(
    BuildContext context,
    ThemeData theme,
    bool isDark, {
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorManager.primaryColor,
            ColorManager.primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ColorManager.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
