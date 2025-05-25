import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/features/appointments/boarding/presentation/screens/widget/dropdown_baording_type.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';

import '../../../../../generated/l10n.dart';
import 'package:intl/intl.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import '../../domain/entities/boarding_type.dart';
import '../cubit/boarding_cubit.dart';



GlobalKey<FormState> formKey = GlobalKey();

String formatDateTime(DateTime dateTime) {
  final DateFormat formatter = DateFormat('d/M/yyyy h:mm a', 'en_US');
  return formatter.format(dateTime);
}

String formatDateTimeBoardingCreate(String dateString) {
  try {
    // Define the input date format
    final DateFormat inputFormat = DateFormat('dd/MM/yyyy h:mm a', 'en_US');

    // Parse the input date string
    final DateTime dateTime = inputFormat.parse(dateString);

    // Convert to ISO 8601 format (UTC)
    return dateTime.toUtc().toIso8601String();
  } catch (e) {
    final DateFormat inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSS', 'en_US');

    // Parse the input date string
    final DateTime dateTime = inputFormat.parse(dateString);

    // Convert to ISO 8601 format (UTC)
    return dateTime.toUtc().toIso8601String();
  }
}

Duration calculateDifference(entryDate, exitDate) {
  DateTime start = DateTime.parse(entryDate);
  DateTime end = DateTime.parse(exitDate);
  return end.difference(start);
}

TextEditingController entryDateController =
    TextEditingController(text: formatDateTime(DateTime.now()));
TextEditingController exitDateController = TextEditingController(
    text: formatDateTime(DateTime.now().add(Duration(days: 1))));

DateTime? selectedDateTime;
double? price;

class BoardingScreen extends StatefulWidget {
  const BoardingScreen({
    super.key,
    required this.clinicCode,
  });

  final String clinicCode;

  @override
  State<BoardingScreen> createState() => _BoardingScreenState();
}

class _BoardingScreenState extends State<BoardingScreen> {
  DateTime? entryDateTime;
  DateTime? exitDateTime;

  ClinicBoardEntity? selectedBoardingType;
  String? errorMessageType; // To track validation error
  final TextEditingController commentController = TextEditingController();

  Cage? selectedCageBoarding;
  String? errorMessageCage;
  @override
  void initState() {
    CacheHelper.saveData('boardingCost', '');
    price = null;
    setState(() {});
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BoardingCubit, BoardingState>(
      listener: (context, state) {
        if (state is CreateBoardingSuccess) {
          navigateAndFinish(context, LayoutScreen());
        }
      },
      builder: (context, state) {
        var cubit = BoardingCubit.get(context);
        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: commentController,
              style: FontStyleThame.textStyle(
                context: context,
                fontSize: 15,
              ),
              maxLines: 1,
              decoration: InputDecoration(
                hintText: S.of(context).addComment,
                contentPadding: EdgeInsetsDirectional.only(
                  start: 10,
                ),
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
                      : Colors.black54,
                ),
                suffixIcon: IconButton(
                  onPressed: cubit.isLoading
                      ? null
                      : () {
                          if (selectedBoardingType != null) {
                            var entryDate = formatDateTimeBoardingCreate(
                                entryDateTime == null
                                    ? entryDateController.text
                                    : entryDateTime.toString());
                            var exitDate = formatDateTimeBoardingCreate(
                                exitDateTime == null
                                    ? exitDateController.text
                                    : exitDateTime.toString());

                          } else {
                            infoToast(
                                context,
                                isArabic()
                                    ? 'من فضلك اختار نوع الاقامة'
                                    : 'Please select boarding type');
                          }
                        },
                  icon: cubit.isLoading
                      ? const CircularProgressIndicator()
                      : const Icon(IconlyLight.send),
                ),
                filled: true,
                fillColor: MainCubit.get(context).isDark
                    ? ColorManager.myPetsBaseBlackColor
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
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BoardingTypeDropdown(
                      cubit: cubit,
                      onBoardingTypeChanged: (boardingType, name) {
                        setState(() {
                          selectedBoardingType = boardingType;
                          errorMessageType = name;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    if (selectedBoardingType != null)
                      Text(
                        selectedBoardingType!.unit == 0
                            ? S.of(context).boardingTypeNoteHour
                            : S.of(context).boardingTypeNoteDay,
                        style: FontStyleThame.textStyle(
                          context: context,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontColor: Colors.grey.shade600,
                        ),
                      ),
                    SizedBox(height: 10),
                    buildDateField(
                      context: context,
                      title: isArabic() ? 'تاريخ الدخول' : 'Entry Date',
                      controller: entryDateController,
                      isEntryDate: true,
                    ),
                    SizedBox(height: 10),
                    SizedBox(width: 10),
                    buildDateField(
                      context: context,
                      title: isArabic() ? 'تاريخ الخروج' : 'Exit Date',
                      controller: exitDateController,
                      isEntryDate: false,
                    ),
                    SizedBox(height: 10),
                    Text(
                      S.of(context).boardingPrice,
                      style: FontStyleThame.textStyle(
                        context: context,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: MainCubit.get(context).isDark
                            ? Colors.black26
                            : Colors.grey.shade200,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Text(
                            "${CacheHelper.getData('boardingCost') is String ? isArabic() ? 'الرجاء تحديد نوع الإقامة' : "Please Select Boarding Type" : CacheHelper.getData('boardingCost')}",
                            style: FontStyleThame.textStyle(
                              context: context,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildDateField({
    required BuildContext context,
    required String title,
    required TextEditingController controller,
    required bool isEntryDate,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 52,
          decoration: Decorations.kDecorationBorder(
            borderRadius: BorderRadiusDirectional.circular(8),
            borderColor: MainCubit.get(context).isDark
                ? Colors.grey.shade800
                : Colors.grey.shade300,
            borderWidth: 1,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: InkWell(
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null) {
                    // Update selectedDateTime to pickedDate
                    selectedDateTime = pickedDate;

                    // If the boarding type is hourly, also pick the time
                    if (selectedBoardingType != null &&
                        selectedBoardingType!.unit == 0) {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                      );

                      if (pickedTime != null) {
                        selectedDateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      }
                      calculateCost(
                        entryDateTime,
                        exitDateTime,
                      );
                    }

                    // Update the controller text
                    if (selectedDateTime != null) {
                      controller.text = formatDateTime(selectedDateTime!);
                      if (isEntryDate) {
                        entryDateTime = selectedDateTime;
                      } else {
                        exitDateTime = selectedDateTime;
                      }

                      // Recalculate cost and update the state
                      calculateCost(
                        entryDateTime,
                        exitDateTime,
                      );
                      setState(() {});
                    }
                  }
                },
                child: TextFormField(
                  controller: controller,
                  enabled: false,
                  style: TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    border: InputBorder.none,
                    suffixIcon: Icon(
                      IconlyLight.calendar,
                      color: Colors.grey.shade600,
                      size: 18,
                    ),
                    hintText: 'D/M/YYYY H:MM M',
                    hintStyle:
                        TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  void calculateCost(
    DateTime? entryDateTime,
    DateTime? exitDateTime,
  ) {
    entryDateTime ??= DateTime.now();
    exitDateTime ??= DateTime.now().add(Duration(days: 1));

    Duration difference = exitDateTime.difference(entryDateTime);

    double calculatedCost = 0;

    if (selectedBoardingType != null && selectedBoardingType!.unit == 1) {
      // Calculate cost by days
      int numberOfDays = difference.inDays;
      numberOfDays =
          (numberOfDays == 0) ? 1 : numberOfDays; // Minimum charge for one day
      calculatedCost = numberOfDays * price!;
    } else {
      int numberOfHours = difference.inHours;
      numberOfHours = (numberOfHours == 0) ? 1 : numberOfHours;
      calculatedCost = numberOfHours * price!;
    }

    setState(() {
      calculatedCost;
      CacheHelper.saveData('boardingCost', calculatedCost);
    });
  }
}
