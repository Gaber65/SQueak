// ignore_for_file: deprecated_member_use
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/pets/presentation/view/pet_screen.dart';
import 'package:squeak/features/settings/persentaion/controller/setting_cubit.dart';
import '../../../../../core/utils/enums/profile_type.dart';
import '../../../domain/entities/profile_type_entity.dart';
import 'profile_switcher_item.dart';

/// Builds a shimmer placeholder for loading profiles
Widget buildProfileSwitcherShimmer(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final baseColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;
  final highlightColor = isDark ? Colors.grey[500]! : Colors.grey[100]!;

  return Shimmer.fromColors(
    baseColor: baseColor,
    highlightColor: highlightColor,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return ListTile(
          leading: CircleAvatar(radius: 24, backgroundColor: Colors.white30),
          title: Container(height: 12, width: 100, color: Colors.white30),
          subtitle: Container(
            height: 10,
            width: 60,
            margin: const EdgeInsets.only(top: 4),
            color: Colors.white30,
          ),
        );
      }),
    ),
  );
}

/// Builds the main Profile Switcher overlay
Widget buildProfileSwitcherOverlay({
  required BuildContext context,
  required LayerLink layerLink,
  required Animation<double> fade,
  required Animation<double> scale,
  required VoidCallback onClose,
}) {
  final petCubit = PetCubit.get(context);
  final pets = petCubit.pets;
  final owner = SettingCubit.get(context).profile;
  final switchProfileCubit = SwitchProfileCubit.get(context);

  final mq = MediaQuery.of(context);
  final targetWidth = mq.size.width * 0.9 > 400 ? 400 : 260;
  final maxListHeight = mq.size.height * 0.5;

  return Positioned(
    width: targetWidth.toDouble(),
    child: CompositedTransformFollower(
      link: layerLink,
      offset: Offset(isArabic() ? 10 : -150, 50),
      showWhenUnlinked: false,
      child: Material(
        color: Colors.transparent,
        child: FadeTransition(
          opacity: fade,
          child: ScaleTransition(
            scale: scale,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade900
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(blurRadius: 8, color: Colors.black26, offset: Offset(0, 4))
                ],
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: maxListHeight,
                  minWidth: 200,
                ),
                child: (pets.isEmpty && owner == null)
                    ? buildProfileSwitcherShimmer(context)
                    : ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    if (owner != null)
                      _buildProfileItem(
                        context,
                        title: owner.fullName,
                        subtitle: isArabic() ? "مالك الحساب" : "Profile owner",
                        image: imageUrl + (owner.imageName.isEmpty ? "" : owner.imageName),
                        onTap: () {
                          _switchProfileWithOverlay(
                            context,
                            switchProfileCubit,
                            ActiveProfile(type: ProfileType.user, user: owner),
                          );
                        },
                      ),
                    for (final pet in pets)
                      _buildProfileItem(
                        context,
                        title: pet.petName ?? "Pet",
                        subtitle: (pet.birthdate != null && pet.birthdate != '')
                            ? "${formatAge(DateTime.parse(pet.birthdate!.substring(0, 10)))}${pet.breed?.enBreed != null ? " • ${pet.breed!.enBreed}" : ""}"
                            : pet.breed?.enBreed ?? "",
                        image: imageUrl + (pet.imageName?.isNotEmpty == true ? pet.imageName! : ""),
                        onTap: () {
                          _switchProfileWithOverlay(
                            context,
                            switchProfileCubit,
                            ActiveProfile(type: ProfileType.pet, pet: pet),
                          );
                        },
                      ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.pets, color: Colors.blue),
                      title: Text(isArabic() ? " إدارة اصدقائك الصغار  " : "Manage Pets"),
                      onTap: () {
                        navigateToScreen(context, const PetScreen());
                        onClose();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

/// Builds individual profile items
Widget _buildProfileItem(
    BuildContext context, {
      required String title,
      required String subtitle,
      required String image,
      required VoidCallback onTap,
    }) {
  return ProfileSwitcherItem(title: title, subtitle: subtitle, image: image, onTap: onTap);
}

/// Safely switch profile and show temporary glass overlay
void _switchProfileWithOverlay(
    BuildContext context,
    SwitchProfileCubit switchCubit,
    ActiveProfile profile,
    ) {
  if (!context.mounted) return;

  switchCubit.switchProfile(profile);

  final overlay = Overlay.of(context);

  final entry = OverlayEntry(
    builder: (_) => Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: WidgetCircularAnimator(
          size: 200,
          innerIconsSize: 3,
          outerIconsSize: 3,
          innerAnimation: Curves.easeInOutBack,
          outerAnimation: Curves.easeInOutBack,
          innerColor: Colors.deepPurple,
          outerColor: Colors.orangeAccent,
          innerAnimationSeconds: 10,
          outerAnimationSeconds: 10,
          child: Container(
            height: 69,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
            child: CircleAvatar(
              backgroundColor: MainCubit.get(context).isDark ? Colors.black : Colors.white,
              backgroundImage: (switchCubit.image.isNotEmpty) ? NetworkImage(switchCubit.image) : null,
              child: switchCubit.image.isEmpty
                  ? Text(
                switchCubit.name,
                style: TextStyle(
                  color: MainCubit.get(context).isDark ? Colors.white : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
                  : null,
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(entry);

  // Remove overlay safely after 2 seconds
  Future.delayed(const Duration(seconds: 2), () {
    if (entry.mounted) entry.remove();
  });
}
