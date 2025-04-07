import 'package:flutter/material.dart';

import '../../../../core/constant/global_function/global_function.dart';
import '../../../../core/thames/styles.dart';
import '../../../pets/models/pet_model.dart';
import '../../models/reminder.dart';

class ReminderWizard extends StatefulWidget {
  final Function(Reminder) onReminderAdded;
  final Function(Reminder) onReminderEdited;
  final PetsData petModel;
  final Reminder? existingReminder; // To check if it's editing or adding.

  const ReminderWizard({
    Key? key,
    required this.onReminderAdded,
    required this.onReminderEdited,
    required this.petModel,
    this.existingReminder,
  }) : super(key: key);

  @override
  _ReminderWizardState createState() => _ReminderWizardState();
}

class _ReminderWizardState extends State<ReminderWizard> {
  late int _step = widget.existingReminder != null ? 2 : 1;
  String? _reminderType;
  String? _frequency;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _note = '';
  final TextEditingController _dateTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingReminder != null) {
      final reminder = widget.existingReminder!;
      _reminderType = reminder.type;
      _frequency = reminder.frequency;
      _selectedDate = reminder.date;
      _note = reminder.note ?? '';
      _dateTimeController.text =
          '${_selectedDate!.toLocal()}'.split(' ')[0] + 'at' + reminder.time;
    }
  }

  void _handleFinish() {
    if (_reminderType != null && _frequency != null && _selectedDate != null) {
      final newReminder = Reminder(
        type: _reminderType!,
        date: _selectedDate!,
        status: 'not done',
        time: _selectedTime!.format(context),
        note: _note,
        frequency: _frequency!,
        petModel: widget.petModel,
      );

      if (widget.existingReminder != null) {
        widget.onReminderEdited(newReminder); // Edit callback
      } else {
        widget.onReminderAdded(newReminder); // Add callback
      }

      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic()
                ? 'يرجى ملء جميع الحقول المطلوبة'
                : 'Please fill in all required fields',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isArabic()
          ? (widget.existingReminder != null ? 'تعديل تذكرة' : 'إضافة تذكرة')
          : (widget.existingReminder != null
              ? 'Edit Reminder'
              : 'Add Reminder')),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [_buildStep1(), _buildStep2()],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: _handleFinish,
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorTheme.primaryColor,
            foregroundColor: Colors.white,
          ),
          child: Text(
            isArabic()
                ? (widget.existingReminder != null ? 'تحديث' : 'إضافة تذكرة')
                : (widget.existingReminder != null ? 'Update' : 'Add Reminder'),
            style: FontStyleThame.textStyle(
              context: context,
              fontColor: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep1() {
    return DropdownButtonFormField<String>(
      decoration: inputDecoration(isArabic() ? 'نوع التذكرة' : 'Reminder Type'),
      value: _reminderType,
      menuMaxHeight: 200,
      items: [
        DropdownMenuItem(
            value: 'feed', child: Text(isArabic() ? 'طعام' : 'Feed')),
        DropdownMenuItem(
            value: 'grooming', child: Text(isArabic() ? 'تنظيف' : 'Grooming')),
        DropdownMenuItem(
            value: 'pottyClean',
            child: Text(isArabic() ? 'تنظيف المرحاض' : 'Clean Potty')),
        DropdownMenuItem(
            value: 'rabies', child: Text(isArabic() ? 'داء الكلب' : 'Rabies')),
        DropdownMenuItem(
            value: 'fleaTickTreatment',
            child: Text(isArabic()
                ? 'علاج البراغيث والقراد'
                : 'Flea & Tick Treatment')),
        DropdownMenuItem(
            value: 'examination',
            child: Text(isArabic() ? 'الفحص' : 'Examination')),
        DropdownMenuItem(
            value: 'vaccination',
            child: Text(isArabic() ? 'التطعيم' : 'Vaccination')),
        DropdownMenuItem(
            value: 'deworming',
            child: Text(isArabic() ? 'إزالة الديدان' : 'Deworming')),
        DropdownMenuItem(
            value: 'outdoorWalk',
            child: Text(isArabic() ? 'المشي في الخارج' : 'Outdoor Walk')),
        DropdownMenuItem(
            value: 'birthday',
            child: Text(isArabic() ? 'عيد الميلاد' : 'Birthday')),
        DropdownMenuItem(
            value: 'exercise', child: Text(isArabic() ? 'رياضة' : 'Exercise')),
        DropdownMenuItem(
            value: 'buyFood',
            child: Text(isArabic() ? 'شراء الطعام' : 'Buy Food')),
        DropdownMenuItem(
            value: 'other', child: Text(isArabic() ? 'أخرى' : 'Other')),
      ],
      onChanged: (value) => setState(() => _reminderType = value),
    );
  }

  Widget _buildStep2() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: inputDecoration(isArabic() ? 'التكرار' : 'Frequency'),
          value: _frequency,
          items: [
            DropdownMenuItem(
                value: 'once', child: Text(isArabic() ? 'مرة واحدة' : 'Once')),
            DropdownMenuItem(
                value: 'daily', child: Text(isArabic() ? 'يوميًا' : 'Daily')),
            DropdownMenuItem(
                value: 'weekly',
                child: Text(isArabic() ? 'أسبوعيًا' : 'Weekly')),
            DropdownMenuItem(
                value: 'monthly',
                child: Text(isArabic() ? 'شهريًا' : 'Monthly')),
            DropdownMenuItem(
                value: 'yearly', child: Text(isArabic() ? 'سنويًا' : 'Yearly')),
          ],
          onChanged: (value) => setState(() => _frequency = value),
        ),
        const SizedBox(height: 16),
        TextFormField(
          readOnly: true,
          controller: _dateTimeController,
          decoration: InputDecoration(
            labelText: isArabic() ? 'التاريخ والوقت' : 'Date & Time',
            suffixIcon: const Icon(Icons.calendar_today, size: 14),
            contentPadding: EdgeInsets.all(10),
            filled: true,
            labelStyle: FontStyleThame.textStyle(
              context: context,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontColor: Colors.black,
            ),
            fillColor: Colors.grey.shade200,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          onTap: () async {
            final DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: _selectedDate ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2101),
            );

            if (pickedDate != null) {
              final TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: _selectedTime ?? TimeOfDay.now(),
              );

              if (pickedTime != null) {
                setState(() {
                  _selectedDate = pickedDate;
                  _selectedTime = pickedTime;
                  _dateTimeController.text =
                      '${_selectedDate!.toLocal()}'.split(' ')[0] +
                          ' at ' +
                          _selectedTime!.format(context);
                });
              }
            }
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: inputDecoration(isArabic() ? 'ملاحظات' : 'Note'),
          maxLines: 3,
          onChanged: (value) => _note = value,
        ),
      ],
    );
  }

  InputDecoration inputDecoration(labelText) {
    return InputDecoration(
      labelText: labelText,
      contentPadding: EdgeInsets.all(10),
      filled: true,
      labelStyle: FontStyleThame.textStyle(
        context: context,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        fontColor: Colors.black,
      ),
      fillColor: Colors.grey.shade200,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }
}
