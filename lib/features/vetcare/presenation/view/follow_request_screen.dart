// features/vetcare/presentation/pages/follow_request_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../../../generated/l10n.dart';
import '../../../service/view/pet_vaccination.dart';
import '../controllers/follow_request/follow_request_cubit.dart';
import 'pet_merge_screen.dart';

class FollowRequestScreen extends StatelessWidget {
  const FollowRequestScreen({super.key, required this.clinicID});

  final String clinicID;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<FollowRequestCubit>()..getNotifications(clinicID),
        ),
      ],
      child: _FollowRequestContent(clinicID: clinicID),
    );
  }
}

class _FollowRequestContent extends StatelessWidget {
  final String clinicID;

  const _FollowRequestContent({required this.clinicID});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FollowRequestCubit, FollowRequestState>(
      listener: _handleStateChanges,
      builder: (context, state) {
        final cubit = FollowRequestCubit.get(context);
        return WillPopScope(
          onWillPop: () => _handleBackNavigation(context),
          child: Scaffold(
            appBar: _buildAppBar(context),
            body: _buildBody(context, cubit, state),
          ),
        );
      },
    );
  }

  void _handleStateChanges(BuildContext context, FollowRequestState state) {
    if (state is ErrorAcceptIvationState) {
      _showErrorToast(context, state);
    }
    if (state is SuccessAcceptIvationState) {
      _handleAcceptanceSuccess(context, state);
    }
  }

  void _showErrorToast(BuildContext context, ErrorAcceptIvationState state) {
    final errorMessage = state.error is Map && state.error['errors'] != null && state.error['errors'].isNotEmpty
        ? state.error['errors'].values.first.first
        : state.error.toString();
    errorToast(context, errorMessage);
  }

  void _handleAcceptanceSuccess(
      BuildContext context,
      SuccessAcceptIvationState state,
      ) {
    // Get the clinic code from the repository or state
    final clinicCode = ""; // This should be retrieved from the repository or state

    final nextScreen = state.hasValidPets
        ? PetMergeScreen(
      code: clinicCode,
      isNavigation: false,
    )
        : LayoutScreen();
    navigateToScreen(context, nextScreen);
  }

  Future<bool> _handleBackNavigation(BuildContext context) async {
    navigateAndFinish(context, LayoutScreen());
    return false;
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(S.of(context).followRequest),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => navigateAndFinish(context, LayoutScreen()),
      ),
    );
  }

  Widget _buildBody(BuildContext context, FollowRequestCubit cubit, FollowRequestState state) {
    // This is a simplified version - you'll need to adapt this based on your actual data structure
    if (state is NotificationsLoadingState) return VacShimmer();

    // Check if clinic data is available
    final hasClinicData = cubit.notifications.isNotEmpty;
    if (!hasClinicData) return _buildUnavailableRequestView(context);

    return _buildRequestCard(context, cubit);
  }

  Widget _buildUnavailableRequestView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cancel, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              S.of(context).followRequestUnAvailable,
              style: FontStyleThame.textStyle(
                context: context,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context).expiredRequest,
              textAlign: TextAlign.center,
              style: FontStyleThame.textStyle(
                fontSize: 16,
                context: context,
                fontColor: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(BuildContext context, FollowRequestCubit cubit) {
    // This is a simplified version - you'll need to adapt based on your actual data structure
    final clinicName = "Clinic Name"; // Replace with actual data
    final clinicImage = "clinic_image.jpg"; // Replace with actual data

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: Decorations.kDecorationBoxShadow(context: context),
        child: Row(
          children: [
            _buildClinicAvatar(clinicImage),
            const SizedBox(width: 10),
            _buildClinicInfoAndButtons(context, cubit, clinicName),
          ],
        ),
      ),
    );
  }

  Widget _buildClinicAvatar(String imagePath) {
    return CircleAvatar(
      radius: 30,
      backgroundImage: NetworkImage(
        imageUrl + imagePath,
      ),
    );
  }

  Widget _buildClinicInfoAndButtons(BuildContext context, FollowRequestCubit cubit, String clinicName) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          clinicName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        _buildActionButtons(context, cubit),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, FollowRequestCubit cubit) {
    return Row(
      children: [
        _buildAcceptButton(context, cubit),
        const SizedBox(width: 5),
        _buildIgnoreButton(context),
      ],
    );
  }

  Widget _buildAcceptButton(BuildContext context, FollowRequestCubit cubit) {
    final buttonWidth = MediaQuery.of(context).size.width * 0.3;

    return SizedBox(
      width: buttonWidth,
      child: ElevatedButton(
        onPressed: !cubit.isAccept ? () => _handleAcceptRequest(cubit) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: cubit.isAccept
              ? const CircularProgressIndicator()
              : Text(S.of(context).accept),
        ),
      ),
    );
  }

  void _handleAcceptRequest(FollowRequestCubit cubit) {
    // You'll need to adapt this based on your actual data structure
    final clinicCode = "clinic_code"; // Replace with actual data
    final clientId = "client_id"; // Replace with actual data
    final squeakUserId = CacheHelper.getData('clintId');

    cubit.acceptInvitation(
      clinicCode: clinicCode,
      clientId: clientId,
      squeakUserId: squeakUserId,
    );
  }

  Widget _buildIgnoreButton(BuildContext context) {
    final buttonWidth = MediaQuery.of(context).size.width * 0.3;

    return SizedBox(
      width: buttonWidth,
      child: ElevatedButton(
        onPressed: () => navigateAndFinish(context, LayoutScreen()),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(S.of(context).ignore),
        ),
      ),
    );
  }
}