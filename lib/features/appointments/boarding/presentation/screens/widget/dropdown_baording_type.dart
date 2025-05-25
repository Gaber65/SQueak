import 'package:flutter/material.dart';
import '../../../../../../core/service/service_locator/locatore_export_path.dart';
import '../../../domain/entities/boarding_type.dart';
import '../../cubit/boarding_cubit.dart';
import '../boarding_screen.dart';

class BoardingTypeDropdown extends StatefulWidget {
  const BoardingTypeDropdown({
    super.key,
    required this.onBoardingTypeChanged, // Add callback
    required this.cubit, // Add callback
  });

  final BoardingCubit cubit;
  final Function(ClinicBoardEntity, String)onBoardingTypeChanged; // Updated callback type

  @override
  _BoardingTypeDropdownState createState() => _BoardingTypeDropdownState();
}

class _BoardingTypeDropdownState extends State<BoardingTypeDropdown> {
  ClinicBoardEntity? selectedBoardingType;
  String? errorMessage; // To track validation error

  @override
  Widget build(BuildContext context) {
    return Column(
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
            borderColor: MainCubit.get(context).isDark
                ? Colors.grey.shade800
                : Colors.grey.shade300,
            borderWidth: 1,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: PopupMenuButton<ClinicBoardEntity>(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height,
              ),
              offset: Offset(0, 60),
              child: Row(
                children: [
                  Text(selectedBoardingType?.name ??
                      S.of(context).selectBoarding),
                  const Spacer(),
                  Icon(Icons.keyboard_arrow_down_rounded),
                ],
              ),
              onSelected: (value) {
                selectedBoardingType = value; // Set selected value
                errorMessage = null; // Clear error on selection
                widget.onBoardingTypeChanged(value, value.name);
                price = value.price;
                entryDateController =
                    TextEditingController(text: formatDateTime(DateTime.now()));
                exitDateController = TextEditingController(
                    text:
                        formatDateTime(DateTime.now().add(Duration(days: 1))));

                calculateCost(
                  DateTime.now(),
                  DateTime.now().add(Duration(days: 1)),
                );
                setState(() {});
              },
              itemBuilder: (context) =>
                  widget.cubit.dummyClinicBoardEntities.map(
                (e) {
                  return PopupMenuItem<ClinicBoardEntity>(
                    value: e,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(e.name),
                    ),
                  );
                },
              ).toList(), // Convert the iterable to a List
            ),
          ),
        ),
        if (errorMessage != null) // Display error if validation fails
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorMessage!,
              style: TextStyle(color: Colors.red),
            ),
          ),
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
      // Calculate cost by hours
      int numberOfHours = difference.inHours;
      numberOfHours = (numberOfHours == 0)
          ? 1
          : numberOfHours; // Minimum charge for one hour
      calculatedCost = numberOfHours * price!;
    }

    setState(() {
      calculatedCost;
      CacheHelper.saveData('boardingCost', calculatedCost);
    });
  }
}
