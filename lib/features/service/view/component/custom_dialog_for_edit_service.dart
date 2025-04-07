import 'package:flutter/material.dart';
import '../../../../core/constant/global_function/global_function.dart';
import '../../../../core/constant/global_widget/toast.dart';
import '../../models/reminder_model.dart';

class UpdateReminderDialog extends StatefulWidget {
  final ReminderModel reminder;
  final List<String> vacEntitiesData;

  const UpdateReminderDialog({
    Key? key,
    required this.reminder,
    required this.vacEntitiesData,
  }) : super(key: key);

  @override
  _UpdateReminderDialogState createState() => _UpdateReminderDialogState();
}

class _UpdateReminderDialogState extends State<UpdateReminderDialog> {
  late TextEditingController dateController;
  late TextEditingController timeController;
  late TextEditingController timeControllerAR;
  late TextEditingController notesController;
  late String selectedReminderType;

  @override
  void initState() {
    super.initState();
    dateController = TextEditingController(text: widget.reminder.date);
    timeController = TextEditingController(text: widget.reminder.time);
    timeControllerAR = TextEditingController(text: widget.reminder.timeAR);
    notesController = TextEditingController(text: widget.reminder.notes ?? '');
    selectedReminderType = widget.reminder.reminderType;
  }

  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isArabic() ? "تعديل التذكير" : "Edit Reminder"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Reminder Type Dropdown
          InkWell(
            onTap: () {
              // TODO: Implement dropdown logic if needed
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.05,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Center(child: Text(selectedReminderType)),
            ),
          ),
          TextField(
            keyboardType: TextInputType.datetime,
            controller: dateController,
            decoration:
                InputDecoration(labelText: isArabic() ? "التاريخ" : "Date"),
          ),
          TextField(
            keyboardType: TextInputType.datetime,
            controller: timeController,
            decoration:
                InputDecoration(labelText: isArabic() ? "الوقت" : "Time"),
          ),
          TextField(
            controller: notesController,
            decoration:
                InputDecoration(labelText: isArabic() ? "ملاحظات" : "Notes"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          // Return null if canceled
          child: Text(isArabic() ? "إلغاء" : "Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (dateController.text.isNotEmpty &&
                timeController.text.isNotEmpty) {
              ReminderModel updatedReminder = ReminderModel(
                id: widget.reminder.id,
                petId: widget.reminder.petId,
                reminderType: selectedReminderType,
                reminderFreq: widget.reminder.reminderFreq,
                date: dateController.text,
                time: timeController.text,
                notes: notesController.text,
                notificationID: widget.reminder.notificationID, petName: widget.reminder.petName, timeAR: timeControllerAR.text,
              );

              Navigator.of(context).pop(updatedReminder); // Return updated data
            } else {
              errorToast(
                  context,
                  isArabic()
                      ? "الرجاء اختيار التاريخ والوقت"
                      : "Please select the date and time");
            }
          },
          child: Text(isArabic() ? "حفظ" : "Save"),
        ),
      ],
    );
  }
}
