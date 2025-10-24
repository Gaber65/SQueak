import 'package:flutter/material.dart';
import 'package:squeak/features/mating/matingRequest/presentation/screens/widgets/mating_received_requests_view.dart';
import '../../../../../../core/service/service_locator/locatore_export_path.dart';
import 'mating_sent_requests_view.dart';

class MatingTabSection extends StatelessWidget {
  final ManageRequestMatingCubit cubit;

  const MatingTabSection({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration:Decorations.kDecorationBoxShadow(context: context),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TabBar(
              labelColor: ColorManager.primaryColor,
              unselectedLabelColor: Colors.grey,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: ColorManager.primaryColor.withOpacity(0.1),
              ),
              tabs: [
                SizedBox(width: MediaQuery.sizeOf(context).width/2, child: Tab(text: S.of(context).received)),
                SizedBox(width: MediaQuery.sizeOf(context).width/2, child: Tab(text: S.of(context).sent)),

              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              children: [
                MatingReceivedRequestsView(cubit: cubit),
                MatingSentRequestsView(cubit: cubit),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
