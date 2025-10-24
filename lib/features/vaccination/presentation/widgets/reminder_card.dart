// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/export_path/export_files.dart';
import '../../domain/entities/reminder_entity.dart';
import '../cubit/ui/vaccination_ui_cubit.dart';
import 'edit_reminder_dialog.dart';

class ReminderCard extends StatefulWidget {
  final ReminderEntity reminder;
  final String petId;

  const ReminderCard({
    super.key,
    required this.reminder,
    required this.petId,
  });

  @override
  State<ReminderCard> createState() => _ReminderCardState();
}

class _ReminderCardState extends State<ReminderCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Start pulse animation for upcoming reminders

  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<VaccinationUiCubit>();
    final size = MediaQuery.of(context).size;
    final isDarkMode = MainCubit.get(context).isDark;

    final reminderInfo = getReminderTypeInfo(widget.reminder.reminderType);
    final isUpcoming = _isUpcoming(widget.reminder.date, widget.reminder.time);
    final daysUntil = _getDaysUntil(widget.reminder.date, widget.reminder.time);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        child: _buildCard(context, cubit, size, isDarkMode, reminderInfo, isUpcoming, daysUntil),
        builder: (context, child) {
          return Transform.scale(
            scale: isUpcoming ? _pulseAnimation.value : 1.0,
            child: child,
          );
        },
      ),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
    );
  }

  Widget _buildCard(
      BuildContext context,
      VaccinationUiCubit cubit,
      Size size,
      bool isDarkMode,
      ReminderTypeInfo reminderInfo,
      bool isUpcoming,
      int daysUntil,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Dismissible(
        key: Key(widget.reminder.id.toString()),
        direction: DismissDirection.horizontal,
        background: _buildDismissBackground(true, isDarkMode),
        secondaryBackground: _buildDismissBackground(false, isDarkMode),
        confirmDismiss: (direction) => _handleDismiss(direction, context, cubit),
        child: GestureDetector(
          onTapDown: (_) {
            _animationController.forward();
          },
          onTapUp: (_) {
            _animationController.reverse();
          },
          onTapCancel: () {
            _animationController.reverse();
          },
          onTap: () => _showReminderDetails(context, widget.reminder, cubit),
          child: Container(
            height: size.height * 0.16,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: reminderInfo.color.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: isDarkMode
                      ? Colors.black.withOpacity(0.3)
                      : Colors.white.withOpacity(0.8),
                  blurRadius: 20,
                  offset: const Offset(0, -2),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                decoration: BoxDecoration(
                  gradient: _buildCardGradient(reminderInfo.color, isDarkMode, isUpcoming),
                ),
                child: Stack(
                  children: [
                    _buildBackgroundPattern(reminderInfo.color),
                    _buildCardContent(context, reminderInfo, isUpcoming, daysUntil, isDarkMode),
                    if (isUpcoming) _buildUrgencyIndicator(daysUntil),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDismissBackground(bool isEdit, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: isEdit
              ? [Colors.blue.shade400, Colors.blue.shade600]
              : [Colors.red.shade400, Colors.red.shade600],
          begin: isEdit ? Alignment.centerLeft : Alignment.centerRight,
          end: isEdit ? Alignment.centerRight : Alignment.centerLeft,
        ),
        boxShadow: [
          BoxShadow(
            color: (isEdit ? Colors.blue : Colors.red).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      alignment: isEdit ? Alignment.centerLeft : Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isEdit ? Icons.edit_rounded : Icons.delete_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isEdit
                ? (isArabic() ? "تعديل" : "Edit")
                : (isArabic() ? "حذف" : "Delete"),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _buildCardGradient(Color baseColor, bool isDarkMode, bool isUpcoming) {
    if (isDarkMode) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          baseColor.withOpacity(0.3),
          Colors.grey.shade900,
          baseColor.withOpacity(0.2),
        ],
        stops: const [0.0, 0.5, 1.0],
      );
    } else {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          baseColor.withOpacity(0.8),
          baseColor.withOpacity(0.6),
          baseColor.withOpacity(0.9),
        ],
        stops: const [0.0, 0.5, 1.0],
      );
    }
  }

  Widget _buildBackgroundPattern(Color color) {
    return Positioned.fill(
      child: RepaintBoundary(
        child: CustomPaint(
          painter: PatternPainter(color: color.withOpacity(0.1)),
        ),
      ),
    );
  }

  Widget _buildCardContent(
      BuildContext context,
      ReminderTypeInfo reminderInfo,
      bool isUpcoming,
      int daysUntil,
      bool isDarkMode,
      ) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          _buildIconSection(reminderInfo, isUpcoming),
          const SizedBox(width: 20),
          Expanded(
            child: _buildInfoSection(context, isUpcoming, daysUntil, isDarkMode),
          ),
          _buildActionSection(context, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildIconSection(ReminderTypeInfo reminderInfo, bool isUpcoming) {
    return Hero(
      tag: 'reminder_icon_${widget.reminder.id}',
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: reminderInfo.color.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              reminderInfo.icon,
              color: reminderInfo.color,
              size: 32,
            ),
            if (isUpcoming)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.5),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, bool isUpcoming, int daysUntil, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.reminder.reminderType == "other" ||
                    widget.reminder.reminderType == "أخرى"
                    ? widget.reminder.otherTitle.toString()
                    : widget.reminder.reminderType,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _buildStatusChip(isUpcoming, daysUntil),
          ],
        ),
        const SizedBox(height: 8),
        _buildDateTimeRow(),
      ],
    );
  }

  Widget _buildStatusChip(bool isUpcoming, int daysUntil) {
    Color chipColor;
    String chipText;

    if (isUpcoming) {
      if (daysUntil == 0) {
        chipColor = Colors.red;
        chipText = isArabic() ? "اليوم" : "Today";
      } else if (daysUntil == 1) {
        chipColor = Colors.orange;
        chipText = isArabic() ? "غداً" : "Tomorrow";
      } else if (daysUntil <= 7) {
        chipColor = Colors.amber;
        chipText = isArabic() ? "$daysUntil أيام" : "$daysUntil days";
      } else {
        chipColor = Colors.green;
        chipText = isArabic() ? "قادم" : "Upcoming";
      }
    } else {
      chipColor = Colors.grey;
      chipText = isArabic() ? "سابق" : "Past";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: chipColor.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        chipText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDateTimeRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                size: 14,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              Text(
                formatDateString(widget.reminder.date),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    formatTimeToAmPmReminder(widget.reminder.time),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _buildFrequencyRow(),
          ],
        ),
      ],
    );
  }

  Widget _buildFrequencyRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.repeat_rounded,
            size: 14,
            color: Colors.white70,
          ),
          const SizedBox(width: 4),
          Text(
            widget.reminder.reminderFreq,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionSection(BuildContext context, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.more_vert_rounded,
          color: Colors.white,
          size: 24,
        ),
        onPressed: () => _showReminderOptions(context, widget.reminder, context.read<VaccinationUiCubit>()),
        splashRadius: 20,
      ),
    );
  }

  Widget _buildUrgencyIndicator(int daysUntil) {
    if (daysUntil > 1) return const SizedBox.shrink();

    return Positioned(
      top: 12,
      right: 12,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: daysUntil == 0 ? Colors.red : Colors.orange,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (daysUntil == 0 ? Colors.red : Colors.orange).withOpacity(0.5),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          daysUntil == 0 ? Icons.priority_high_rounded : Icons.schedule_rounded,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }

  Future<bool?> _handleDismiss(DismissDirection direction, BuildContext context, VaccinationUiCubit cubit) async {
    if (direction == DismissDirection.startToEnd) {
      showEditReminderDialog(
        context: context,
        reminder: widget.reminder,
        petId: widget.petId,
        cubit: cubit,
      );
      return false;
    } else if (direction == DismissDirection.endToStart) {
      showCustomConfirmationDialog(
        context: context,
        description: isArabic()
            ? 'هل أنت متأكد أنك تريد حذف هذا الخدمة؟'
            : 'Are you sure you want to delete this service?',
        imageUrl: 'https://img.freepik.com/free-vector/emotional-support-animal-concept-illustration_114360-19462.jpg?t=st=1729767092~exp=1729770692~hmac=fe206337cc285fa3e223ab4e0326cd478bbb1497ff9a0b37543f9a46f4f23325&w=826',
        onConfirm: () {
          cubit.deleteReminder(reminder: widget.reminder, petId: widget.petId);
          Navigator.of(context).pop();
        },
      );
      return false;
    }
    return false;
  }

  void _showReminderDetails(BuildContext contextAll, ReminderEntity reminder, cubit) {
    final isDarkMode = MainCubit.get(contextAll).isDark;
    final reminderInfo = getReminderTypeInfo(reminder.reminderType);

    showModalBottomSheet(
      context: contextAll,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [Colors.grey.shade900, Colors.grey.shade800]
                : [Colors.white, Colors.grey.shade50],
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 24),
            _buildDetailHeader(context, reminder, reminderInfo, isDarkMode),
            const SizedBox(height: 24),
            _buildDetailsList(context, reminder, isDarkMode),
            const SizedBox(height: 32),
            _buildDetailActions(context, reminder, cubit, contextAll),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailHeader(BuildContext context, ReminderEntity reminder, ReminderTypeInfo reminderInfo, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            reminderInfo.color.withOpacity(0.1),
            reminderInfo.color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: reminderInfo.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Hero(
            tag: 'reminder_icon_${reminder.id}',
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: reminderInfo.color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                reminderInfo.icon,
                color: reminderInfo.color,
                size: 32,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reminder.reminderType == "other" || reminder.reminderType == "أخرى"
                      ? reminder.otherTitle.toString()
                      : reminder.reminderType,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isArabic() ? "لـ ${reminder.petName}" : "For ${reminder.petName}",
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsList(BuildContext context, ReminderEntity reminder, bool isDarkMode) {
    return Column(
      children: [
        _buildDetailItem(
          context,
          Icons.calendar_today_rounded,
          isArabic() ? "التاريخ" : "Date",
          formatDateString(reminder.date),
          isDarkMode,
        ),
        _buildDetailItem(
          context,
          Icons.access_time_rounded,
          isArabic() ? "الوقت" : "Time",
          formatTimeToAmPmReminder(reminder.time),
          isDarkMode,
        ),
        _buildDetailItem(
          context,
          Icons.repeat_rounded,
          isArabic() ? "التكرار" : "Frequency",
          reminder.reminderFreq,
          isDarkMode,
        ),
        if (reminder.notes != null && reminder.notes!.isNotEmpty)
          _buildDetailItem(
            context,
            Icons.note_rounded,
            isArabic() ? "ملاحظات" : "Notes",
            reminder.notes!,
            isDarkMode,
          ),
        if (reminder.subTypeFeed != null && reminder.subTypeFeed!.isNotEmpty)
          _buildDetailItem(
            context,
            Icons.restaurant_rounded,
            isArabic() ? "نوع الطعام" : "Feed Type",
            reminder.subTypeFeed!,
            isDarkMode,
          ),
      ],
    );
  }

  Widget _buildDetailItem(BuildContext context, IconData icon, String label, String value, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailActions(BuildContext context, ReminderEntity reminder, cubit, BuildContext contextAll) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            context,
            Icons.edit_rounded,
            isArabic() ? "تعديل" : "Edit",
            Colors.blue,
                () {
              Navigator.pop(context);
              showEditReminderDialog(
                context: context,
                reminder: reminder,
                petId: widget.petId,
                cubit: cubit,
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionButton(
            context,
            Icons.delete_rounded,
            isArabic() ? "حذف" : "Delete",
            Colors.red,
                () {
              Navigator.pop(context);
              showCustomConfirmationDialog(
                context: context,
                description: isArabic()
                    ? 'هل أنت متأكد أنك تريد حذف هذا الخدمة؟'
                    : 'Are you sure you want to delete this service?',
                imageUrl: 'https://img.freepik.com/free-vector/emotional-support-animal-concept-illustration_114360-19462.jpg?t=st=1729767092~exp=1729770692~hmac=fe206337cc285fa3e223ab4e0326cd478bbb1497ff9a0b37543f9a46f4f23325&w=826',
                onConfirm: () {
                  cubit.deleteReminder(reminder: reminder, matingRequestId: widget.petId);
                  Navigator.of(contextAll).pop();
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showReminderOptions(BuildContext contextAll, ReminderEntity reminder, cubit) {
    final isDarkMode = MainCubit.get(contextAll).isDark;

    showModalBottomSheet(
      context: contextAll,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [Colors.grey.shade900, Colors.grey.shade800]
                : [Colors.white, Colors.grey.shade50],
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 24),
            _buildOptionItem(
              context,
              Icons.visibility_rounded,
              isArabic() ? "عرض التفاصيل" : "View Details",
              Colors.blue,
                  () {
                Navigator.pop(context);
                _showReminderDetails(context, reminder, cubit);
              },
              isDarkMode,
            ),
            _buildOptionItem(
              context,
              Icons.edit_rounded,
              isArabic() ? "تعديل" : "Edit",
              Colors.green,
                  () {
                Navigator.pop(context);
                showEditReminderDialog(
                  context: context,
                  reminder: reminder,
                  petId: widget.petId,
                  cubit: cubit,
                );
              },
              isDarkMode,
            ),
            _buildOptionItem(
              context,
              Icons.delete_rounded,
              isArabic() ? "حذف" : "Delete",
              Colors.red,
                  () {
                Navigator.pop(context);
                showCustomConfirmationDialog(
                  context: context,
                  description: isArabic()
                      ? 'هل أنت متأكد أنك تريد حذف هذا الخدمة؟'
                      : 'Are you sure you want to delete this service?',
                  imageUrl: 'https://img.freepik.com/free-vector/emotional-support-animal-concept-illustration_114360-19462.jpg?t=st=1729767092~exp=1729770692~hmac=fe206337cc285fa3e223ab4e0326cd478bbb1497ff9a0b37543f9a46f4f23325&w=826',
                  onConfirm: () {
                    cubit.deleteReminder(reminder: reminder, matingRequestId: widget.petId);
                    Navigator.pop(contextAll);
                  },
                );
              },
              isDarkMode,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isUpcoming(String dateStr, String timeStr) {
    final reminderDateTime = combineDateAndTime(dateStr, timeStr);
    if (reminderDateTime == null) return false;

    return reminderDateTime.isAfter(DateTime.now());
  }

  DateTime? combineDateAndTime(String dateStr, String timeStr) {
    try {
      final date = DateTime.parse(dateStr);
      final timeParts = timeStr.split(":");
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      return DateTime(date.year, date.month, date.day, hour, minute);
    } catch (e) {
      // print("Error parsing data/time: $e");
      return null;
    }
  }

  int _getDaysUntil(String dateStr, String timeStr) {
    final reminderDateTime = combineDateAndTime(dateStr, timeStr);
    if (reminderDateTime == null) return 0;

    final now = DateTime.now();
    final reminderDateOnly = DateTime(reminderDateTime.year, reminderDateTime.month, reminderDateTime.day);
    final nowOnly = DateTime(now.year, now.month, now.day);

    final difference = reminderDateOnly.difference(nowOnly).inDays;
    return difference < 0 ? 0 : difference;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
}

// Custom painter for background pattern
class PatternPainter extends CustomPainter {
  final Color color;

  PatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const double spacing = 20;
    const double dotSize = 2;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotSize, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Helper functions (keep your existing ones)
String formatDateString(String date) {
  try {
    final dateTime = DateTime.parse(date);
    return DateFormat.yMMMd().format(dateTime);
  } catch (e) {
    return date;
  }
}

class ReminderTypeInfo {
  final IconData icon;
  final Color color;

  ReminderTypeInfo({required this.icon, required this.color});
}

ReminderTypeInfo getReminderTypeInfo(String reminderType) {
  switch (reminderType) {
    case 'Flea & Tick treatment':
    case 'علاج البراغيث والقراد':
      return ReminderTypeInfo(icon: Icons.bug_report_rounded, color: Colors.green);

    case 'Rabies':
    case 'داء الكلب':
      return ReminderTypeInfo(icon: Icons.pets_rounded, color: Colors.orange);

    case 'examination':
    case 'فحص':
      return ReminderTypeInfo(icon: Icons.medical_services_rounded, color: Colors.blue);

    case 'Vaccination':
    case 'التطعيم':
      return ReminderTypeInfo(icon: Icons.vaccines_rounded, color: Colors.purple);

    case 'other':
    case 'اخرى':
      return ReminderTypeInfo(icon: Icons.info_rounded, color: Colors.grey);

    case 'Buy Food':
    case 'شراء الطعام':
      return ReminderTypeInfo(icon: Icons.shopping_cart_rounded, color: Colors.amber);

    case 'Feed':
    case 'إطعام':
      return ReminderTypeInfo(icon: Icons.restaurant_rounded, color: Colors.deepOrange);

    case 'Clean Potty':
    case 'تنظيف الرمل':
      return ReminderTypeInfo(icon: Icons.cleaning_services_rounded, color: Colors.teal);

    case 'Grooming':
    case 'تهذيب أو عناية':
      return ReminderTypeInfo(icon: Icons.cut_rounded, color: Colors.pink);

    case 'Outdoor Walk':
    case 'المشي في الخارج':
      return ReminderTypeInfo(icon: Icons.directions_walk_rounded, color: Colors.indigo);

    case 'Deworming':
    case 'التخلص من الديدان':
      return ReminderTypeInfo(icon: Icons.local_hospital_rounded, color: Colors.red);

    default:
      return ReminderTypeInfo(icon: Icons.info_rounded, color: Colors.grey);
  }
}
