import 'package:flutter/material.dart';
import '../../../../../../core/service/service_locator/locatore_export_path.dart';
import '../../../domain/entities/mating_request_entity.dart';
import 'request_card_compact.dart';
import 'empty_state.dart';

class MatingSentRequestsView extends StatelessWidget {
  final ManageRequestMatingCubit cubit;

  const MatingSentRequestsView({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final sentRequests = cubit.dummyMatingSent;

    if (sentRequests.isEmpty) {
      return EmptyState(
        icon: Icons.send_rounded,
        title: S.of(context).noSentRequests,
        subtitle: S.of(context).emptyMatingRequests,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: sentRequests.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final request = sentRequests[index];
        return RequestCardCompact(
          request: request,
          isReceived: false,
          onCancel: () => _handleCancel(context, request),
        );
      },
    );
  }


  void _handleCancel(BuildContext context, dynamic request) {
    ManageRequestMatingCubit.get(context).updateRequestStatus(
      UpdateRequestStatusParams(
        matingRequestId: request.id,
        status: RequestStatus.canceled,
      ),
      false,
    );
  }
}
