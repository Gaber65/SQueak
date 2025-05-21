import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/appointments/domain/entities/doctor_entity.dart';

class DoctorDropdown extends StatelessWidget {
  final List<Doctor> doctors;
  final String? selectedDoctorId;
  final String? selectedDoctorImage;
  final String? selectedDoctorName;
  final Function(Doctor) onDoctorSelected;

  const DoctorDropdown({
    super.key,
    required this.doctors,
    this.selectedDoctorId,
    this.selectedDoctorImage,
    this.selectedDoctorName,
    required this.onDoctorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: Decorations.kDecorationBoxShadow(context: context),
        padding: const EdgeInsets.all(8.0),
        child: DropdownButton<Doctor>(
          onChanged: (newValue) {
            if (newValue != null) {
              onDoctorSelected(newValue);
            }
          },
          isExpanded: true,
          iconSize: 0.0,
          elevation: 0,
          menuMaxHeight: 200,
          icon: const SizedBox.shrink(),
          underline: const SizedBox(),
          hint: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  selectedDoctorName ?? (isArabic() ? 'اختر الطبيب' : 'Select doctor'),
                  style: FontStyleThame.textStyle(
                    context: context,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    selectedDoctorImage ??
                        'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?size=626&ext=jpg&uid=R78903714&ga=GA1.1.798062041.1678310296&semt=ais',
                  ),
                ),
              ],
            ),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          items: doctors.map((Doctor value) {
            return DropdownMenuItem<Doctor>(
              value: value,
              child: Row(
                children: [
                  Text(value.name),
                  Spacer(),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(value.image),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}