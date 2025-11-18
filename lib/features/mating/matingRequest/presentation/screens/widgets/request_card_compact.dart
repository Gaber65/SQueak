import 'package:flutter/material.dart';
import 'package:squeak/features/mating/chat/domain/entities/chat_entity.dart';
import 'package:squeak/features/mating/chat/presentation/screens/chat_screen.dart';
import 'package:squeak/features/mating/matingRequest/domain/entities/mating_request_entity.dart';
import 'package:squeak/features/mating/matingRequest/presentation/screens/widgets/action_button.dart';
import 'package:squeak/features/mating/profile/presentation/screens/view_pet_profile_screen.dart';
import '../../../../../../core/service/service_locator/locatore_export_path.dart';
import '../../../../../pets/domain/entities/pet_entity.dart';

class RequestCardCompact extends StatelessWidget {
  final MatingRequestEntity request;
  final bool isReceived;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onCancel;

  const RequestCardCompact({
    super.key,
    required this.request,
    required this.isReceived,
    this.onAccept,
    this.onReject,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final pet = isReceived ? request.fromPet : request.toPet;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.09)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipOval(
              child: InkWell(
                onTap: () {
                  navigateToScreen(
                    context,
                    ViewPetProfileScreen(
                      petId: pet.petId!,
                      isDarkMode: MainCubit.get(context).isDark,
                    ),
                  );
                },
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child:
                      pet.imageName != null && pet.imageName!.isNotEmpty
                          ? Image.network(
                            imageUrl + pet.imageName!,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  color: Colors.grey.shade200,
                                  child: Icon(
                                    Icons.pets,
                                    color: ColorManager.primaryColor,
                                  ),
                                ),
                          )
                          : Container(
                            color: Colors.grey.shade200,
                            child: Icon(
                              Icons.pets,
                              color: ColorManager.primaryColor,
                            ),
                          ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.petName ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getPetInfo(context, pet),
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: request.status.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      request.status.displayName,
                      style: TextStyle(
                        color: request.status.color,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Actions & Time
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatFacebookTimePost(request.timestamp),
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                ),
                const SizedBox(height: 8),
                if (isReceived && request.status == RequestStatus.pending) ...[
                  Row(
                    children: [
                      ActionButton.small(
                        icon: Icons.check,
                        color: Colors.green,
                        onTap: onAccept,
                      ),
                      const SizedBox(width: 8),
                      ActionButton.small(
                        icon: Icons.close,
                        color: Colors.red,
                        onTap: onReject,
                      ),
                    ],
                  ),
                ] else if (!isReceived &&
                    request.status == RequestStatus.pending) ...[
                  ActionButton.large(
                    icon: Icons.close,
                    color: Colors.orange,
                    onTap: onCancel,
                    label: S.of(context).cancelRequest,
                  ),
                ] else if (request.status == RequestStatus.accepted) ...[
                  ActionButton.large(
                    icon: Icons.chat,
                    color: ColorManager.primaryColor,
                    onTap: () {
                      final cubit = ManageRequestMatingCubit.get(context);
                      if (cubit.chatEntity != null) {
                        navigateToScreen(
                          context,
                          MatingChatDetailScreen(chat: cubit.chatEntity!),
                        );
                      } else if (cubit.conversationId.isNotEmpty) {
                        final newChat = ChatEntity(
                          id: cubit.conversationId,
                          name: pet.petName ?? 'Unknown',
                          petId: pet.petId ?? '',
                          matingId: '',
                          isBlock: false,
                          isBlockedByMe: false,
                          isBlockedByOther: false,
                          completeMarriageStatues: false,
                          isReadOnly: false,
                          isGroup: false,
                          isPetChat: true,
                          image: pet.imageName,
                          groupImage: null,
                          createdAt: DateTime.now().toIso8601String(),
                          lastMessageSendDateTime: DateTime.now().toIso8601String(),
                          unreadedCount: 0,
                        );
                        navigateToScreen(
                          context,
                          MatingChatDetailScreen(chat: newChat),
                        );
                      } else {
                        final chatCubit = ChatListCubit.get(context);
                        final petId =
                            isReceived
                                ? request.toPet.petId
                                : request.fromPet.petId;

                        chatCubit.loadChats(petId!).then((_) {
                          cubit.getChatItem(chatCubit.allChats);
                          if (cubit.chatEntity != null) {
                            navigateToScreen(
                              context,
                              MatingChatDetailScreen(chat: cubit.chatEntity!),
                            );
                          } else {
                            errorToast(
                              context,
                              S.of(context).chatNotFoundError,
                            );
                          }
                        });
                      }
                    },
                    label: S.of(context).startConversation,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getPetInfo(BuildContext context, PetEntities pet) {
    final age =
        (pet.birthdate != null && pet.birthdate != '')
            ? formatAge(DateTime.parse(pet.birthdate!.substring(0, 10)))
            : '';
    final breed = pet.breed?.enBreed ?? '';

    if (age.isNotEmpty && breed.isNotEmpty) {
      return '$age • $breed';
    } else if (age.isNotEmpty) {
      return age;
    } else if (breed.isNotEmpty) {
      return breed;
    }
    return '';
  }
}
