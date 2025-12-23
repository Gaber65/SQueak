import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/chat_app_cubit.dart';
import '../controllers/chat_app_state.dart';

class ConnectionQuickActions extends StatelessWidget {
  const ConnectionQuickActions({super.key});

  bool _isArabic(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatAppCubit, ChatAppState>(
      builder: (context, state) {
        final isConnected = state is ChatAppConnected;
        final chatAppCubit = context.read<ChatAppCubit>();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: isConnected ? Colors.green : Colors.orange,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: isConnected
                          ? Colors.green.withOpacity(0.5)
                          : Colors.orange.withOpacity(0.5),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 32,
                height: 32,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  tooltip: _isArabic(context) ? 'إعادة الاتصال' : 'Reconnect',
                  icon: const Icon(Icons.refresh, size: 18),
                  onPressed: () async {
                    debugPrint('🔁 [ConnectionQuickActions] Retry pressed — reconnecting general hub...');
                    try {
                      await chatAppCubit.initialize();
                    } catch (e) {
                      debugPrint('🔁 [ConnectionQuickActions] Reconnect failed: $e');
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
