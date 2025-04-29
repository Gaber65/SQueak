import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/pets/data/models/pet_model.dart';

import 'package:squeak/features/service/view/component/reminder_wizard.dart';
import '../../models/reminder.dart';
import 'package:intl/intl.dart';

class ReminderCard extends StatelessWidget {
  final Reminder reminder;
  final Function remove;

  final PetData petModel;

  const ReminderCard({
    Key? key,
    required this.reminder,
    required this.remove,
    required this.petModel,
  }) : super(key: key);

  void _showReminderWizard(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => ReminderWizard(
        onReminderAdded: (p0) {},
        onReminderEdited: (p0) {
          editReminder(petModel.petId, p0);
        },
        petModel: petModel,
        existingReminder: reminder,
      ),
    );
  }

  List<Reminder> getRemindersForPet(String petId) {
    final storedData = CacheHelper.getData('remindersForPet$petId');

    if (storedData != null) {
      return storedData.map((jsonString) {
        return Reminder.fromJson(jsonDecode(jsonString));
      }).toList();
    }

    return [];
  }

  void editReminder(String petId, Reminder updatedReminder) {
    final reminders = getRemindersForPet(petId);

    final index =
        reminders.indexWhere((r) => r.hashCode == updatedReminder.hashCode);

    if (index != -1) {
      reminders[index] = updatedReminder;
      saveReminders(petId, reminders);
    }
  }

  void saveReminders(String petId, List<Reminder> reminders) {
    final jsonList = reminders.map((r) => jsonEncode(r.toJson())).toList();
    CacheHelper.saveData('remindersForPet$petId', jsonList);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        remove();
      },
      child: InkWell(
        onTap: () {
          _showReminderWizard(context);
        },
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTypeIndicator(),
                    _buildStatusIndicator(),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoSection(context),
                const SizedBox(height: 16),
                _buildDateTimeSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getTypeColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getTypeIcon(), color: _getTypeColor(), size: 18),
          const SizedBox(width: 6),
          Text(
            reminder.type.toString().split('.').last,
            style: TextStyle(
              color: _getTypeColor(),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    final isCompleted = reminder.status == 'done';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isCompleted ? Colors.green.shade200 : Colors.red.shade200,
        ),
      ),
      child: Text(
        isArabic()
            ? isCompleted
                ? 'مكتملة'
                : 'قيد الانتظار'
            : isCompleted
                ? 'Completed'
                : 'Pending',
        style: TextStyle(
          color: isCompleted ? Colors.green.shade700 : Colors.red.shade700,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildInfoSection(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        _buildInfoRow(
            Icons.notes_outlined,
            isArabic() ? 'ملاحظات' : 'Notes',
            reminder.note ?? (isArabic() ? 'لا يوجد ملاحظات' : 'No notes'),
            context),
      ],
    );
  }

  Widget _buildDateTimeSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDateTimeInfo(
              Icons.calendar_today_outlined, _formatDate(reminder.date)),
          _buildDateTimeInfo(Icons.access_time_outlined, reminder.time!),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getTypeColor() {
    switch (reminder.type) {
      case 'feed':
        return Colors.orange;
      case 'grooming':
        return Colors.blue;
      case 'pottyClean':
        return Colors.green;
      case 'rabies':
        return Colors.red;
      case 'fleaTickTreatment':
        return Colors.purple;
      case 'examination':
        return Colors.cyan;
      case 'vaccination':
        return Colors.teal;
      case 'deworming':
        return Colors.indigo;
      case 'outdoorWalk':
        return Colors.brown;
      case 'birthday':
        return Colors.pink;
      case 'exercise':
        return Colors.amber;
      case 'buyFood':
        return Colors.deepOrange;
      case 'other':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }

  IconData _getTypeIcon() {
    switch (reminder.type) {
      case 'feed':
        return Icons.restaurant_outlined;
      case 'grooming':
        return Icons.brush_outlined;
      case 'pottyClean':
        return Icons.cleaning_services_outlined;
      case 'rabies':
        return Icons.pets_outlined;
      case 'fleaTickTreatment':
        return Icons.bug_report_outlined;
      case 'examination':
        return Icons.medical_services_outlined;
      case 'vaccination':
        return Icons.vaccines_outlined;
      case 'deworming':
        return Icons.bug_report_outlined;
      case 'outdoorWalk':
        return Icons.directions_walk_outlined;
      case 'birthday':
        return Icons.cake_outlined;
      case 'exercise':
        return Icons.fitness_center_outlined;
      case 'buyFood':
        return Icons.shopping_cart_outlined;
      case 'other':
        return Icons.miscellaneous_services_outlined;
      default:
        return Icons.help_outline;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy', "en_US").format(date);
  }
}
