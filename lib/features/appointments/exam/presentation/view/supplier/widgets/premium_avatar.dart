import 'package:squeak/core/service/global_widget/image_detail.dart';
import 'package:flutter/material.dart';
import 'package:squeak/features/appointments/exam/domain/entities/clinic_entity.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

class PremiumSupplierAvatar extends StatelessWidget {
  final ClinicInfo clinic;
  final bool isDark;

  const PremiumSupplierAvatar({
    super.key,
    required this.clinic,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors:
              isDark
                  ? [Colors.blue.shade800, Colors.blue.shade600]
                  : [Colors.blue.shade100, Colors.blue.shade200],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child:
            clinic.data.image.isNotEmpty
                ? SafeFastCachedImageExtension.safe(
                  url: imageUrl + clinic.data.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, _, __) => _placeholder(),
                )
                : _placeholder(),
      ),
    );
  }

  Widget _placeholder() {
    return Icon(
      Icons.medical_services_outlined,
      color: isDark ? Colors.white : Colors.blue.shade700,
      size: 28,
    );
  }
}
