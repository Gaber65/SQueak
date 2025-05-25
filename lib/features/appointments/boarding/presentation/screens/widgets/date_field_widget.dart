import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import '../../../domain/entities/boarding_type_entity.dart';

class DateFieldWidget extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final DateTime? selectedDateTime;
  final BoardingTypeEntity? boardingType;
  final Function(DateTime) onDateChanged;

  const DateFieldWidget({
    super.key,
    required this.title,
    required this.controller,
    required this.selectedDateTime,
    required this.boardingType,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: () => _selectDateTime(context),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      controller.text.isEmpty ? 'Select date' : controller.text,
                      style: TextStyle(
                        color: controller.text.isEmpty 
                            ? Colors.grey.shade600 
                            : Colors.black,
                      ),
                    ),
                  ),
                  Icon(
                    IconlyLight.calendar,
                    color: Colors.grey.shade600,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      DateTime finalDateTime = pickedDate;

      // If boarding type is hourly, also pick time
      if (boardingType != null && boardingType!.unit == 0) {
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(selectedDateTime ?? DateTime.now()),
        );

        if (pickedTime != null) {
          finalDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        }
      }

      onDateChanged(finalDateTime);
    }
  }
}