import 'package:flutter/material.dart';
import 'package:squeak/core/service/main_service/presentation/controller/main_cubit/main_cubit.dart';
import 'package:squeak/features/mating/matingRequest/domain/entities/mating_request_entity.dart';
import 'package:squeak/generated/l10n.dart';
import '../../../../profile/presentation/widgets/stat_item.dart';
import '../../controller/manage_request_mating_cubit.dart';

class MatingStatsRow extends StatelessWidget {
  final ManageRequestMatingCubit cubit;

  const MatingStatsRow({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final pending =
        cubit.dummyMatingRequests
            .where((r) => r.status == RequestStatus.pending)
            .length
            .toString();
    final accepted =
        cubit.dummyMatingRequests
            .where((r) => r.status == RequestStatus.accepted)
            .length
            .toString();
    final rejected =
        cubit.dummyMatingRequests
            .where((r) => r.status == RequestStatus.rejected)
            .length
            .toString();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          StatItem(
            value: pending,
            label: S.of(context).pending,
            color: Colors.orange,
            icon: Icons.schedule,
            isDarkMode: MainCubit.get(context).isDark,
          ),
          const SizedBox(width: 12),
          StatItem(
            value: accepted,
            label: S.of(context).accepted,
            color: Colors.green,
            icon: Icons.check_circle,
            isDarkMode: MainCubit.get(context).isDark,
          ),
          const SizedBox(width: 12),
          StatItem(
            value: rejected,
            label: S.of(context).rejected,
            color: Colors.red,
            icon: Icons.close,
            isDarkMode: MainCubit.get(context).isDark,
          ),
        ],
      ),
    );
  }
}
