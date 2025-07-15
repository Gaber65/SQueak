import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/appointments/exam/domain/entities/appointment_entity.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/book_again_screen.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/rate_appointment.dart';
import 'package:squeak/features/appointments/exam/presentation/view/files_and_prescription_for_pet/files_for_pet_screen.dart';
import 'package:squeak/features/appointments/exam/presentation/view/files_and_prescription_for_pet/prescription_for_pet_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/user/user_appointment_cubit.dart';

enum AppointmentState {
  Reserved,         // 0
  Start_Examination, // 1
  End_Examination,   // 2
  Finished,         // 3
  Attended,         // 4
  Cancel           // 5
}

class BeautifulAppointmentCard extends StatefulWidget {
  final AppointmentEntity appointment;
  final UserAppointmentCubit cubit;
  final int index;
  final bool isDarkMode;

  const BeautifulAppointmentCard({
    super.key,
    required this.appointment,
    required this.cubit,
    required this.index,
    this.isDarkMode = false,
  });

  @override
  State<BeautifulAppointmentCard> createState() => _BeautifulAppointmentCardState();
}

class _BeautifulAppointmentCardState extends State<BeautifulAppointmentCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  AppointmentState get appointmentState => AppointmentState.values[widget.appointment.status ?? 0];

  // Enhanced Dark Mode Colors
  Color get _backgroundColor => widget.isDarkMode
      ? Colors.grey.shade900
      : Colors.white;

  Color get _cardColor => widget.isDarkMode
      ? Colors.grey.shade850
      : Colors.white;

  Color get _surfaceColor => widget.isDarkMode
      ? Colors.grey.shade800
      : Colors.grey.shade50;

  Color get _borderColor => widget.isDarkMode
      ? Colors.grey.shade700
      : Colors.grey.shade200;

  Color get _textPrimaryColor => widget.isDarkMode
      ? Colors.white
      : Colors.black87;

  Color get _textSecondaryColor => widget.isDarkMode
      ? Colors.grey.shade400
      : Colors.grey.shade600;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();

    // Start pulse animation for active states
    if (_shouldPulse()) {
      _pulseController.repeat(reverse: true);
    }
  }

  bool _shouldPulse() {
    return appointmentState == AppointmentState.Start_Examination ||
        appointmentState == AppointmentState.End_Examination;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: widget.isDarkMode
                        ? [
                      Colors.grey.shade850,
                      Colors.grey.shade900,
                    ]
                        : [
                      Colors.white,
                      Colors.grey.shade25,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getStatusColor().withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.isDarkMode
                          ? Colors.black.withOpacity(0.4)
                          : _getStatusColor().withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildEnhancedHeader(),
                    _buildEnhancedContent(),
                    _buildEnhancedFooter(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getStatusColor().withOpacity(0.1),
            _getStatusColor().withOpacity(0.05),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          bottom: BorderSide(
            color: _borderColor.withOpacity(0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          _buildStatusIndicator(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getStatusText(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 14,
                      color: _textSecondaryColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      formatDateString(widget.appointment.date),
                      style: TextStyle(
                        color: _textSecondaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: _textSecondaryColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      formatTimeToAmPm(widget.appointment.time),
                      style: TextStyle(
                        color: _textSecondaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_shouldShowMenu()) _buildEnhancedMenu(),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: _shouldPulse() ? (1.0 + (_pulseController.value * 0.1)) : 1.0,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getStatusColor(),
                  _getStatusColor().withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: _getStatusColor().withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              _getStatusIcon(),
              color: Colors.white,
              size: 24,
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildPetAndClinicInfo(),
          if (_shouldShowVitals()) _buildVitalsSection(),
          if (_shouldShowDoctorRating()) _buildDoctorRating(),
        ],
      ),
    );
  }

  Widget _buildPetAndClinicInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.isDarkMode
              ? [
            Colors.grey.shade800.withOpacity(0.5),
            Colors.grey.shade900.withOpacity(0.2),
          ]
              : [
            Colors.grey.shade50,
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _borderColor.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          _buildClinicAvatar(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.pets_rounded,
                      size: 16,
                      color: Colors.blue.shade600,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        widget.appointment.pet.name ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _textPrimaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.local_hospital_rounded,
                      size: 16,
                      color: Colors.green.shade600,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        widget.appointment.clinicName,
                        style: TextStyle(
                          fontSize: 14,
                          color: _textSecondaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildLocationButton(),
        ],
      ),
    );
  }

  Widget _buildClinicAvatar() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.blue.shade200,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FastCachedImage(
          url: ConfigModel.serverFirstHalfOfImageUrl + (widget.appointment.clinicLogo ?? ''),
          fit: BoxFit.cover,
          errorBuilder: (context, exception, stacktrace) => Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade400,
                  Colors.blue.shade600,
                ],
              ),
            ),
            child: const Icon(
              Icons.local_hospital_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.shade400,
            Colors.orange.shade600,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleLocationTap(),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: const Icon(
              Icons.location_on_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVitalsSection() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.withOpacity(0.1),
            Colors.blue.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.green.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.monitor_heart_rounded,
              color: Colors.green,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                _buildVitalItem(
                  'Temp',
                  '${widget.appointment.temperature}°C',
                  Icons.thermostat_rounded,
                  Colors.red,
                ),
                const SizedBox(width: 20),
                _buildVitalItem(
                  'Weight',
                  '${widget.appointment.weight} kg',
                  Icons.monitor_weight_rounded,
                  Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalItem(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: _textSecondaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: _textPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDoctorRating() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.withOpacity(0.1),
            Colors.orange.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.amber.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.medical_services_rounded,
              color: Colors.amber,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic() ? 'تقييم الطبيب' : 'Doctor Rating',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(
                    5,
                        (index) => Icon(
                      index < widget.appointment.doctorServiceRate
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: Colors.amber,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.isDarkMode
              ? [
            Colors.grey.shade900.withOpacity(0.3),
            Colors.grey.shade800.withOpacity(0.7),
          ]
              : [
            Colors.grey.shade25,
            _getStatusColor().withOpacity(0.05),
          ],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        border: Border(
          top: BorderSide(
            color: _borderColor.withOpacity(0.5),
          ),
        ),
      ),
      child: Row(
        children: _buildActionButtons(),
      ),
    );
  }

  List<Widget> _buildActionButtons() {
    List<Widget> buttons = [];

    // Primary action button
    buttons.add(
      Expanded(
        child: _buildActionButton(
          label: _getPrimaryActionText(),
          color: _getPrimaryActionColor(),
          icon: _getPrimaryActionIcon(),
          onTap: _handlePrimaryAction,
        ),
      ),
    );

    buttons.add(const SizedBox(width: 12));

    // Call button
    buttons.add(
      Expanded(
        child: _buildActionButton(
          label: S.of(context).appointmentButtonCall,
          color: Colors.green,
          icon: Icons.phone_rounded,
          onTap: () => launchUrl(Uri.parse('tel:${widget.appointment.clinicPhone}')),
        ),
      ),
    );

    // Cancel button (only for reserved appointments)
    if (appointmentState == AppointmentState.Reserved) {
      buttons.add(const SizedBox(width: 12));
      buttons.add(
        Expanded(
          child: _buildActionButton(
            label: S.of(context).appointmentButtonCancel,
            color: Colors.red,
            icon: Icons.cancel_rounded,
            onTap: _handleCancelAction,
          ),
        ),
      );
    }

    return buttons;
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color,
            color.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedMenu() {
    return Container(
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? Colors.grey.shade800
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: PopupMenuButton<int>(
        padding: EdgeInsets.zero,
        icon: Icon(
          Icons.more_vert_rounded,
          color: _textSecondaryColor,
          size: 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: widget.isDarkMode ? Colors.grey.shade800 : Colors.white,
        elevation: 8,
        offset: const Offset(0, 40),
        itemBuilder: (context) => _buildMenuItems(),
      ),
    );
  }

  List<PopupMenuEntry<int>> _buildMenuItems() {
    List<PopupMenuEntry<int>> items = [];

    if (widget.appointment.visitId != null && widget.appointment.isBillSqueakVisible) {
      items.add(_buildMenuItem(1, 'Bill', 'الفاتورة', Icons.receipt_long_rounded, Colors.blue));
    }

    if (appointmentState == AppointmentState.Finished) {
      items.addAll([
        _buildMenuItem(2, 'Rate', 'التقييم', Icons.star_rounded, Colors.amber),
        _buildMenuItem(3, 'Prescription', 'الروشتة', Icons.medical_services_rounded, Colors.green),
        _buildMenuItem(4, 'Files', 'الملفات', Icons.folder_rounded, Colors.orange),
      ]);
    }

    return items;
  }

  PopupMenuItem<int> _buildMenuItem(
      int value,
      String englishText,
      String arabicText,
      IconData icon,
      Color color,
      ) {
    return PopupMenuItem(
      value: value,
      onTap: () => _handleMenuAction(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isArabic() ? arabicText : englishText,
                style: TextStyle(
                  color: _textPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods for state management
  Color _getStatusColor() {
    switch (appointmentState) {
      case AppointmentState.Reserved:
        return Colors.blue;
      case AppointmentState.Start_Examination:
        return Colors.orange;
      case AppointmentState.End_Examination:
        return Colors.purple;
      case AppointmentState.Finished:
        return Colors.green;
      case AppointmentState.Attended:
        return Colors.teal;
      case AppointmentState.Cancel:
        return Colors.red;
    }
  }

  IconData _getStatusIcon() {
    switch (appointmentState) {
      case AppointmentState.Reserved:
        return Icons.schedule_rounded;
      case AppointmentState.Start_Examination:
        return Icons.play_circle_rounded;
      case AppointmentState.End_Examination:
        return Icons.pause_circle_rounded;
      case AppointmentState.Finished:
        return Icons.check_circle_rounded;
      case AppointmentState.Attended:
        return Icons.person_rounded;
      case AppointmentState.Cancel:
        return Icons.cancel_rounded;
    }
  }

  String _getStatusText() {
    switch (appointmentState) {
      case AppointmentState.Reserved:
        return isArabic() ? 'محجوز' : 'Reserved';
      case AppointmentState.Start_Examination:
        return isArabic() ? 'بدء الفحص' : 'Examination Started';
      case AppointmentState.End_Examination:
        return isArabic() ? 'انتهاء الفحص' : 'Examination Ended';
      case AppointmentState.Finished:
        return isArabic() ? 'مكتمل' : 'Finished';
      case AppointmentState.Attended:
        return isArabic() ? 'حضر' : 'Attended';
      case AppointmentState.Cancel:
        return isArabic() ? 'ملغي' : 'Cancelled';
    }
  }

  String _getPrimaryActionText() {
    switch (appointmentState) {
      case AppointmentState.Reserved:
        return S.of(context).appointmentButtonEdit;
      case AppointmentState.Start_Examination:
      case AppointmentState.End_Examination:
      case AppointmentState.Attended:
        return isArabic() ? 'في الانتظار' : 'In Progress';
      case AppointmentState.Finished:
      case AppointmentState.Cancel:
        return S.of(context).appointmentButtonBooking;
    }
  }

  Color _getPrimaryActionColor() {
    switch (appointmentState) {
      case AppointmentState.Reserved:
        return Colors.blue;
      case AppointmentState.Start_Examination:
      case AppointmentState.End_Examination:
        return Colors.orange;
      case AppointmentState.Attended:
        return Colors.teal;
      case AppointmentState.Finished:
      case AppointmentState.Cancel:
        return Colors.green;
    }
  }

  IconData _getPrimaryActionIcon() {
    switch (appointmentState) {
      case AppointmentState.Reserved:
        return Icons.edit_rounded;
      case AppointmentState.Start_Examination:
      case AppointmentState.End_Examination:
        return Icons.hourglass_empty_rounded;
      case AppointmentState.Attended:
        return Icons.access_time_rounded;
      case AppointmentState.Finished:
      case AppointmentState.Cancel:
        return Icons.refresh_rounded;
    }
  }

  bool _shouldShowMenu() {
    return appointmentState == AppointmentState.Finished;
  }

  bool _shouldShowVitals() {
    return appointmentState == AppointmentState.Finished &&
        (widget.appointment.temperature != null || widget.appointment.weight != null);
  }

  bool _shouldShowDoctorRating() {
    return appointmentState == AppointmentState.Finished &&
        widget.appointment.doctorServiceRate != 0;
  }

  // Action handlers
  void _handlePrimaryAction() {
    switch (appointmentState) {
      case AppointmentState.Reserved:
        _showEditDialog();
        break;
      case AppointmentState.Start_Examination:
      case AppointmentState.End_Examination:
      case AppointmentState.Attended:
      // Show info that appointment is in progress
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isArabic()
                  ? 'الموعد قيد التنفيذ، يرجى الانتظار'
                  : 'Appointment is in progress, please wait',
            ),
            backgroundColor: Colors.orange,
          ),
        );
        break;
      case AppointmentState.Finished:
      case AppointmentState.Cancel:
        _navigateToBookAgain();
        break;
    }
  }

  void _handleCancelAction() {
    _showCancelDialog();
  }

  void _handleLocationTap() {
    if (widget.appointment.clinicLocation.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic()
                ? 'الموقع مفقود، يرجى مطالبة المشرف بإضافة موقعه'
                : 'Location is missing, please ask the admin to add location',
          ),
          backgroundColor: Colors.orange,
        ),
      );
    } else {
      launchUrl(Uri.parse(widget.appointment.clinicLocation));
    }
  }

  void _handleMenuAction(int value) {
    switch (value) {
      case 1:
        widget.cubit.printReceipt(widget.appointment, context);
        break;
      case 2:
        navigateToScreen(
          context,
          RateAppointment(model: widget.appointment, isNav: true),
        );
        break;
      case 3:
        navigateToScreen(
          context,
          PrescriptionForPetScreen(reservationid: widget.appointment.id),
        );
        break;
      case 4:
        navigateToScreen(
          context,
          FilesForPetScreen(reservationid: widget.appointment.id),
        );
        break;
    }
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) => _buildConfirmationDialog(
        title: S.of(context).appointmentModalTitle,
        content: S.of(context).appointmentModalDescription,
        onConfirm: () {
          widget.cubit.emit(EditAppointment(widget.appointment));
          Navigator.of(context).pop();
          widget.cubit.findClinic(
            widget.cubit.suppliers!.data,
            widget.appointment.clinicCode,
            widget.appointment.clinicId,
          );
          navigateToScreen(
            context,
            BooKAgainScreen(
              clinicCode: widget.appointment.clinicCode,
              petId: widget.appointment.petId,
            ),
          );
        },
      ),
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => _buildConfirmationDialog(
        title: S.of(context).appointmentModalTitle,
        content: isArabic()
            ? 'هل أنت متأكد من إلغاء هذا الموعد؟'
            : 'Are you sure you want to cancel this appointment?',
        onConfirm: () {
          widget.cubit.deleteAppointments(widget.appointment.id);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildConfirmationDialog({
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(content),
          const SizedBox(height: 16),
          const CircleAvatar(
            backgroundImage: NetworkImage(
              'https://img.freepik.com/free-vector/emotional-support-animal-concept-illustration_114360-19462.jpg',
            ),
            radius: 40,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(S.of(context).appointmentModalButtonNo),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: Text(S.of(context).appointmentModalButtonYes),
        ),
      ],
    );
  }

  void _navigateToBookAgain() {
    widget.cubit.findClinic(
      widget.cubit.suppliers!.data,
      widget.appointment.clinicCode,
      widget.appointment.clinicId,
    );
    navigateToScreen(
      context,
      BooKAgainScreen(
        clinicCode: widget.appointment.clinicCode,
        petId: widget.appointment.petId,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
}

// Usage function to replace your buildItem
Widget buildBeautifulAppointmentItem(
    AppointmentEntity appointment,
    BuildContext context,
    UserAppointmentCubit cubit,
    int index, {
      bool isDarkMode = false,
    }) {
  return BeautifulAppointmentCard(
    appointment: appointment,
    cubit: cubit,
    index: index,
    isDarkMode: isDarkMode,
  );
}

// Auto-detect theme version
Widget buildThemeAwareAppointmentItem(
    AppointmentEntity appointment,
    BuildContext context,
    UserAppointmentCubit cubit,
    int index,
    ) {
  final isDark = MainCubit.get(context).isDark;
  return BeautifulAppointmentCard(
    appointment: appointment,
    cubit: cubit,
    index: index,
    isDarkMode: isDark,
  );
}
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/appointments/exam/domain/entities/appointment_entity.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/book_again_screen.dart';
import 'package:squeak/features/appointments/exam/presentation/view/appointments/rate_appointment.dart';
import 'package:squeak/features/appointments/exam/presentation/view/files_and_prescription_for_pet/files_for_pet_screen.dart';
import 'package:squeak/features/appointments/exam/presentation/view/files_and_prescription_for_pet/prescription_for_pet_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/user/user_appointment_cubit.dart';

enum AppointmentState {
  Reserved,         // 0
  Start_Examination, // 1
  End_Examination,   // 2
  Finished,         // 3
  Attended,         // 4
  Cancel           // 5
}

class BeautifulAppointmentCard extends StatefulWidget {
  final AppointmentEntity appointment;
  final UserAppointmentCubit cubit;
  final int index;
  final bool isDarkMode;

  const BeautifulAppointmentCard({
    super.key,
    required this.appointment,
    required this.cubit,
    required this.index,
    this.isDarkMode = false,
  });

  @override
  State<BeautifulAppointmentCard> createState() => _BeautifulAppointmentCardState();
}

class _BeautifulAppointmentCardState extends State<BeautifulAppointmentCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  AppointmentState get appointmentState => AppointmentState.values[widget.appointment.status ?? 0];

  // Enhanced Dark Mode Colors
  Color get _backgroundColor => widget.isDarkMode
      ? Colors.grey.shade900
      : Colors.white;

  Color get _cardColor => widget.isDarkMode
      ? Colors.grey.shade850
      : Colors.white;

  Color get _surfaceColor => widget.isDarkMode
      ? Colors.grey.shade800
      : Colors.grey.shade50;

  Color get _borderColor => widget.isDarkMode
      ? Colors.grey.shade700
      : Colors.grey.shade200;

  Color get _textPrimaryColor => widget.isDarkMode
      ? Colors.white
      : Colors.black87;

  Color get _textSecondaryColor => widget.isDarkMode
      ? Colors.grey.shade400
      : Colors.grey.shade600;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();

    // Start pulse animation for active states
    if (_shouldPulse()) {
      _pulseController.repeat(reverse: true);
    }
  }

  bool _shouldPulse() {
    return appointmentState == AppointmentState.Start_Examination ||
        appointmentState == AppointmentState.End_Examination;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: widget.isDarkMode
                        ? [
                      Colors.grey.shade850,
                      Colors.grey.shade900,
                    ]
                        : [
                      Colors.white,
                      Colors.grey.shade25,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getStatusColor().withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.isDarkMode
                          ? Colors.black.withOpacity(0.4)
                          : _getStatusColor().withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildEnhancedHeader(),
                    _buildEnhancedContent(),
                    _buildEnhancedFooter(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getStatusColor().withOpacity(0.1),
            _getStatusColor().withOpacity(0.05),
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          bottom: BorderSide(
            color: _borderColor.withOpacity(0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          _buildStatusIndicator(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getStatusText(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 14,
                      color: _textSecondaryColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      formatDateString(widget.appointment.date),
                      style: TextStyle(
                        color: _textSecondaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: _textSecondaryColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      formatTimeToAmPm(widget.appointment.time),
                      style: TextStyle(
                        color: _textSecondaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_shouldShowMenu()) _buildEnhancedMenu(),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: _shouldPulse() ? (1.0 + (_pulseController.value * 0.1)) : 1.0,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getStatusColor(),
                  _getStatusColor().withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: _getStatusColor().withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              _getStatusIcon(),
              color: Colors.white,
              size: 24,
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildPetAndClinicInfo(),
          if (_shouldShowVitals()) _buildVitalsSection(),
          if (_shouldShowDoctorRating()) _buildDoctorRating(),
        ],
      ),
    );
  }

  Widget _buildPetAndClinicInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.isDarkMode
              ? [
            Colors.grey.shade800.withOpacity(0.5),
            Colors.grey.shade900.withOpacity(0.2),
          ]
              : [
            Colors.grey.shade50,
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _borderColor.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          _buildClinicAvatar(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.pets_rounded,
                      size: 16,
                      color: Colors.blue.shade600,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        widget.appointment.pet.name ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _textPrimaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.local_hospital_rounded,
                      size: 16,
                      color: Colors.green.shade600,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        widget.appointment.clinicName,
                        style: TextStyle(
                          fontSize: 14,
                          color: _textSecondaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildLocationButton(),
        ],
      ),
    );
  }

  Widget _buildClinicAvatar() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.blue.shade200,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FastCachedImage(
          url: ConfigModel.serverFirstHalfOfImageUrl + (widget.appointment.clinicLogo ?? ''),
          fit: BoxFit.cover,
          errorBuilder: (context, exception, stacktrace) => Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade400,
                  Colors.blue.shade600,
                ],
              ),
            ),
            child: const Icon(
              Icons.local_hospital_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.shade400,
            Colors.orange.shade600,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleLocationTap(),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: const Icon(
              Icons.location_on_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVitalsSection() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.withOpacity(0.1),
            Colors.blue.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.green.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.monitor_heart_rounded,
              color: Colors.green,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              children: [
                _buildVitalItem(
                  'Temp',
                  '${widget.appointment.temperature}°C',
                  Icons.thermostat_rounded,
                  Colors.red,
                ),
                const SizedBox(width: 20),
                _buildVitalItem(
                  'Weight',
                  '${widget.appointment.weight} kg',
                  Icons.monitor_weight_rounded,
                  Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalItem(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: _textSecondaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: _textPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDoctorRating() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amber.withOpacity(0.1),
            Colors.orange.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.amber.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.medical_services_rounded,
              color: Colors.amber,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic() ? 'تقييم الطبيب' : 'Doctor Rating',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(
                    5,
                        (index) => Icon(
                      index < widget.appointment.doctorServiceRate
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: Colors.amber,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.isDarkMode
              ? [
            Colors.grey.shade900.withOpacity(0.3),
            Colors.grey.shade800.withOpacity(0.7),
          ]
              : [
            Colors.grey.shade25,
            _getStatusColor().withOpacity(0.05),
          ],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        border: Border(
          top: BorderSide(
            color: _borderColor.withOpacity(0.5),
          ),
        ),
      ),
      child: Row(
        children: _buildActionButtons(),
      ),
    );
  }

  List<Widget> _buildActionButtons() {
    List<Widget> buttons = [];

    // Primary action button
    buttons.add(
      Expanded(
        child: _buildActionButton(
          label: _getPrimaryActionText(),
          color: _getPrimaryActionColor(),
          icon: _getPrimaryActionIcon(),
          onTap: _handlePrimaryAction,
        ),
      ),
    );

    buttons.add(const SizedBox(width: 12));

    // Call button
    buttons.add(
      Expanded(
        child: _buildActionButton(
          label: S.of(context).appointmentButtonCall,
          color: Colors.green,
          icon: Icons.phone_rounded,
          onTap: () => launchUrl(Uri.parse('tel:${widget.appointment.clinicPhone}')),
        ),
      ),
    );

    // Cancel button (only for reserved appointments)
    if (appointmentState == AppointmentState.Reserved) {
      buttons.add(const SizedBox(width: 12));
      buttons.add(
        Expanded(
          child: _buildActionButton(
            label: S.of(context).appointmentButtonCancel,
            color: Colors.red,
            icon: Icons.cancel_rounded,
            onTap: _handleCancelAction,
          ),
        ),
      );
    }

    return buttons;
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color,
            color.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedMenu() {
    return Container(
      decoration: BoxDecoration(
        color: widget.isDarkMode
            ? Colors.grey.shade800
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: PopupMenuButton<int>(
        padding: EdgeInsets.zero,
        icon: Icon(
          Icons.more_vert_rounded,
          color: _textSecondaryColor,
          size: 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: widget.isDarkMode ? Colors.grey.shade800 : Colors.white,
        elevation: 8,
        offset: const Offset(0, 40),
        itemBuilder: (context) => _buildMenuItems(),
      ),
    );
  }

  List<PopupMenuEntry<int>> _buildMenuItems() {
    List<PopupMenuEntry<int>> items = [];

    if (widget.appointment.visitId != null && widget.appointment.isBillSqueakVisible) {
      items.add(_buildMenuItem(1, 'Bill', 'الفاتورة', Icons.receipt_long_rounded, Colors.blue));
    }

    if (appointmentState == AppointmentState.Finished) {
      items.addAll([
        _buildMenuItem(2, 'Rate', 'التقييم', Icons.star_rounded, Colors.amber),
        _buildMenuItem(3, 'Prescription', 'الروشتة', Icons.medical_services_rounded, Colors.green),
        _buildMenuItem(4, 'Files', 'الملفات', Icons.folder_rounded, Colors.orange),
      ]);
    }

    return items;
  }

  PopupMenuItem<int> _buildMenuItem(
      int value,
      String englishText,
      String arabicText,
      IconData icon,
      Color color,
      ) {
    return PopupMenuItem(
      value: value,
      onTap: () => _handleMenuAction(value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isArabic() ? arabicText : englishText,
                style: TextStyle(
                  color: _textPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods for state management
  Color _getStatusColor() {
    switch (appointmentState) {
      case AppointmentState.Reserved:
        return Colors.blue;
      case AppointmentState.Start_Examination:
        return Colors.orange;
      case AppointmentState.End_Examination:
        return Colors.purple;
      case AppointmentState.Finished:
        return Colors.green;
      case AppointmentState.Attended:
        return Colors.teal;
      case AppointmentState.Cancel:
        return Colors.red;
    }
  }

  IconData _getStatusIcon() {
    switch (appointmentState) {
      case AppointmentState.Reserved:
        return Icons.schedule_rounded;
      case AppointmentState.Start_Examination:
        return Icons.play_circle_rounded;
      case AppointmentState.End_Examination:
        return Icons.pause_circle_rounded;
      case AppointmentState.Finished:
        return Icons.check_circle_rounded;
      case AppointmentState.Attended:
        return Icons.person_rounded;
      case AppointmentState.Cancel:
        return Icons.cancel_rounded;
    }
  }

  String _getStatusText() {
    switch (appointmentState) {
      case AppointmentState.Reserved:
        return isArabic() ? 'محجوز' : 'Reserved';
      case AppointmentState.Start_Examination:
        return isArabic() ? 'بدء الفحص' : 'Examination Started';
      case AppointmentState.End_Examination:
        return isArabic() ? 'انتهاء الفحص' : 'Examination Ended';
      case AppointmentState.Finished:
        return isArabic() ? 'مكتمل' : 'Finished';
      case AppointmentState.Attended:
        return isArabic() ? 'حضر' : 'Attended';
      case AppointmentState.Cancel:
        return isArabic() ? 'ملغي' : 'Cancelled';
    }
  }

  String _getPrimaryActionText() {
    switch (appointmentState) {
      case AppointmentState.Reserved:
        return S.of(context).appointmentButtonEdit;
      case AppointmentState.Start_Examination:
      case AppointmentState.End_Examination:
      case AppointmentState.Attended:
        return isArabic() ? 'في الانتظار' : 'In Progress';
      case AppointmentState.Finished:
      case AppointmentState.Cancel:
        return S.of(context).appointmentButtonBooking;
    }
  }

  Color _getPrimaryActionColor() {
    switch (appointmentState) {
      case AppointmentState.Reserved:
        return Colors.blue;
      case AppointmentState.Start_Examination:
      case AppointmentState.End_Examination:
        return Colors.orange;
      case AppointmentState.Attended:
        return Colors.teal;
      case AppointmentState.Finished:
      case AppointmentState.Cancel:
        return Colors.green;
    }
  }

  IconData _getPrimaryActionIcon() {
    switch (appointmentState) {
      case AppointmentState.Reserved:
        return Icons.edit_rounded;
      case AppointmentState.Start_Examination:
      case AppointmentState.End_Examination:
        return Icons.hourglass_empty_rounded;
      case AppointmentState.Attended:
        return Icons.access_time_rounded;
      case AppointmentState.Finished:
      case AppointmentState.Cancel:
        return Icons.refresh_rounded;
    }
  }

  bool _shouldShowMenu() {
    return appointmentState == AppointmentState.Finished;
  }

  bool _shouldShowVitals() {
    return appointmentState == AppointmentState.Finished &&
        (widget.appointment.temperature != null || widget.appointment.weight != null);
  }

  bool _shouldShowDoctorRating() {
    return appointmentState == AppointmentState.Finished &&
        widget.appointment.doctorServiceRate != 0;
  }

  // Action handlers
  void _handlePrimaryAction() {
    switch (appointmentState) {
      case AppointmentState.Reserved:
        _showEditDialog();
        break;
      case AppointmentState.Start_Examination:
      case AppointmentState.End_Examination:
      case AppointmentState.Attended:
      // Show info that appointment is in progress
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isArabic()
                  ? 'الموعد قيد التنفيذ، يرجى الانتظار'
                  : 'Appointment is in progress, please wait',
            ),
            backgroundColor: Colors.orange,
          ),
        );
        break;
      case AppointmentState.Finished:
      case AppointmentState.Cancel:
        _navigateToBookAgain();
        break;
    }
  }

  void _handleCancelAction() {
    _showCancelDialog();
  }

  void _handleLocationTap() {
    if (widget.appointment.clinicLocation.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic()
                ? 'الموقع مفقود، يرجى مطالبة المشرف بإضافة موقعه'
                : 'Location is missing, please ask the admin to add location',
          ),
          backgroundColor: Colors.orange,
        ),
      );
    } else {
      launchUrl(Uri.parse(widget.appointment.clinicLocation));
    }
  }

  void _handleMenuAction(int value) {
    switch (value) {
      case 1:
        widget.cubit.printReceipt(widget.appointment, context);
        break;
      case 2:
        navigateToScreen(
          context,
          RateAppointment(model: widget.appointment, isNav: true),
        );
        break;
      case 3:
        navigateToScreen(
          context,
          PrescriptionForPetScreen(reservationid: widget.appointment.id),
        );
        break;
      case 4:
        navigateToScreen(
          context,
          FilesForPetScreen(reservationid: widget.appointment.id),
        );
        break;
    }
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) => _buildConfirmationDialog(
        title: S.of(context).appointmentModalTitle,
        content: S.of(context).appointmentModalDescription,
        onConfirm: () {
          widget.cubit.emit(EditAppointment(widget.appointment));
          Navigator.of(context).pop();
          widget.cubit.findClinic(
            widget.cubit.suppliers!.data,
            widget.appointment.clinicCode,
            widget.appointment.clinicId,
          );
          navigateToScreen(
            context,
            BooKAgainScreen(
              clinicCode: widget.appointment.clinicCode,
              petId: widget.appointment.petId,
            ),
          );
        },
      ),
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => _buildConfirmationDialog(
        title: S.of(context).appointmentModalTitle,
        content: isArabic()
            ? 'هل أنت متأكد من إلغاء هذا الموعد؟'
            : 'Are you sure you want to cancel this appointment?',
        onConfirm: () {
          widget.cubit.deleteAppointments(widget.appointment.id);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildConfirmationDialog({
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(content),
          const SizedBox(height: 16),
          const CircleAvatar(
            backgroundImage: NetworkImage(
              'https://img.freepik.com/free-vector/emotional-support-animal-concept-illustration_114360-19462.jpg',
            ),
            radius: 40,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(S.of(context).appointmentModalButtonNo),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: Text(S.of(context).appointmentModalButtonYes),
        ),
      ],
    );
  }

  void _navigateToBookAgain() {
    widget.cubit.findClinic(
      widget.cubit.suppliers!.data,
      widget.appointment.clinicCode,
      widget.appointment.clinicId,
    );
    navigateToScreen(
      context,
      BooKAgainScreen(
        clinicCode: widget.appointment.clinicCode,
        petId: widget.appointment.petId,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
}

// Usage function to replace your buildItem
Widget buildBeautifulAppointmentItem(
    AppointmentEntity appointment,
    BuildContext context,
    UserAppointmentCubit cubit,
    int index, {
      bool isDarkMode = false,
    }) {
  return BeautifulAppointmentCard(
    appointment: appointment,
    cubit: cubit,
    index: index,
    isDarkMode: isDarkMode,
  );
}

// Auto-detect theme version
Widget buildThemeAwareAppointmentItem(
    AppointmentEntity appointment,
    BuildContext context,
    UserAppointmentCubit cubit,
    int index,
    ) {
  final isDark = MainCubit.get(context).isDark;
  return BeautifulAppointmentCard(
    appointment: appointment,
    cubit: cubit,
    index: index,
    isDarkMode: isDark,
  );
}
