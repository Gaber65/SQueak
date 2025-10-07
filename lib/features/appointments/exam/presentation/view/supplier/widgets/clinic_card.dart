// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/service/global_function/format_utils.dart';
import 'package:squeak/features/appointments/exam/domain/entities/clinic_entity.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/booking/booking_screen.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import 'package:squeak/features/pets/presentation/controller/pet_cubit.dart';
import 'package:squeak/features/appointments/exam/presentation/controller/clinic/appointment_cubit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'premium_avatar.dart';
import 'premium_info_row.dart';
import 'premium_primary_button.dart';
import 'premium_icon_button.dart';

class ClinicCard extends StatelessWidget {
  final ClinicInfo clinic;
  final PetEntities? petSelectFromIcon;

  const ClinicCard({super.key, required this.clinic, this.petSelectFromIcon});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme, isDark),
            const SizedBox(height: 16),
            PremiumInfoRow(
              icon: Icons.location_on_outlined,
              text: clinic.data.address,
              isDark: isDark,
            ),
            const SizedBox(height: 12),
            PremiumInfoRow(
              icon: Icons.phone_outlined,
              text: clinic.data.phone,
              isDark: isDark,
            ),
            const SizedBox(height: 20),
            BlocConsumer<PetCubit, PetState>(
              listener: (context, state) {
                // TODO: implement listener
              },
              builder: (context, state) {
                return ClinicActionsRow(
                  clinic: clinic,
                  petSelectFromIcon: petSelectFromIcon,
                  pets: PetCubit.get(context).pets,
                  isDark: isDark,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PremiumSupplierAvatar(clinic: clinic, isDark: isDark),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                clinic.data.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 18,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                clinic.data.specialities.isEmpty
                    ? (isArabic()
                        ? "رعاية بيطرية عامة"
                        : "General Veterinary Care")
                    : clinic.data.specialities.first.name,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              _buildCodeBadge(isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCodeBadge(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              isDark
                  ? [Colors.blue.shade800, Colors.blue.shade600]
                  : [Colors.blue.shade50, Colors.blue.shade100],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.blue.shade300.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        clinic.data.code,
        style: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.white : Colors.blue.shade800,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class ClinicActionsRow extends StatelessWidget {
  final ClinicInfo clinic;
  final PetEntities? petSelectFromIcon;
  final List<PetEntities> pets;
  final bool isDark;

  const ClinicActionsRow({
    super.key,
    required this.clinic,
    required this.petSelectFromIcon,
    required this.pets,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PremiumPrimaryButton(
          icon: Icons.event_available_rounded,
          label: isArabic() ? 'حجز موعد' : "Book Appointment",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => BookingScreen(
                      clinicCode: clinic.data.code,
                      petSelectFromIcon: petSelectFromIcon,
                      pets: pets,
                    ),
              ),
            );
          },
        ),
        const SizedBox(width: 10),
        PremiumIconButton(
          icon: Icons.call,
          color: Colors.green,
          isDark: isDark,
          onPressed: () {
            launchUrl(Uri.parse('tel:${clinic.data.phone}'));
          },
        ),
        const SizedBox(width: 10),
        PremiumIconButton(
          icon: Icons.person_remove,
          color: Colors.red,
          isDark: isDark,
          onPressed: () {
            showDialog(
              context: context,
              builder:
                  (context) => UnfollowConfirmationDialog(
                    onConfirm: () {
                      AppointmentCubit.get(
                        context,
                      ).unfollowClinicById(clinic.data.id, clinic: clinic);
                    },
                  ),
            );
          },
        ),
      ],
    );
  }
}

class UnfollowConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const UnfollowConfirmationDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isArabic() ? 'إلغاء المتابعة للعيادة' : 'Unfollow Clinic'),
      content: Text(
        isArabic()
            ? "هل تريد الغاء المتابعة لهذه العيادة؟"
            : 'Are you sure you want to unfollow this clinic?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(isArabic() ? 'إلغاء' : 'Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: Text(isArabic() ? 'إلغاء المتابعة' : 'Unfollow'),
        ),
      ],
    );
  }
}
