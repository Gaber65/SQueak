import 'package:flutter/material.dart';
import '../../../../../../core/utils/theme/color_mangment/color_manager.dart' show ColorManager;
import '../../../../../../generated/l10n.dart';
import '../../controller/manage_request_mating_cubit.dart';

class MatingStatsHeader extends StatelessWidget {
  final ManageRequestMatingCubit cubit;

  const MatingStatsHeader({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorManager.primaryColor.withOpacity(0.8),
            ColorManager.primaryColor.withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ColorManager.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.of(context).matingActivity,
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                  S.of(context).manageIncomingOutgoing,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.8), fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text('${cubit.dummyMatingRequests.length}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                Text(S.of(context).total,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.8), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
