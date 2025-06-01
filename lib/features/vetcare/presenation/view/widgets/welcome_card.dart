import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key, required this.clinicName});

  final String clinicName;

  @override
  Widget build(BuildContext context) {
    return Card(
      color:
          MainCubit.get(context).isDark
              ? Colors.blue.shade900
              : Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: '$clinicName ',
                style: FontStyleThame.textStyle(
                  context: context,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontColor:
                      MainCubit.get(context).isDark
                          ? Colors.white
                          : Colors.blue.shade800,
                ),
              ),
              TextSpan(
                text: _getWelcomeMessage(),
                style: FontStyleThame.textStyle(
                  context: context,
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  fontColor:
                      MainCubit.get(context).isDark
                          ? Colors.white60
                          : Colors.blue.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getWelcomeMessage() {
    return isArabic()
        ? 'تدعوك للتسجيل في Squeak والبقاء على تواصل. سجل اليوم وتابعنا للحصول على التحديثات!'
        : 'invites you to register on Squeak and stay connected. Sign up today and follow us for updates!';
  }
}
