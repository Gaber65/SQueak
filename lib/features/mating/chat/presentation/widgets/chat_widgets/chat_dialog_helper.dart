import 'package:flutter/material.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import '../../../domain/usecases/parameters.dart';
import 'chat_app_bar_widgets/confirmation_dialog.dart';
import 'chat_app_bar_widgets/dialog_header.dart';
import 'chat_app_bar_widgets/dialog_action_buttons.dart';
import 'chat_app_bar_widgets/status_option_widget.dart';

class ChatDialogHelper {
  static void showBlockDialog(
    BuildContext context, {
    required String userName,
    required ChatMessagesCubit cubit,
    required String conversationId,
  }) {
    showDialog(
      context: context,
      builder:
          (context) => ConfirmationDialog(
            icon: Icons.pets,
            iconColor: Colors.orange.shade400,
            title: '${S.of(context).wantBlockUser} $userName',
            content: S.of(context).youWontReceiveMessagesAnymore,
            cancelText: S.of(context).cancel,
            confirmText: S.of(context).blockUser,
            confirmButtonColor: Colors.orange.shade400,
            onConfirm: () {
              cubit
                  .blockChat(
                    BlockChatParameters(
                      conversationType: 1,
                      statues: 0,
                      conversationId: conversationId.toString(),
                    ),
                  )
                  .then((value) {
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  });
            },
          ),
    );
  }

  /// Shows an unblock user confirmation dialog
  static void showUnBlockDialog(
    BuildContext context, {
    required String userName,
    required ChatMessagesCubit cubit,
    required String conversationId,
  }) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(S.of(context).unblockUser),
            content: Text(
              '${S.of(context).areYouSureYouWantToUnblock} $userName',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(S.of(context).cancel),
              ),
              ElevatedButton(
                onPressed: () {
                  cubit
                      .blockChat(
                        BlockChatParameters(
                          conversationType: 1,
                          statues: 1,
                          conversationId: conversationId.toString(),
                        ),
                      )
                      .then((value) {
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      });
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text(
                  S.of(context).unblockUser,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  /// Shows a blocked profile information dialog
  static void showBlockedProfileDialog(
    BuildContext context, {
    required bool isBlockedByMe,
  }) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.red.shade50, Colors.orange.shade50],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.shade200,
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.block_rounded,
                      size: 50,
                      color: Colors.red.shade400,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    S.of(context).profileBlocked,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isBlockedByMe
                        ? S.of(context).youBlockedThisUserCannotViewProfile
                        : S.of(context).thisUserBlockedYouCannotViewProfile,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        S.of(context).okay,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  /// Shows a rename chat dialog
  static Future<List<dynamic>?> showRenameDialog(
    BuildContext context, {
    required String currentName,
    required ChatMessagesCubit cubit,
    required String conversationId,
    required String petId,
  }) {
    final TextEditingController controller = TextEditingController(
      text: currentName,
    );

    return showDialog<List<dynamic>>(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setDialogState) {
              bool isEmpty = controller.text.trim().isEmpty;

              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 8,
                backgroundColor: Colors.white,
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).renameChat,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: controller,
                        autofocus: true,
                        textAlign: TextAlign.start,
                        onChanged: (value) {
                          setDialogState(() {
                            isEmpty = value.trim().isEmpty;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: S.of(context).enterNewName,
                          filled: true,
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(
                              color: Colors.blue[400]!,
                              width: 2.0,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 14.0,
                          ),
                        ),
                      ),
                      if (isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                          child: Text(
                            S.of(context).nameCannotBeEmpty,
                            style: TextStyle(
                              color: Colors.red[600],
                              fontSize: 12,
                            ),
                          ),
                        ),
                      const SizedBox(height: 32),
                      DialogActionButtons(
                        cancelText: S.of(context).cancel,
                        confirmText: S.of(context).save,
                        onCancel: () => Navigator.of(context).pop(),
                        isConfirmEnabled: !isEmpty,
                        confirmColor: Colors.blue[600]!,
                        onConfirm: () {
                          String newName = controller.text.trim();
                          if (newName.isNotEmpty) {
                            cubit
                                .renameChat(
                                  RenameChatParameters(
                                    conversationId: conversationId,
                                    petId: petId,
                                    newName: newName,
                                    conversationType: 1,
                                  ),
                                )
                                .then((value) {
                                  if (!context.mounted) return;
                                  Navigator.pop(context, [value, newName]);
                                });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }

  /// Shows a clear chat confirmation dialog
  static void showClearChatDialog(
    BuildContext context, {
    required ChatMessagesCubit cubit,
    required String conversationId,
  }) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(Icons.pets, color: Colors.orange[700], size: 28),
                const SizedBox(width: 12),
                Expanded(child: Text(S.of(context).clearChatMessages)),
              ],
            ),
            content: Text(S.of(context).clearChatConfirmation),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[600],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                child: Text(S.of(context).cancel),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  cubit.clearMessages(
                    ClearChatParameters(
                      conversationId: conversationId,
                      onlyFromMe: true,
                    ),
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(
                              Icons.cleaning_services,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text('Clearing chat...'),
                          ],
                        ),
                        backgroundColor: Colors.orange[700],
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.delete_sweep, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      S.of(context).clearChat,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }

  /// Shows a finish mating dialog with status selection
  static void showFinishMatingDialog(
    BuildContext context, {
    required String matingId,
    required ChatMessagesCubit cubit,
  }) {
    final s = S.of(context);
    MatingCompleteStatues? selectedStatus;
    bool sharePost = true;

    final List<Map<String, dynamic>> statuses = [
      {
        'status': MatingCompleteStatues.complete,
        'title': s.completed,
        'description': 'Description for completed',
      },
      {
        'status': MatingCompleteStatues.notComplete,
        'title': s.not_completed,
        'description': 'Description for not completed',
      },
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.4,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    DialogHeader(
                      icon: Icons.pets,
                      iconColor: Theme.of(context).primaryColor,
                      title: s.update_pet_status,
                      onClose: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: statuses.length,
                        itemBuilder: (context, index) {
                          final statusData = statuses[index];
                          final status =
                              statusData['status'] as MatingCompleteStatues;

                          return StatusOptionWidget<MatingCompleteStatues>(
                            status: status,
                            selectedStatus: selectedStatus,
                            title: statusData['title'],
                            description: statusData['description'],
                            onTap:
                                (value) =>
                                    setState(() => selectedStatus = value),
                          );
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          s.sharePost,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const Spacer(),
                        Checkbox(
                          value: sharePost,
                          onChanged: (value) {
                            setState(() {
                              sharePost = value ?? false;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DialogActionButtons(
                      cancelText: s.cancel,
                      confirmText: s.finish,
                      onCancel: () => Navigator.of(context).pop(),
                      isConfirmEnabled: selectedStatus != null,
                      confirmColor: ColorManager.primaryColor,
                      onConfirm: () {
                        if (selectedStatus != null) {
                          cubit
                              .finishMating(
                                FinishMatingParameters(
                                  matingId: matingId,
                                  matingCompleteStatues: selectedStatus!,
                                  sharePost: sharePost,
                                ),
                              )
                              .then((value) {
                                if (!context.mounted) return;
                                Navigator.of(context).pop();
                              });
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
