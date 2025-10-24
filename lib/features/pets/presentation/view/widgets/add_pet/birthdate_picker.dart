// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../../controller/pet_cubit.dart';

class BirthdatePicker extends StatelessWidget {
  const BirthdatePicker({super.key, required this.cubit, required this.isDark});

  final PetCubit cubit;
  final bool isDark;

  /// Calculates age from birthdate to current data
  String _calculateAge(String birthdate) {
    if (birthdate.isEmpty) {
      return isArabic() ? 'سيتم حسابه' : 'Age will be calculated';
    }

    try {
      final DateTime birthDate = DateTime.parse(birthdate);
      final DateTime currentDate = DateTime.now();

      int years = currentDate.year - birthDate.year;
      int months = currentDate.month - birthDate.month;
      int days = currentDate.day - birthDate.day;

      // Adjust for negative months or days
      if (days < 0) {
        months--;
        days += DateTime(currentDate.year, currentDate.month - 1, 0).day;
      }

      if (months < 0) {
        years--;
        months += 12;
      }

      // Format the age string
      if (years > 0) {
        return isArabic()
            ? '$years سنة و $months شهر'
            : '$years years, $months months';
      } else if (months > 0) {
        return isArabic()
            ? '$months شهر و $days يوم'
            : '$months months, $days days';
      } else {
        return isArabic() ? '$days يوم' : '$days days';
      }
    } catch (e) {
      return isArabic() ? 'سيتم حسابه' : 'Age will be calculated';
    }
  }

  /// Sets data by subtracting the specified months/years from current data
  void _setQuickDate(BuildContext context, int months) {
    final DateTime now = DateTime.now();
    // Subtract the specified months from current data
    final DateTime selectedDate = DateTime(
      now.year,
      now.month - months,
      now.day,
    );
    // Format data as YYYY-MM-DD and update the birthdate
    cubit.changeBirthdate(selectedDate.toString().substring(0, 10));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic() ? 'تاريخ الميلاد' : 'Date of Birth / Age',
          style: FontStyleThame.textStyle(
            context: context,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            fontColor: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        // Date picker and age display row
        Row(
          children: [
            // Date picker field
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        isDark
                            ? Colors.white.withOpacity(0.2)
                            : Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: InkWell(
                  onTap: () => _selectDate(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Icon(
                          Icons.calendar_today,
                          size: 20,
                          color:
                              isDark
                                  ? ColorManager.sWhite
                                  : ColorManager.black_87,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            cubit.birthdateController.text.isEmpty
                                ? (isArabic() ? 'اختر التاريخ' : 'MM/DD/YYYY')
                                : cubit.birthdateController.text,
                            style: FontStyleThame.textStyle(
                              context: context,
                              fontSize: 14,
                              fontColor:
                                  cubit.birthdateController.text.isEmpty
                                      ? (isDark ? Colors.white54 : Colors.grey)
                                      : isDark
                                      ? Colors.white
                                      : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Age display
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? Colors.blue.withOpacity(0.1)
                          : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        isDark
                            ? Colors.blue.withOpacity(0.3)
                            : Colors.blue.shade100,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    _calculateAge(cubit.birthdateController.text),
                    style: FontStyleThame.textStyle(
                      context: context,
                      fontSize: 14,
                      fontColor:
                          isDark ? Colors.blue.shade300 : Colors.blue.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Quick date selection buttons
        Row(
          children: [
            _buildQuickDateButton(
              context,
              isArabic() ? '6 شهور' : '6 months',
              6,
            ),
            const SizedBox(width: 8),
            _buildQuickDateButton(context, isArabic() ? 'سنة' : '1 year', 12),
            const SizedBox(width: 8),
            _buildQuickDateButton(
              context,
              isArabic() ? '3 سنوات' : '3 years',
              36,
            ),
            const SizedBox(width: 8),
            _buildQuickDateButton(
              context,
              isArabic() ? '5 سنوات' : '5 years',
              60,
            ),
          ],
        ),
      ],
    );
  }

  /// Builds a quick data selection button
  Widget _buildQuickDateButton(BuildContext context, String label, int months) {
    return Expanded(
      child: InkWell(
        onTap: () => _setQuickDate(context, months),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  isDark ? Colors.white.withOpacity(0.2) : Colors.grey.shade300,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: FontStyleThame.textStyle(
              context: context,
              fontSize: 12,
              fontColor: isDark ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  /// Opens data picker dialog and updates the birthdate
  Future<void> _selectDate(BuildContext context) async {
    // Use the currently selected birthdate if available, otherwise default
    // to today. This ensures the calendar opens at the selected data.
    DateTime initial = DateTime.now();
    try {
      if (cubit.birthdateController.text.isNotEmpty) {
        initial = DateTime.parse(cubit.birthdateController.text);
      }
    } catch (_) {
      initial = DateTime.now();
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      cubit.changeBirthdate(pickedDate.toString().substring(0, 10));
    }
  }
}
