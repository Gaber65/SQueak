import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/appointments/domain/entities/availability_entities.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../../../../core/utils/enums/dayOfWeek_enum.dart';

class CalendarScreen extends StatefulWidget {
  final bool isShowTime;
  final bool isShowDate;
  final List<Availability> timeSlotData;
  final OnDaySelected? onDaySelected;
  final DateTime? selectedDate;
  final Function(String)? onIntervalSelected;

  const CalendarScreen({
    super.key,
    required this.isShowTime,
    required this.isShowDate,
    required this.timeSlotData,
    this.onDaySelected,
    this.onIntervalSelected,
    this.selectedDate,
  });

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with TickerProviderStateMixin {
  DateTime? _selectedDate;
  Map<DayOfWeek, List<Availability>> _timeSlots = {};
  int? _selectedIntervalIndex;
  late AnimationController _animationController;
  late Animation<double> _animation;

  List<String> intervals = [];
  @override
  void initState() {
    super.initState();
    _fetchData(widget.timeSlotData);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    print(widget.selectedDate.toString() + '-----------------');

    if (widget.selectedDate != null) {
      _selectedDate = widget.selectedDate;
      print(_selectedDate.toString() + '-----------------');
      setState(() {});
      final slot =
          _timeSlots[DayOfWeek.values[(_selectedDate!.weekday - 1 + 7) % 7]]!
              .first;
      intervals = _generateHourlyIntervals(slot.startTime, slot.endTime);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchData(List<Availability> list) async {
    // Simulate API call

    final Map<DayOfWeek, List<Availability>> timeSlots = {};
    for (var item in list) {
      final dayOfWeek = DayOfWeek.values[(item.dayOfWeek.index + 6) % 7];
      final timeSlot = Availability(
        id: item.id,
        startTime: item.startTime,
        endTime: item.endTime,
        dayOfWeek: item.dayOfWeek,
        note: item.note,
        isActive: item.isActive,
      );

      if (!timeSlots.containsKey(dayOfWeek)) {
        timeSlots[dayOfWeek] = [];
      }
      timeSlots[dayOfWeek]!.add(timeSlot);
    }
    setState(() {
      _timeSlots = timeSlots;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.isShowDate) BuildCalendar(context),
        if (widget.isShowTime && _selectedDate != null) buildTimeSlots(),
      ],
    );
  }

  Padding BuildCalendar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: Decorations.kDecorationBoxShadow(context: context),
        child: TableCalendar(
          weekNumbersVisible: false,
          locale: 'en_US',
          focusedDay: _selectedDate ?? DateTime.now(),
          firstDay: DateTime.now(),
          lastDay: DateTime(2030),
          onFormatChanged: (format) {
            print('Calendar format changed to $format');
          },
          selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
          onDaySelected: (selectedDay, focusedDay) {
            widget.onDaySelected?.call(selectedDay, focusedDay);
            _selectedDate = selectedDay;
            final slot = _timeSlots[
                    DayOfWeek.values[(_selectedDate!.weekday - 1 + 7) % 7]]!
                .first;
            intervals = _generateHourlyIntervals(slot.startTime, slot.endTime);
            setState(() {});
          },
          calendarFormat: CalendarFormat.month,
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
          enabledDayPredicate: (day) {
            DayOfWeek dayOfWeek = DayOfWeek.values[(day.weekday - 1 + 7) % 7];
            return _timeSlots.containsKey(dayOfWeek);
          },
          calendarBuilders: CalendarBuilders(
            todayBuilder: (context, day, focusedDay) {
              return Container(
                margin: EdgeInsets.all(4.0),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              );
            },
            selectedBuilder: (context, day, focusedDay) {
              return Container(
                margin: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getDayColor(day),
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Color _getDayColor(DateTime day) {
    DayOfWeek dayOfWeek = DayOfWeek.values[(day.weekday - 1 + 7) % 7];
    return _timeSlots.containsKey(dayOfWeek)
        ? ColorManager.primaryColor
        : Colors.grey;
  }

  Widget buildTimeSlots() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: MediaQuery.of(context).size.width / 4.5,
        mainAxisExtent: 55,
        crossAxisSpacing: 0.0,
        mainAxisSpacing: 0.0,
      ),
      itemCount: intervals.length,
      itemBuilder: (context, intervalIndex) {
        final interval = intervals[intervalIndex];
        final isActive = _selectedIntervalIndex == intervalIndex;

        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Padding(
              padding: const EdgeInsets.all(6.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(8.0),
                onTap: () {
                  setState(() {
                    _selectedIntervalIndex = intervalIndex;
                  });
                  _animationController.forward().then((_) {
                    _animationController.reverse();
                  });
                  widget.onIntervalSelected?.call(interval);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  decoration: Decorations.kDecorationBoxShadow(
                    context: context,
                    color: isActive
                        ? ColorManager.primaryColor
                        : MainCubit.get(context).isDark
                            ? Colors.black54
                            : Colors.white,
                  ),
                  height: 30,
                  child: Center(
                    child: Text(
                      interval,
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            !isActive ? ColorManager.primaryColor : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<String> _generateHourlyIntervals(String startTime, String endTime) {
    final start = TimeOfDay(
      hour: int.parse(startTime.split(':')[0]),
      minute: int.parse(startTime.split(':')[1]),
    );
    final end = TimeOfDay(
      hour: int.parse(endTime.split(':')[0]),
      minute: int.parse(endTime.split(':')[1]),
    );

    List<String> intervals = [];
    TimeOfDay current = start;

    while (current.hour < end.hour ||
        (current.hour == end.hour && current.minute <= end.minute)) {
      final formattedHour = current.hour % 12 == 0 ? 12 : current.hour % 12;
      final period = current.hour < 12 ? 'AM' : 'PM';
      final formattedTime =
          '$formattedHour:${current.minute.toString().padLeft(2, '0')} $period';

      intervals.add(formattedTime);

      current = TimeOfDay(
        hour: (current.minute + 15) >= 60 ? current.hour + 1 : current.hour,
        minute: (current.minute + 15) % 60,
      );
    }

    print(intervals);
    return intervals;
  }
}

String convertTo24Hour(String time) {
  final parts = time.split(' ');
  final timePart = parts[0];
  final period = parts[1];

  final hourMinute = timePart.split(':');
  int hour = int.parse(hourMinute[0]);
  final minute = int.parse(hourMinute[1]);

  if (period == 'PM' && hour != 12) {
    hour += 12;
  } else if (period == 'AM' && hour == 12) {
    hour = 0;
  }
  return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}
