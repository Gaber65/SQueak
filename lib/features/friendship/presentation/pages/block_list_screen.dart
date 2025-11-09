import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/core/utils/enums/profile_type.dart';
import 'package:squeak/features/friendship/domain/entities/pet_friend_request_entity.dart';
import 'package:squeak/features/friendship/presentation/controllers/pet_friend_state.dart';
import 'package:squeak/features/friendship/presentation/widgets/profile_switch_notification_screen.dart';
import 'package:squeak/features/profile_switch/Presentation/cubit/switch_profile_state.dart';

import '../../../pets/domain/entities/pet_entity.dart';

class BlockedPetsScreen extends StatelessWidget {
  final String? petId;

  const BlockedPetsScreen({super.key, this.petId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<PetCubit>()..getOwnerPets(),
        ),
        BlocProvider(
          create: (context) => sl<PetFriendsCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<SwitchProfileCubit>()..loadProfile(),
        ),
      ],
      child: _BlockedPetsScreenContent(petId: petId),
    );
  }
}

class _BlockedPetsScreenContent extends StatefulWidget {
  final String? petId;

  const _BlockedPetsScreenContent({this.petId});

  @override
  State<_BlockedPetsScreenContent> createState() => _BlockedPetsScreenContentState();
}

class _BlockedPetsScreenContentState extends State<_BlockedPetsScreenContent> {
  String? _currentPetId;

  @override
  void initState() {
    super.initState();
    // Defer initialization until after the first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePetId();
    });
  }

  void _initializePetId() {
    try {
      final switchCubit = context.read<SwitchProfileCubit>();
      final activePet = switchCubit.activeProfile?.pet;

      if (activePet != null && activePet.petId != null) {
        _currentPetId = activePet.petId;
        _loadBlockedFriends();
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Error initializing pet ID: $e');
      }
    }
  }

  void _loadBlockedFriends() {
    if (_currentPetId != null) {
      PetFriendsCubit.get(context).loadBlockedFriends(petId: _currentPetId!);
    }
  }

void _showUnblockDialog(PetFriendRequestEntity friendRequest) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: isDarkMode ? const Color(0xFF1E1E2E) : Colors.white,
          title: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode 
                      ? const Color(0xFF6B4EFF).withOpacity(0.2)
                      : const Color(0xFF6B4EFF).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.pets,
                  color: const Color(0xFF6B4EFF),
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${S.of(context).unblock} ${friendRequest.friendPetName}?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              '${S.of(context).areYouSureYouWantToUnblockThisPet} ${friendRequest.friendPetName} ${S.of(context).ownedBy} ${friendRequest.friendName}? ${S.of(context).ableToInteract}',
              style: TextStyle(
                fontSize: 15,
                color: isDarkMode ? Colors.white70 : Colors.black87,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isDarkMode 
                              ? Colors.white24 
                              : Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: Text(
                      S.of(context).cancel,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_currentPetId != null) {
                        await PetFriendsCubit.get(context).unblockFriend(
                          PetEntities(
                            petId: friendRequest.friendPetId,
                            petName: friendRequest.friendPetName,
                          ),
                          _currentPetId!,
                        );
                        _loadBlockedFriends();
                      }
                      Navigator.of(dialogContext).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B4EFF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      S.of(context).unblock,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    return DateFormat('MMM dd, yyyy').format(date);
  }

  String _getImageUrl(String? imageName) {
    if (imageName == null || imageName.isEmpty) {
      return 'https://via.placeholder.com/150';
    }
    if (imageName.startsWith('http')) {
      return imageName;
    }
    return imageUrl + imageName;
  }

  String _calculateAgeShort(String? ageStr) {
    if (ageStr == null || ageStr.isEmpty) return S.of(context).unknown;
    final parsed = DateTime.tryParse(ageStr);
    if (parsed == null) {
      return ageStr.length > 12 ? '${ageStr.substring(0, 12)}...' : ageStr;
    }

    final now = DateTime.now();
    int years = now.year - parsed.year;
    if (now.month < parsed.month ||
        (now.month == parsed.month && now.day < parsed.day)) {
      years -= 1;
    }
    if (years > 0) return '$years ${S.of(context).years}';

    final months = (now.year - parsed.year) * 12 + now.month - parsed.month;
    if (months > 0) return '$months ${S.of(context).month}';

    final days = now.difference(parsed).inDays;
    if (days >= 0) return '$days ${S.of(context).days}';

    return S.of(context).unknown;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: isDark ? Colors.white : Color(0xFF2D3142),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          S.of(context).blockedPets,
          style: TextStyle(
            color: isDark ? Colors.white : Color(0xFF2D3142),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<SwitchProfileCubit, SwitchProfileState>(
        listener: (context, switchState) {
          try {
            final activePet = SwitchProfileCubit.get(context).activeProfile?.pet;
            if (activePet != null && activePet.petId != null && activePet.petId != _currentPetId) {
              if (mounted) {
                setState(() {
                  _currentPetId = activePet.petId;
                });
              } else {
                _currentPetId = activePet.petId;
              }
              // load blocked friends once we have the current pet id
              PetFriendsCubit.get(context).loadBlockedFriends(petId: _currentPetId!);
            }
          } catch (e) {
            if (kDebugMode) print('Error in SwitchProfile listener: $e');
          }
        },
        builder: (context, switchState) {
          final switchCubit = SwitchProfileCubit.get(context);
          final activeProfile = switchCubit.activeProfile;

          // Show profile switch notification if no profile or not a pet profile
          if (activeProfile == null || activeProfile.type != ProfileType.pet) {
            return const ProfileSwitchNotificationScreen();
          }

          // If we have a pet profile, show the blocked pets list
          return BlocBuilder<PetFriendsCubit, PetFriendsState>(
                builder: (context, state) {
                  if (state is BlockedFriendsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF6B4EFF),
                      ),
                    );
                  }
                  if (state is BlockedFriendsLoadFailed) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 60,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '${S.of(context).errorColon} : ${state.message}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadBlockedFriends,
                            child: Text(S.of(context).retry),
                          ),
                        ],
                      ),
                    );
                  }

                  final blockedFriends =
                      state is BlockedFriendsLoaded
                          ? state.blockedFriends
                          : <PetFriendRequestEntity>[];
                  if (blockedFriends.isEmpty) {
                    return _buildEmptyState();
                  }
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        color:
                            isDark
                                ? const Color(0xFF202020)
                                : const Color(0xFFF5F5F5),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFE5E5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.block,
                                color: Color(0xFFFF6B6B),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${blockedFriends.length} ${S.of(context).blocked}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          isDark
                                              ? const Color(0xFFFFFFFF)
                                              : const Color(0xFF2D3142),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    S.of(context).interactWithyourPet,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF9FA5C0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: blockedFriends.length,
                          itemBuilder: (context, index) {
                            final friendRequest = blockedFriends[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color:
                                    isDark
                                        ? const Color(0xFF252525)
                                        : const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap:
                                      () => _showUnblockDialog(friendRequest),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      children: [
                                        Hero(
                                          tag:
                                              'pet_${friendRequest.friendPetId}_$index',
                                          child: SizedBox(
                                            width: 70,
                                            height: 70,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Stack(
                                                fit: StackFit.expand,
                                                children: [
                                                  Image.network(
                                                    _getImageUrl(
                                                      friendRequest
                                                          .friendPetImage,
                                                    ),
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) => Container(
                                                          color: const Color(
                                                            0xFFECEFF6,
                                                          ),
                                                          child: const Icon(
                                                            Icons.pets,
                                                            color: Color(
                                                              0xFF9FA5C0,
                                                            ),
                                                            size: 36,
                                                          ),
                                                        ),
                                                    loadingBuilder: (
                                                      context,
                                                      child,
                                                      loadingProgress,
                                                    ) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return Container(
                                                        color: const Color(
                                                          0xFFF4F6FB,
                                                        ),
                                                        child: const Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                                color: Color(
                                                                  0xFF6B4EFF,
                                                                ),
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  Container(
                                                    color: Colors.black
                                                        .withOpacity(0.22),
                                                  ),
                                                  Center(
                                                    child: Icon(
                                                      Icons.block,
                                                      color:
                                                          isDark
                                                              ? Colors.white
                                                              : Colors.red,
                                                      size: 30,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                friendRequest.friendPetName,
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      isDark
                                                          ? Colors.white
                                                          : Color(0xFF2D3142),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.person_outline,
                                                    size: 14,
                                                    color: Color(0xFF9FA5C0),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Expanded(
                                                    child: Text(
                                                      friendRequest.friendName??'',
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Color(
                                                          0xFF9FA5C0,
                                                        ),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 3,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xFFE8E4FF,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      '${S.of(context).age}: ${_calculateAgeShort(friendRequest.friendPetAge)}',
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                        color: Color(
                                                          0xFF6B4EFF,
                                                        ),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 6),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.calendar_today,
                                                    size: 11,
                                                    color: Color(0xFF9FA5C0),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Expanded(
                                                    child: Text(
                                                      "${S.of(context).blockedAt}: ${_formatDate(friendRequest.blockedAt)}",
                                                      style: const TextStyle(
                                                        fontSize: 11,
                                                        color: Color(
                                                          0xFF9FA5C0,
                                                        ),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFF8D6D5),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: const Icon(
                                              Icons.block_outlined,
                                              color: Colors.red,
                                              size: 40,
                                            ),
                                          ),
                                          onPressed:
                                              () => _showUnblockDialog(
                                                friendRequest,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.pets, size: 60, color: Color(0xFF4CAF50)),
          ),
          const SizedBox(height: 24),
          Text(
            S.of(context).noPetsBlocked,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              S.of(context).youBlockedAnyPets,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF9FA5C0),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
