import 'package:equatable/equatable.dart';
import '../../../../core/utils/enums/dayOfWeek_enum.dart';

class Availability extends Equatable {
  final String id;
  final DayOfWeek dayOfWeek;
  final String startTime;
  final String endTime;
  final String note;
  final bool isActive;
  final bool isDisabled;

  const Availability({
    required this.id,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.note,
    required this.isActive,
    this.isDisabled = false,
  });

  @override
  List<Object?> get props => [
        id,
        dayOfWeek,
        startTime,
        endTime,
        note,
        isActive,
        isDisabled,
      ];
}