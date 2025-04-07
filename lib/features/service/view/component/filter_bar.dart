import 'package:flutter/material.dart';
import 'package:squeak/core/constant/global_function/global_function.dart';

import '../../../../core/helper/build_service/main_cubit/main_cubit.dart';
import '../../../../core/thames/styles.dart';
import 'package:intl/intl.dart';
class FilterBar extends StatefulWidget {
  final Function(String) onTypeFilterChanged;
  final Function(DateTime?) onDateFilterChanged;

  FilterBar({
    Key? key,
    required this.onTypeFilterChanged,
    required this.onDateFilterChanged,
  }) : super(key: key);

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                labelText: isArabic() ? 'تصفية حسب النوع' : 'Filter by Type',
                filled: true,
                counterStyle: FontStyleThame.textStyle(
                  context: context,
                  fontSize: 13,
                ),
                labelStyle: FontStyleThame.textStyle(
                    context: context,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontColor: MainCubit.get(context).isDark
                        ? Colors.white54
                        : Color.fromRGBO(0, 0, 0, .3)),
                fillColor: MainCubit.get(context).isDark
                    ? Colors.black26
                    : Colors.grey.shade200,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                focusColor: Colors.grey.shade200,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              menuMaxHeight: 200,
              items: [
                DropdownMenuItem(
                    value: 'all',
                    child: Text(
                      isArabic() ? 'الكل' : 'All Types',
                      style: FontStyleThame.textStyle(
                        context: context,
                        fontSize: 16,
                      ),
                    )),
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
                    value: 'birthday', child: Text(isArabic() ? 'عيد الميلاد' : 'Birthday')),
                DropdownMenuItem(
                    value: 'exercise', child: Text(isArabic() ? 'رياضة' : 'Exercise')),
                DropdownMenuItem(
                    value: 'buyFood', child: Text(isArabic() ? 'شراء الطعام' : 'Buy Food')),
                DropdownMenuItem(
                    value: 'other', child: Text(isArabic() ? 'أخرى' : 'Other')),
              ],
              onChanged: (value) => widget.onTypeFilterChanged(value!),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              controller: dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: isArabic() ? 'تصفية حسب التاريخ' : 'Filter by Date',
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                filled: true,

                counterStyle: FontStyleThame.textStyle(
                  context: context,
                  fontSize: 13,
                ),
                labelStyle: FontStyleThame.textStyle(
                    context: context,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontColor: MainCubit.get(context).isDark
                        ? Colors.white54
                        : Color.fromRGBO(0, 0, 0, .3)),
                fillColor: MainCubit.get(context).isDark
                    ? Colors.black26
                    : Colors.grey.shade200,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                focusColor: Colors.grey.shade200,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  dateController.text = DateFormat('yyyy-MM-dd').format(picked);
                  widget.onDateFilterChanged(picked);
                  setState(() {

                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
