import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/export_path/export_files.dart';
import '../../domain/entities/reminder_entity.dart';
import '../cubit/ui/vaccination_ui_cubit.dart';
import 'edit_reminder_dialog.dart';

class ReminderCard extends StatelessWidget {
  final ReminderEntity reminder;
  final String petId;

  const ReminderCard({super.key, required this.reminder, required this.petId});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<VaccinationUiCubit>();
    final size = MediaQuery.of(context).size;
    final isDarkMode = MainCubit.get(context).isDark;

    // Get reminder type info
    final reminderInfo = getReminderTypeInfo(reminder.reminderType);
    final Color cardColor = reminderInfo.color.withOpacity(0.8);

    // Check if reminder is upcoming or past
    final isUpcoming = _isUpcoming(reminder.date);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Dismissible(
        key: Key(reminder.id.toString()),
        direction: DismissDirection.horizontal,
        background: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.green.shade300, Colors.green.shade700],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Icon(Icons.edit, color: Colors.white, size: 28),
              const SizedBox(width: 10),
              Text(
                isArabic() ? "تعديل" : "Edit",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        secondaryBackground: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.red.shade300, Colors.red.shade700],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                isArabic() ? "حذف" : "Delete",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.delete, color: Colors.white, size: 28),
            ],
          ),
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            // Edit action
            showEditReminderDialog(
              context: context,
              reminder: reminder,
              petId: petId,
              cubit: cubit,
            );
            return false; // Prevent dismissal
          } else if (direction == DismissDirection.endToStart) {
            // Delete action
            showCustomConfirmationDialog(
              context: context,
              description:
                  isArabic()
                      ? 'هل أنت متأكد أنك تريد حذف هذا الخدمة؟'
                      : 'Are you sure you want to delete this service?',
              imageUrl:
                  'https://img.freepik.com/free-vector/emotional-support-animal-concept-illustration_114360-19462.jpg?t=st=1729767092~exp=1729770692~hmac=fe206337cc285fa3e223ab4e0326cd478bbb1497ff9a0b37543f9a46f4f23325&w=826',
              onConfirm: () {
                cubit.deleteReminder(reminder: reminder, petId: petId);
                Navigator.of(context).pop();
              },
            );
            return false;
          }
          return false;
        },
        child: Container(
          height: size.height * 0.14,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [cardColor, cardColor.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: cardColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Show reminder details
                  _showReminderDetails(context, reminder, cubit);
                },
                splashColor: Colors.white.withOpacity(0.1),
                highlightColor: Colors.white.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Left side - Icon in a circle
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            reminderInfo.icon,
                            color: cardColor,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Middle - Reminder info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Title with status indicator
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    reminder.reminderType == "other" ||
                                            reminder.reminderType == "أخرى"
                                        ? reminder.otherTitle.toString()
                                        : reminder.reminderType,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color:
                                          isDarkMode
                                              ? Colors.white
                                              : Colors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isUpcoming ? Colors.green : Colors.grey,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    isUpcoming
                                        ? (isArabic() ? "قادم" : "Upcoming")
                                        : (isArabic() ? "سابق" : "Past"),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Date and time
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  formatDateString(reminder.date),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  formatTimeToAmPmReminder(reminder.time),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 4),

                            // Frequency
                            Row(
                              children: [
                                const Icon(
                                  Icons.repeat,
                                  size: 14,
                                  color: Colors.white70,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  reminder.reminderFreq,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Right side - Actions
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _showReminderOptions(context, reminder, cubit);
                            },
                          ),
                        ],
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

  void _showReminderDetails(
    BuildContext contextAll,
    ReminderEntity reminder,
    cubit,
  ) {
    final isDarkMode = MainCubit.get(contextAll).isDark;
    final reminderInfo = getReminderTypeInfo(reminder.reminderType);

    showModalBottomSheet(
      context: contextAll,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[900] : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: reminderInfo.color.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        reminderInfo.icon,
                        color: reminderInfo.color,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reminder.reminderType == "other" ||
                                    reminder.reminderType == "أخرى"
                                ? reminder.otherTitle.toString()
                                : reminder.reminderType,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          Text(
                            isArabic()
                                ? "لـ ${reminder.petName}"
                                : "For ${reminder.petName}",
                            style: TextStyle(
                              color:
                                  isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildDetailItem(
                  context,
                  Icons.calendar_today,
                  isArabic() ? "التاريخ" : "Date",
                  formatDateString(reminder.date),
                ),
                _buildDetailItem(
                  context,
                  Icons.access_time,
                  isArabic() ? "الوقت" : "Time",
                  formatTimeToAmPmReminder(reminder.time),
                ),
                _buildDetailItem(
                  context,
                  Icons.repeat,
                  isArabic() ? "التكرار" : "Frequency",
                  reminder.reminderFreq,
                ),
                if (reminder.notes != null && reminder.notes!.isNotEmpty)
                  _buildDetailItem(
                    context,
                    Icons.note,
                    isArabic() ? "ملاحظات" : "Notes",
                    reminder.notes!,
                  ),
                if (reminder.subTypeFeed != null &&
                    reminder.subTypeFeed!.isNotEmpty)
                  _buildDetailItem(
                    context,
                    Icons.restaurant,
                    isArabic() ? "نوع الطعام" : "Feed Type",
                    reminder.subTypeFeed!,
                  ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      context,
                      Icons.edit,
                      isArabic() ? "تعديل" : "Edit",
                      Colors.blue,
                      () {
                        Navigator.pop(context);
                        showEditReminderDialog(
                          context: context,
                          reminder: reminder,
                          petId: petId,
                          cubit: cubit,
                        );
                      },
                    ),
                    _buildActionButton(
                      context,
                      Icons.delete,
                      isArabic() ? "حذف" : "Delete",
                      Colors.red,
                      () {
                        Navigator.pop(context);
                        showCustomConfirmationDialog(
                          context: context,
                          description:
                              isArabic()
                                  ? 'هل أنت متأكد أنك تريد حذف هذا الخدمة؟'
                                  : 'Are you sure you want to delete this service?',
                          imageUrl:
                              'https://img.freepik.com/free-vector/emotional-support-animal-concept-illustration_114360-19462.jpg?t=st=1729767092~exp=1729770692~hmac=fe206337cc285fa3e223ab4e0326cd478bbb1497ff9a0b37543f9a46f4f23325&w=826',
                          onConfirm: () {

                            cubit.deleteReminder(
                              reminder: reminder,
                              petId: petId,
                            );
                            Navigator.of(contextAll).pop();

                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final isDarkMode = MainCubit.get(context).isDark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 5),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }

  void _showReminderOptions(
    BuildContext contextAll,
    ReminderEntity reminder,
    cubit,
  ) {
    final isDarkMode = MainCubit.get(contextAll).isDark;

    showModalBottomSheet(
      context: contextAll,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[900] : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),
                _buildOptionItem(
                  context,
                  Icons.visibility,
                  isArabic() ? "عرض التفاصيل" : "View Details",
                  () {
                    Navigator.pop(context);
                    _showReminderDetails(context, reminder, cubit);
                  },
                ),
                _buildOptionItem(
                  context,
                  Icons.edit,
                  isArabic() ? "تعديل" : "Edit",
                  () {
                    Navigator.pop(context);
                    showEditReminderDialog(
                      context: context,
                      reminder: reminder,
                      petId: petId,
                      cubit: cubit,
                    );
                  },
                ),
                _buildOptionItem(
                  context,
                  Icons.delete,
                  isArabic() ? "حذف" : "Delete",
                  () {
                    Navigator.pop(context);
                    showCustomConfirmationDialog(
                      context: context,
                      description:
                          isArabic()
                              ? 'هل أنت متأكد أنك تريد حذف هذا الخدمة؟'
                              : 'Are you sure you want to delete this service?',
                      imageUrl:
                          'https://img.freepik.com/free-vector/emotional-support-animal-concept-illustration_114360-19462.jpg?t=st=1729767092~exp=1729770692~hmac=fe206337cc285fa3e223ab4e0326cd478bbb1497ff9a0b37543f9a46f4f23325&w=826',
                      onConfirm: () {

                        cubit.deleteReminder(
                          reminder: reminder,
                          petId: petId,
                        );
                        Navigator.pop(contextAll);

                      },
                    );
                  },
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildOptionItem(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    final isDarkMode = MainCubit.get(context).isDark;

    return ListTile(
      leading: Icon(
        icon,
        color: isDarkMode ? Colors.white70 : Colors.grey[700],
      ),
      title: Text(
        label,
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
      ),
      onTap: onTap,
    );
  }

  bool _isUpcoming(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      return date.isAfter(now) ||
          date.day == now.day &&
              date.month == now.month &&
              date.year == now.year;
    } catch (e) {
      return false;
    }
  }
}

// Helper function to format date string
String formatDateString(String date) {
  try {
    final dateTime = DateTime.parse(date);
    return DateFormat.yMMMd().format(dateTime);
  } catch (e) {
    return date;
  }
}

// Helper class for reminder type info
class ReminderTypeInfo {
  final IconData icon;
  final Color color;

  ReminderTypeInfo({required this.icon, required this.color});
}

// Helper function to get reminder type info
ReminderTypeInfo getReminderTypeInfo(String reminderType) {

  switch (reminderType) {
    case 'Flea & Tick treatment':
    case 'علاج البراغيث والقراد':
      return ReminderTypeInfo(icon: Icons.bug_report, color: Colors.green);

    case 'Rabies':
    case 'داء الكلب':
      return ReminderTypeInfo(icon: Icons.pets, color: Colors.orange);

    case 'examination':
    case 'فحص':
      return ReminderTypeInfo(icon: Icons.medical_services, color: Colors.blue);

    case 'Vaccination':
    case 'التطعيم':
      return ReminderTypeInfo(icon: Icons.vaccines, color: Colors.purple);

    case 'other':
    case 'اخرى':
      return ReminderTypeInfo(icon: Icons.info, color: Colors.grey);

    case 'Buy Food':
    case 'شراء الطعام':
      return ReminderTypeInfo(icon: Icons.shopping_cart, color: Colors.amber);

    case 'Feed':
    case 'إطعام':
      return ReminderTypeInfo(icon: Icons.restaurant, color: Colors.deepOrange);

    case 'Clean Potty':
    case 'تنظيف الرمل':
      return ReminderTypeInfo(
        icon: Icons.cleaning_services_rounded,
        color: Colors.teal,
      );

    case 'Grooming':
    case 'تهذيب أو عناية':
      return ReminderTypeInfo(icon: Icons.cut, color: Colors.pink);

    case 'Outdoor Walk':
    case 'المشي في الخارج':
      return ReminderTypeInfo(
        icon: Icons.directions_walk,
        color: Colors.indigo,
      );

    case 'Deworming':
    case 'التخلص من الديدان':
      return ReminderTypeInfo(icon: Icons.local_hospital, color: Colors.red);

    default:
      return ReminderTypeInfo(icon: Icons.info, color: Colors.grey);
  }
}

