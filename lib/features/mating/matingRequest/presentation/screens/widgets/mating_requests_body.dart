import 'package:flutter/material.dart';
import '../../controller/manage_request_mating_cubit.dart';
import 'mating_stats_header.dart';
import 'mating_stats_row.dart';
import 'mating_tab_section.dart';

class MatingRequestsBody extends StatelessWidget {
  final ManageRequestMatingCubit cubit;
  final String profileName;

  const MatingRequestsBody(this.cubit, this.profileName, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MatingStatsHeader(cubit: cubit),
        const SizedBox(height: 16),
        MatingStatsRow(cubit: cubit),
        const SizedBox(height: 24),
        Expanded(child: MatingTabSection(cubit: cubit)),
      ],
    );
  }
}
