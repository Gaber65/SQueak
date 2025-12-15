import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../domain/entities/pet_entity.dart';
import '../../../../../qr/presentation/controller/qr_cubit.dart';
import '../../../../../qr/presentation/widgets/qr_link_dialog.dart';

class QrNotLinkedDialog extends StatelessWidget {
  final PetEntities pet;
  final QrCubit qrCubit;
  final bool isDark;

  const QrNotLinkedDialog({
    super.key,
    required this.pet,
    required this.qrCubit,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              isDark ? Colors.grey.shade900 : Colors.orange.shade50,
              isDark ? Colors.grey.shade800 : Colors.white,
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.qr_code_2_rounded,
                color: Colors.orange,
                size: 60,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              S.of(context).qrNotLinked,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.orange.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              S.of(context).youCanLinkQrNow,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      final url = Uri.parse('https://veticareapp.com/qr/');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                    icon: Icon(Icons.info_outline, size: 18),
                    label: Text(
                      S.of(context).learnHow,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: ColorManager.primaryColor,
                      side: BorderSide(
                        color: ColorManager.primaryColor,
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder:
                            (ctx) => QrLinkDialog(
                              pet: pet,
                              cubit: qrCubit,
                              isDarkMode: isDark,
                            ),
                      );
                    },
                    icon: Icon(Icons.link, size: 18),
                    label: Text(
                      S.of(context).linkQrCode,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
