import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/features/appointments/boarding/domain/entities/boarding_status.dart';
import 'package:squeak/features/appointments/boarding/domain/entities/boarding_type_entity.dart';
import 'package:squeak/features/appointments/boarding/domain/repositories/boarding_repository.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';
import '../../domain/entities/boarding_entry_entity.dart';

import '../cubit/boarding_cubit.dart';
import '../cubit/boarding_state.dart';
import 'boarding_screen.dart';

class BoardingAgain extends StatefulWidget {
  const BoardingAgain({super.key, required this.entry});
  final BoardingEntryEntity entry;

  @override
  State<BoardingAgain> createState() => _BoardingAgainState();
}

class _BoardingAgainState extends State<BoardingAgain> {
  DateTime? entryDateTime;
  DateTime? exitDateTime;
  BoardingTypeEntity? selectedBoardingType;
  String? errorMessageType; // To track validation error
  @override
  void initState() {
    entryDateTime = widget.entry.entryDate;
    exitDateTime = widget.entry.existDate;
    selectedBoardingType = widget.entry.boardingType;
    commentController.text = widget.entry.comment;
    super.initState();
  }

  final TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              sl<BoardingCubit>()..getBoardingTypes(widget.entry.clinicCode),
      child: BlocConsumer<BoardingCubit, BoardingState>(
        listener: (context, state) {
          if (state is CreateBoardingSuccess) {
            LayoutCubit.get(context).changeBottomNav(3);
            navigateAndFinish(context, LayoutScreen());
          }
        },
        builder: (context, state) {
          var cubit = BoardingCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              title: Text(
                isArabic() ? 'تعديل الحجز' : 'Modify Booking',
                style: FontStyleThame.textStyle(context: context, fontSize: 20),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: commentController,
                style: FontStyleThame.textStyle(context: context, fontSize: 15),
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: S.of(context).addComment,
                  contentPadding: EdgeInsetsDirectional.only(start: 10),
                  counterStyle: FontStyleThame.textStyle(
                    context: context,
                    fontSize: 13,
                  ),
                  hintStyle: FontStyleThame.textStyle(
                    context: context,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontColor:
                        MainCubit.get(context).isDark
                            ? Colors.white54
                            : Colors.black54,
                  ),
                  suffixIcon: IconButton(
                    onPressed:
                        cubit.isLoading
                            ? null
                            : () {
                              if (selectedBoardingType != null) {
                                var entryDate = formatDateTimeBoardingCreate(
                                  entryDateTime == null
                                      ? entryDateController.text
                                      : entryDateTime.toString(),
                                );
                                var exitDate = formatDateTimeBoardingCreate(
                                  exitDateTime == null
                                      ? exitDateController.text
                                      : exitDateTime.toString(),
                                );
                                var editParams = EditBoardingParams(
                                  id: widget.entry.id,
                                  clinicCode: widget.entry.clinicCode,
                                  entryDate: entryDate,
                                  existDate: exitDate,
                                  period:
                                      calculateDifference(
                                        entryDate,
                                        exitDate,
                                      ).inDays,
                                  comment: commentController.text,
                                  boardingTypeId: selectedBoardingType!.id,
                                  vetICarePetId: widget.entry.petId,
                                  boardingStatus:
                                      BoardingStatusEnums.reserved.index,
                                );
                                cubit.editBoarding(editParams);
                              } else {
                                infoToast(
                                  context,
                                  isArabic()
                                      ? 'من فضلك اختار نوع الاقامة'
                                      : 'Please select boarding type',
                                );
                              }
                            },
                    icon:
                        cubit.isLoading
                            ? const CircularProgressIndicator()
                            : const Icon(IconlyLight.send),
                  ),
                  filled: true,
                  fillColor:
                      MainCubit.get(context).isDark
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).boardingType,
                            style: FontStyleThame.textStyle(
                              context: context,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            height: 60,
                            decoration: Decorations.kDecorationBorder(
                              borderRadius: BorderRadiusDirectional.circular(8),
                              borderColor:
                                  MainCubit.get(context).isDark
                                      ? Colors.grey.shade800
                                      : Colors.grey.shade300,
                              borderWidth: 1,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: PopupMenuButton<BoardingTypeEntity>(
                                constraints: BoxConstraints(
                                  maxHeight: MediaQuery.of(context).size.height,
                                ),
                                offset: Offset(0, 60),
                                child: Row(
                                  children: [
                                    Text(
                                      selectedBoardingType?.name ??
                                          S.of(context).selectBoarding,
                                    ),
                                    const Spacer(),
                                    Icon(Icons.keyboard_arrow_down_rounded),
                                  ],
                                ),
                                onSelected: (value) {
                                  selectedBoardingType =
                                      value; // Set selected value
                                  errorMessageType =
                                      null; // Clear error on selection
                                  price = value.price.toDouble();
                                  entryDateController = TextEditingController(
                                    text: formatDateTime(DateTime.now()),
                                  );
                                  exitDateController = TextEditingController(
                                    text: formatDateTime(
                                      DateTime.now().add(Duration(days: 1)),
                                    ),
                                  );

                                  calculateCost(
                                    DateTime.now(),
                                    DateTime.now().add(Duration(days: 1)),
                                  );
                                  setState(() {});
                                },
                                itemBuilder:
                                    (context) =>
                                        cubit.boardingTypes.map(
                                          (e) {
                                            return PopupMenuItem<BoardingTypeEntity>(
                                              value: e,
                                              child: SizedBox(
                                                width:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width,
                                                child: Text(e.name),
                                              ),
                                            );
                                          },
                                        ).toList(), // Convert the iterable to a List
                              ),
                            ),
                          ),
                          if (errorMessageType !=
                              null) // Display error if validation fails
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                errorMessageType!,
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                        ],
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
                          color:
                              MainCubit.get(context).isDark
                                  ? Colors.black26
                                  : Colors.grey.shade200,
                        ),
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                              right: 8.0,
                            ),
                            child: Text(
                              "${CacheHelper.getData('boardingCost') is String
                                  ? isArabic()
                                      ? 'الرجاء تحديد نوع الإقامة'
                                      : "Please Select Boarding Type"
                                  : CacheHelper.getData('boardingCost')}",
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
      ),
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
            borderColor:
                MainCubit.get(context).isDark
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
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                    firstDate: DateTime(2000),
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
                      calculateCost(entryDateTime, exitDateTime);
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
                      calculateCost(entryDateTime, exitDateTime);
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
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void calculateCost(DateTime? entryDateTime, DateTime? exitDateTime) {
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
