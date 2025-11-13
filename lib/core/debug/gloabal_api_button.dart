import 'package:flutter/material.dart';
import 'package:squeak/core/debug/global_api_button.dart';
import 'package:squeak/core/service/main_service/presentation/screens/navigator_key.dart';

class GlobalApiButton extends StatelessWidget {
  const GlobalApiButton({super.key});

  @override
  Widget build(BuildContext context) {
    // Small floating button at bottom-right
    return Positioned(
      right: 16,
      bottom: 24,
      child: FloatingActionButton(
        heroTag: 'api_tester_fab',
        mini: true,
        onPressed: () {
          navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => const ApiTesterScreen()));
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.cloud, size: 20),
      ),
    );
  }
}
