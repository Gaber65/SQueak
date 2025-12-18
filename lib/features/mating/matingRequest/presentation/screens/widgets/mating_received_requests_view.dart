import 'package:flutter/material.dart';
import 'package:squeak/features/mating/matingRequest/domain/entities/mating_request_entity.dart';
import '../../../../../../core/service/service_locator/locatore_export_path.dart';
import 'request_card_compact.dart';
import 'empty_state.dart';

class MatingReceivedRequestsView extends StatelessWidget {
  final ManageRequestMatingCubit cubit;

  const MatingReceivedRequestsView({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final receivedRequests = cubit.dummyMatingRequests;

    if (receivedRequests.isEmpty) {
      return EmptyState(
        icon: Icons.favorite_border_rounded,
        title: S.of(context).noReceivedRequests,
        subtitle: S.of(context).noReceivedRequestsSub,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: receivedRequests.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final request = receivedRequests[index];
        return RequestCardCompact(
          request: request,
          isReceived: true,
          onAccept: () => _handleAccept(context, request),
          onReject: () => _handleReject(context, request),
        );
      },
    );
  }

  void _handleAccept(BuildContext context, MatingRequestEntity request) {
    ManageRequestMatingCubit.get(context).updateRequestStatus(
      UpdateRequestStatusParams(
        matingRequestId: request.id,
        status: RequestStatus.accepted,
      ),
      false,
    );
  }

  void _handleReject(BuildContext context, dynamic request) {
    ManageRequestMatingCubit.get(context).updateRequestStatus(
      UpdateRequestStatusParams(
        matingRequestId: request.postId,
        status: RequestStatus.rejected,
      ),
      false,
    );
  }
}
