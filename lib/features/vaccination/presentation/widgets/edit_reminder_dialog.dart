import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/export_path/export_files.dart';
import '../../domain/entities/reminder_entity.dart';
import '../cubit/ui/vaccination_ui_cubit.dart';
import 'form_components.dart';

class EditReminderDialog extends StatefulWidget {
  final ReminderEntity reminder;
  final String petId;
  final VaccinationUiCubit cubit;
  const EditReminderDialog({
    super.key,
    required this.reminder,
    required this.petId,
    required this.cubit,
  });

  @override
  State<EditReminderDialog> createState() => _EditReminderDialogState();
}

class _EditReminderDialogState extends State<EditReminderDialog> {
  late TextEditingController reminderTypeController;
  late TextEditingController dateController;
  late TextEditingController timeController;
  late TextEditingController timeControllerAR;
  late TextEditingController notesController;

  @override
  void initState() {
    super.initState();
    widget.cubit.pickedFromEdit = null;
    widget.cubit.newValueForDateInEdit = null;

    reminderTypeController = TextEditingController(
      text: widget.reminder.reminderType,
    );
    dateController = TextEditingController(text: widget.reminder.date);
    timeController = TextEditingController(text: widget.reminder.time);
    timeControllerAR = TextEditingController(text: widget.reminder.timeAR);
    notesController = TextEditingController(text: widget.reminder.notes ?? '');
    widget.cubit.currentFreqInEdit = widget.reminder.reminderFreq;
  }

  @override
  void dispose() {
    reminderTypeController.dispose();
    dateController.dispose();
    timeController.dispose();
    timeControllerAR.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String timeValue = timeController.text;
    List<String> timeParts = timeValue.split(":");
    TimeOfDay initTime = TimeOfDay(
      hour: int.parse(timeParts[0].trim()),
      minute: int.parse(timeParts[1].trim()),
    );

    return AlertDialog(
      title: Text(isArabic() ? "تعديل التذكير" : "Edit Reminder"),
      actionsPadding: const EdgeInsets.all(16.0),
      titlePadding: const EdgeInsets.all(16.0),
      contentPadding: const EdgeInsets.all(16.0),
      insetPadding: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: MainCubit.get(context).isDark ? Colors.grey[900] : Colors.white,
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.05,
              width: double.infinity,
              decoration: BoxDecoration(
                color:
                    MainCubit.get(context).isDark
                        ? Colors.black26
                        : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(child: Text(widget.reminder.reminderType)),
            ),
            const SizedBox(height: 10),
            widget.reminder.reminderType == "other" ||
                    widget.reminder.reminderType == "أخرى"
                ? Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color:
                        MainCubit.get(context).isDark
                            ? Colors.black26
                            : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(widget.reminder.otherTitle.toString()),
                  ),
                )
                : const SizedBox(),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                await widget.cubit.selectTimeFromEdit(context, initTime);
                setState(() {}); // Forces UI update
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: double.infinity,
                decoration: BoxDecoration(
                  color:
                      MainCubit.get(context).isDark
                          ? Colors.black26
                          : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child:
                      widget.cubit.pickedFromEdit != null
                          ? Text(
                            formatTimeToAmPmReminder(
                              "${widget.cubit.pickedFromEdit!.hour}:${widget.cubit.pickedFromEdit!.minute}",
                            ),
                          )

                          : Text(
                            formatTimeToAmPmReminder(
                              widget.reminder.time.toString(),
                            ),
                          ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SelectDateVacForEdit(
              cubit: widget.cubit,
              initDate: widget.cubit.takeStringReturnDateTime(
                widget.reminder.date,
              ),
            ),
            const SizedBox(height: 10),
            buildDropDownFreqForEdit(
              widget.cubit.reminderFreq,
              context,
              widget.cubit.currentFreqInEdit,
              widget.cubit,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                labelText: isArabic() ? "ملاحظات" : "Notes",
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(isArabic() ? "إلغاء" : "Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            final updatedReminder = ReminderEntity(
              id: widget.reminder.id,
              petId: widget.reminder.petId,
              reminderType: reminderTypeController.text,
              reminderFreq: widget.cubit.currentFreqInEdit,
              date:
                  widget.cubit.newValueForDateInEdit == null ||
                          widget.cubit.newValueForDateInEdit == ""
                      ? dateController.text
                      : widget.cubit.newValueForDateInEdit.toString().substring(
                        0,
                        10,
                      ),
              time:
                  widget.cubit.pickedFromEdit == null
                      ? isArabic()
                          ? timeControllerAR.text
                          : timeController.text
                      : isArabic()
                      ? "${widget.cubit.pickedFromEdit!.minute} : ${widget.cubit.pickedFromEdit!.hour}"
                      : "${widget.cubit.pickedFromEdit!.hour} : ${widget.cubit.pickedFromEdit!.minute}",
              notes:
              notesController.text,
              notificationID: widget.reminder.notificationID,
              subTypeFeed:
                  widget.reminder.subTypeFeed?.isEmpty ?? true
                      ? ""
                      : widget.reminder.subTypeFeed.toString(),
              petName: widget.reminder.petName,
              timeAR:
                  widget.cubit.pickedFromEdit == null
                      ? timeController.text
                      : "${widget.cubit.pickedFromEdit!.minute} : ${widget.cubit.pickedFromEdit!.hour}",
              otherTitle: widget.reminder.otherTitle,
            );
            await widget.cubit.updateReminder(reminder: updatedReminder);
            widget.cubit.loadPetReminders(widget.petId);
            if (mounted) {
              Navigator.of(context).pop();
            }
          },
          child: Text(isArabic() ? "حفظ" : "Save"),
        ),
      ],
    );
  }
}

class SelectDateVacForEdit extends StatefulWidget {
  final VaccinationUiCubit cubit;
  final DateTime initDate;

  const SelectDateVacForEdit({
    super.key,
    required this.cubit,
    required this.initDate,
  });

  @override
  _SelectDateVacForEditState createState() => _SelectDateVacForEditState();
}

class _SelectDateVacForEditState extends State<SelectDateVacForEdit> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text:
          widget.cubit.newValueForDateInEdit == null ||
                  widget.cubit.newValueForDateInEdit == ''
              ? widget.initDate.toString().substring(0, 10)
              : widget.cubit.newValueForDateInEdit.toString().substring(0, 10),
    );
  }

  void _updateDate() {
    setState(() {
      _controller.text =
          widget.cubit.newValueForDateInEdit == null ||
                  widget.cubit.newValueForDateInEdit == ''
              ? widget.initDate.toString().substring(0, 10)
              : widget.cubit.newValueForDateInEdit.toString().substring(0, 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await widget.cubit.selectDateOnEdit(context, widget.initDate);
        _updateDate(); // Ensure UI updates after date selection
      },
      child: IgnorePointer(
        child: MyTextForm(
          controller: _controller,
          enabled: false,
          prefixIcon: const Icon(Icons.calendar_month, size: 14),
          enable: false,
          hintText:
              isArabic()
                  ? 'من فضلك ادخل تاريخ الميلاد'
                  : 'Please enter date of birth',
          validatorText:
              isArabic()
                  ? 'من فضلك ادخل تاريخ الميلاد'
                  : 'Please enter date of birth',
          obscureText: false,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

void showEditReminderDialog({
  required BuildContext context,
  required ReminderEntity reminder,
  required String petId,
  required VaccinationUiCubit cubit,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return EditReminderDialog(reminder: reminder, petId: petId, cubit: cubit);
    },
  );
}
