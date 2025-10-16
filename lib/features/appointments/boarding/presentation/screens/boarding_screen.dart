import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/appointments/boarding/domain/repositories/boarding_repository.dart';
import '../../../../pets/domain/entities/pet_entity.dart';
import '../../../../pets/presentation/controller/pet_cubit.dart';
import '../../../exam/presentation/view/appointments/booking/widget/pet_carousel.dart';
import '../../domain/entities/boarding_type_entity.dart';
import '../cubit/boarding_cubit.dart';
import '../cubit/boarding_state.dart';
import 'widgets/boarding_type_dropdown.dart';
import 'widgets/date_field_widget.dart';

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
    final DateFormat inputFormat = DateFormat(
      'yyyy-MM-dd HH:mm:ss.SSS',
      'en_US',
    );

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

TextEditingController entryDateController = TextEditingController(
  text: formatDateTime(DateTime.now()),
);
TextEditingController exitDateController = TextEditingController(
  text: formatDateTime(DateTime.now().add(Duration(days: 1))),
);

DateTime? selectedDateTime;
double? price;

class BoardingScreen extends StatefulWidget {
  const BoardingScreen({
    super.key,
    required this.clinicCode,
    this.petSelectFromIcon,
  });

  final String clinicCode;
  final PetEntities? petSelectFromIcon;

  @override
  State<BoardingScreen> createState() => _BoardingScreenState();
}

class _BoardingScreenState extends State<BoardingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _entryDateController = TextEditingController();
  final TextEditingController _exitDateController = TextEditingController();

  DateTime? entryDateTime;
  DateTime? exitDateTime;
  BoardingTypeEntity? selectedBoardingType;
  double calculatedCost = 0.0;
  PetEntities? petSelect;
  bool initTheSelectedPetValue = false;

  @override
  void initState() {
    super.initState();
    _initializeDates();
    context.read<BoardingCubit>().getBoardingTypes(widget.clinicCode);
  }

  void _initializeDates() {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));

    entryDateTime = now;
    exitDateTime = tomorrow;

    _entryDateController.text = _formatDateTime(now);
    _exitDateController.text = _formatDateTime(tomorrow);
  }

  String _formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('d/M/yyyy h:mm a', 'en_US');
    return formatter.format(dateTime);
  }

  void _calculateCost() {
    if (selectedBoardingType == null ||
        entryDateTime == null ||
        exitDateTime == null) {
      return;
    }

    final difference = exitDateTime!.difference(entryDateTime!);
    double cost = 0;

    if (selectedBoardingType!.unit == 1) {
      // Calculate by days
      int days = difference.inDays;
      days = days == 0 ? 1 : days;
      cost = days * (selectedBoardingType!.price as double);
    } else {
      // Calculate by hours
      int hours = difference.inHours;
      hours = hours == 0 ? 1 : hours;
      cost = hours * (selectedBoardingType!.price as double);
    }

    setState(() {
      calculatedCost = cost;
    });
  }

  void _onBoardingTypeChanged(BoardingTypeEntity boardingType) {
    setState(() {
      selectedBoardingType = boardingType;
    });
    _calculateCost();
  }

  void _onDateChanged(DateTime date, bool isEntryDate) {
    setState(() {
      if (isEntryDate) {
        entryDateTime = date;
        _entryDateController.text = _formatDateTime(date);
      } else {
        exitDateTime = date;
        _exitDateController.text = _formatDateTime(date);
      }
    });
    _calculateCost();
  }

  void _submitBoarding() {
    if (selectedBoardingType == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.of(context).selectBoarding)));
      return;
    }

    if (entryDateTime == null || exitDateTime == null) {
      return;
    }

    final difference = exitDateTime!.difference(entryDateTime!);
    var createParams = CreateBoardingParams(
      clinicCode: widget.clinicCode,
      entryDate: entryDateTime!.toUtc().toIso8601String(),
      existDate: exitDateTime!.toUtc().toIso8601String(),
      period: difference.inDays,
      comment: _commentController.text,
      boardingTypeId: selectedBoardingType!.id,
      vetICarePetId: petSelect!.petId ?? '',
    );
    context.read<BoardingCubit>().createBoarding(
      createParams, // This should come from selected pet
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BoardingCubit, BoardingState>(
      listener: (context, state) {
        if (state is CreateBoardingSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Boarding created successfully')),
          );
        } else if (state is CreateBoardingError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        var cubit = BoardingCubit.get(context);
        final petCubit = PetCubit.get(context);
        final pets = petCubit.pets;
        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: S.of(context).addComment,
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed:
                      state is CreateBoardingLoading ? null : _submitBoarding,
                  child:
                      state is CreateBoardingLoading
                          ? const CircularProgressIndicator()
                          : const Icon(IconlyLight.send),
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.petSelectFromIcon == null)
                      PetCarousel(
                        pets: pets,
                        onPetSelected: (firstPet) {
                          setState(() {
                            petSelect = firstPet;
                            initTheSelectedPetValue = true;
                          });
                        },
                        initializeFirstPet: !initTheSelectedPetValue,
                      ),
                    SizedBox(height: 16),
                    BoardingTypeDropdown(
                      boardingTypes: cubit.boardingTypes,
                      selectedBoardingType: selectedBoardingType,
                      onChanged: _onBoardingTypeChanged,
                    ),

                    const SizedBox(height: 16),

                    if (selectedBoardingType != null)
                      Text(
                        selectedBoardingType!.unit == 0
                            ? 'Hourly rate'
                            : 'Daily rate',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),

                    const SizedBox(height: 16),

                    DateFieldWidget(
                      title: isArabic() ? 'تاريخ الدخول' : 'Entry Date',
                      controller: _entryDateController,
                      selectedDateTime: entryDateTime,
                      boardingType: selectedBoardingType,
                      onDateChanged: (date) => _onDateChanged(date, true),
                    ),

                    const SizedBox(height: 16),

                    DateFieldWidget(
                      title: isArabic() ? 'تاريخ الخروج' : 'Exit Date',
                      controller: _exitDateController,
                      selectedDateTime: exitDateTime,
                      boardingType: selectedBoardingType,
                      onDateChanged: (date) => _onDateChanged(date, false),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      S.of(context).boardingPrice,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade200,
                      ),
                      child: Text(
                        selectedBoardingType == null
                            ? isArabic()
                                ? 'الرجاء تحديد نوع الإقامة'
                                : 'Please select boarding type'
                            : '\$${calculatedCost.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 100,
                    ), // Space for floating action button
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    _entryDateController.dispose();
    _exitDateController.dispose();
    super.dispose();
  }
}
