import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:squeak/core/constant/global_function/global_function.dart';
import 'package:squeak/core/helper/build_service/main_cubit/main_cubit.dart';
import 'package:squeak/core/thames/styles.dart';
import 'package:squeak/features/service/models/vaccination_entities.dart';
import '../../../../generated/l10n.dart';
import '../../../pets/models/pet_model.dart';
import '../../controller/vac_cubit/vaccination_cubit.dart';

class editMethod4 extends StatefulWidget {
  const editMethod4(
    this.cubit,
    this.index,
    this.model,
    this.commentController,
    this.petModel,
  );

  final VaccinationCubit cubit;

  final VaccinationModel model;
  final int index;

  final TextEditingController commentController;

  final PetsData petModel;

  @override
  State<editMethod4> createState() => _editMethod4State();
}

class _editMethod4State extends State<editMethod4> {
  String? currentDateItem;
  bool stateVac = false;
  @override
  void initState() {
    stateVac = widget.model.status;
    currentDateItem = widget.model.vacDate.substring(0, 10);
    super.initState();
  }

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        isArabic() ? " تحرير خدمة حيوانك الأليف" : "Edit Your Pet Service",
        style: FontStyleThame.textStyle(
            context: context, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width * 2,
        height: 390,
        child: Form(
          key: formKey,
          child: Scaffold(
            body: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Row(
                  children: [
                    Text(
                      isArabic() ? 'تغيير حالة التلقيح' : 'Change vac status ',
                      style: FontStyleThame.textStyle(
                        context: context,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Spacer(),
                    Switch(
                      value: stateVac,
                      onChanged: (value) {
                        stateVac = value;
                        setState(() {});
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(8),
                    color: MainCubit.get(context).isDark
                        ? Colors.black26
                        : Colors.grey.shade200,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.model.vaccination.vacName,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                buildSelectVac(context, widget.cubit),
                const SizedBox(height: 10),
                TextFormField(
                  controller: widget.commentController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    counterStyle: FontStyleThame.textStyle(
                      context: context,
                      fontSize: 13,
                    ),
                    hintStyle: FontStyleThame.textStyle(
                        context: context,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontColor: MainCubit.get(context).isDark
                            ? Colors.white54
                            : Color.fromRGBO(0, 0, 0, .3)),
                    hintText: isArabic()
                        ? 'الرجاء ادخال ملاحظة التلقيح'
                        : 'Please enter your vaccination comment',
                    filled: true,
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
                ),
                const SizedBox(height: 30),
              ],
            ),
            bottomNavigationBar: CustomElevatedButton(
              isLoading: widget.cubit.isEdit,
              formKey: formKey,
              onPressed: () {
                setState(() {});
                print(currentDateItem!);
                widget.cubit
                    .updateDate(
                  comments: widget.commentController.text,
                  vaccinationName: widget.model.vaccination.vacName,
                  petId: widget.petModel.petId,
                  index: widget.index,
                  data: currentDateItem!,
                  id: widget.model.id,
                  vaccinationTypeId: widget.model.vaccinationId,
                  statues: stateVac,
                )
                    .then((value) {
                  Navigator.pop(context);
                });
              },
              buttonText: S.of(context).edit,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> selectDate(
    BuildContext context,
  ) async {
    DateTime tomorrowDateItem = DateTime.now().add(const Duration(days: 1));

    final DateTime? pickedDate = await showDatePicker(
      initialDate: tomorrowDateItem,
      firstDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      lastDate: DateTime(2050),
      context: context,
    );
    if (pickedDate != null && pickedDate != currentDateItem) {
      DateFormat inputFormat = DateFormat('yyyy-MM-dd', "en_US");
      DateTime date = inputFormat.parse(pickedDate.toString().substring(0, 10));

      // Optionally, set a specific time if needed
      date = DateTime(date.year, date.month, date.day, 19, 21, 38, 999);

      // Step 2: Format the DateTime to the desired ISO 8601 format
      DateFormat outputFormat = DateFormat("yyyy-MM-dd", "en_US");
      currentDateItem = outputFormat.format(date.toUtc());
      setState(() {});
    }
  }

  Widget buildSelectVac(context, VaccinationCubit cubit) {
    return GestureDetector(
      onTap: () {
        selectDate(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(8),
          color: MainCubit.get(context).isDark
              ? Colors.black26
              : Colors.grey.shade200,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 8,
            right: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currentDateItem!,
              ),
              Icon(
                IconlyBold.calendar,
                color: ColorTheme.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
