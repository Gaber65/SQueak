import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/utils/export_path/export_files.dart';
import '../../../pets/domain/entities/pet_entity.dart';
import '../../domain/entities/reminder_entity.dart';
import '../cubit/ui/vaccination_ui_cubit.dart';
import 'reminder_card.dart';

class VaccinationList extends StatelessWidget {
  final PetEntities petModel;
  final List<ReminderEntity> reminders;

  const VaccinationList({
    super.key,
    required this.petModel,
    required this.reminders,
  });

  @override
  Widget build(BuildContext context) {
    return reminders.isNotEmpty
        ? ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 80), // Add padding for FAB
      itemBuilder: (context, index) {
        return ReminderCard(
          reminder: reminders[index],
          petId: petModel.petId,
        );
      },
      itemCount: reminders.length,
    )
        : _buildEmptyState(context);
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDarkMode = MainCubit.get(context).isDark;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Lottie.network(
            'https://lottie.host/b488a05f-1d87-4a5d-aa24-b4a95504f1f9/L0j5OguUTt.json',
            repeat: false,
            animate: true,
            height: 200,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          isArabic()
              ? "لم يتم العثور على خدمات ل${petModel.petName}"
              : 'No services found for ${petModel.petName}',
          textAlign: TextAlign.center,
          style: FontStyleThame.textStyle(
            context: context,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          isArabic()
              ? "اضغط على زر الإضافة لإنشاء تذكير جديد"
              : 'Tap the add button to create a new reminder',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton.icon(
          onPressed: () {
            context.read<VaccinationUiCubit>().changeBottomSheetShow(isShow: false);
          },
          icon: const Icon(Icons.add),
          label: Text(isArabic() ? "إضافة تذكير" : "Add Reminder"),
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorManager.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
