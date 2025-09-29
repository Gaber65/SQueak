import 'package:flutter/material.dart';

import 'package:squeak/features/appointments/exam/domain/entities/doctor_entity.dart';

import '../../../../../../../../core/service/global_function/format_utils.dart';
import '../../../../../../../../core/utils/theme/fonts/font_styles.dart';

class DoctorDropdown extends StatefulWidget {
  const DoctorDropdown({
    super.key,
    required this.doctors,
    required this.onDoctorSelected,
    this.isLoading = false,
  });

  final List<Doctor> doctors;
  final Function(Doctor) onDoctorSelected;
  final bool isLoading;

  @override
  State<DoctorDropdown> createState() => _DoctorDropdownState();
}

class _DoctorDropdownState extends State<DoctorDropdown> {
  String? selectedDoctorId;
  String? selectedDoctorImage;
  String? selectedDoctorName;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IgnorePointer(
        ignoring: widget.isLoading,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<Doctor>(
            isExpanded: true,
            items:
                widget.doctors.map((Doctor doctor) {
                  return DropdownMenuItem<Doctor>(
                    value: doctor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(doctor.image!),
                            radius: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(doctor.name),
                        ],
                      ),
                    ),
                  );
                }).toList(),
            onChanged: (Doctor? doctor) {
              if (doctor != null) {
                setState(() {
                  selectedDoctorId = doctor.id;
                  selectedDoctorImage = doctor.image;
                  selectedDoctorName = doctor.name;
                });
                widget.onDoctorSelected(doctor);
              }
            },
            hint: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    selectedDoctorName ??
                        (isArabic() ? 'اختر الطبيب' : 'Select doctor'),
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
          ),
        ),
      ),
    );
  }
}
