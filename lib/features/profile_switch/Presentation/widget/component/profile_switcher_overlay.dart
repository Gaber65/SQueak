// ignore_for_file: deprecated_member_use
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/pets/presentation/view/pet_screen.dart';
import 'package:squeak/features/settings/persentaion/controller/setting_cubit.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';
import '../../../../../core/utils/enums/profile_type.dart';
import '../../../domain/entities/profile_type_entity.dart';
import 'profile_switcher_item.dart';

Widget buildProfileSwitcherShimmer(BuildContext context) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  final baseColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;
  final highlightColor = isDark ? Colors.grey[500]! : Colors.grey[100]!;

  return Shimmer.fromColors(
    baseColor: baseColor,
    highlightColor: highlightColor,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return ListTile(
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white.withOpacity(0.3),
          ),
          title: Container(
            height: 12,
            width: 100,
            color: Colors.white.withOpacity(0.3),
          ),
          subtitle: Container(
            height: 10,
            width: 60,
            margin: const EdgeInsets.only(top: 4),
            color: Colors.white.withOpacity(0.3),
          ),
        );
      }),
    ),
  );
}

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
  // Use a responsive width up to a cap and a larger max height for the list
  final targetWidth = (mq.size.width * 0.1).clamp(260.0, 400.0);
  final maxListHeight = mq.size.height * 0.5;

  return Positioned(
    width: targetWidth,
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
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade900
                        : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.black26,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Constrain the list height so only the dropdown content scrolls
                  // while taps outside still close the overlay.
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      // Make the dropdown take more height on larger screens
                      maxHeight: maxListHeight,
                      minWidth: 200,
                    ),
                    child:
                        (pets.isEmpty && owner == null)
                            ? buildProfileSwitcherShimmer(context)
                            : ListView(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              children: [
                                if (owner != null)
                                  ProfileSwitcherItem(
                                    title: owner.fullName,
                                    subtitle:
                                        isArabic()
                                            ? "مالك الحساب"
                                            : "Profile owner",
                                    image:
                                        imageUrl +
                                        (owner.imageName.isEmpty
                                            ? ""
                                            : owner.imageName),
                                    onTap: () {
                                      switchProfileCubit.switchProfile(
                                        ActiveProfile(
                                          type: ProfileType.user,
                                          user: owner,
                                        ),
                                      );
                                      final overlay = Overlay.of(context);
                                      final entry = buildGlassOverlay(context);
                                      overlay.insert(entry);
                                      Future.delayed(
                                        const Duration(seconds: 2),
                                        () {
                                          entry.remove();
                                        },
                                      );
                                      onClose();
                                    },
                                  ),
                                for (final pet in pets)
                                  ProfileSwitcherItem(
                                    title: pet.petName ?? "Pet",
                                    subtitle:
                                        (pet.birthdate != null &&
                                                pet.birthdate != '')
                                            ? "${formatAge(DateTime.parse(pet.birthdate!.substring(0, 10)))}${pet.breed?.enBreed != null ? " • ${pet.breed!.enBreed}" : ""}"
                                            : pet.breed?.enBreed ?? "",
                                    image:
                                        imageUrl +
                                        (pet.imageName?.isNotEmpty == true
                                            ? pet.imageName!
                                            : ""),
                                    onTap: () {
                                      switchProfileCubit.switchProfile(
                                        ActiveProfile(
                                          type: ProfileType.pet,
                                          pet: pet,
                                        ),
                                      );
                                      final overlay = Overlay.of(context);
                                      final entry = buildGlassOverlay(context);
                                      overlay.insert(entry);
                                      Future.delayed(
                                        const Duration(seconds: 2),
                                        () {
                                          entry.remove();
                                        },
                                      );
                                      onClose();
                                      Future.delayed(
                                        const Duration(seconds: 2),
                                        () {
                                          navigateAndFinish(
                                            // ignore: use_build_context_synchronously
                                            context,
                                            const LayoutScreen(),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                const Divider(height: 1),
                                ListTile(
                                  leading: const Icon(
                                    Icons.pets,
                                    color: Colors.blue,
                                  ),
                                  title: Text(
                                    isArabic()
                                        ? " إدارة اصدقائك الصغار  "
                                        : "Manage Pets",
                                  ),
                                  onTap: () {
                                    navigateToScreen(
                                      context,
                                      const PetScreen(),
                                    );
                                    onClose();
                                  },
                                ),
                              ],
                            ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

OverlayEntry buildGlassOverlay(BuildContext context) {
  var cubit = SwitchProfileCubit.get(context);

  return OverlayEntry(
    builder:
        (_) => Center(
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
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                child: CircleAvatar(
                  backgroundColor:
                      MainCubit.get(context).isDark
                          ? Colors.black
                          : Colors.white,
                  backgroundImage:
                      (cubit.image.isNotEmpty)
                          ? NetworkImage(cubit.image)
                          : null,
                  child:
                      (cubit.image.isEmpty)
                          ? Text(
                            cubit.name,
                            style: TextStyle(
                              color:
                                  MainCubit.get(context).isDark
                                      ? Colors.white
                                      : Colors.black,
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
}
