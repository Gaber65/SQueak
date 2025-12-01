import 'package:flutter/material.dart';
import '../../../../../core/service/service_locator/locatore_export_path.dart';

class ChatLoadingState extends StatelessWidget {
  const ChatLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorManager.primaryColor.withOpacity(0.1),
              ColorManager.primaryColor.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
