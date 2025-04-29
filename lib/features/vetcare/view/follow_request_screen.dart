import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import 'package:squeak/features/service/view/pet_vaccination.dart';
import 'package:squeak/features/vetcare/controller/vet_cubit.dart';
import 'package:squeak/features/vetcare/view/pet_merge_screen.dart';
import '../../../generated/l10n.dart';
import '../../layout/layout.dart';

class FollowRequestScreen extends StatelessWidget {
  const FollowRequestScreen({super.key, required this.ClinicID});

  final String ClinicID;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              VetCubit()
                ..getClinicbyID(ClinicID)
                ..getNotifications(ClinicID),
      child: _FollowRequestContent(),
    );
  }
}

class _FollowRequestContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VetCubit, VetState>(
      listener: _handleStateChanges,
      builder: (context, state) {
        final cubit = VetCubit.get(context);
        return WillPopScope(
          onWillPop: () => _handleBackNavigation(context),
          child: Scaffold(
            appBar: _buildAppBar(context),
            body: _buildBody(context, cubit),
          ),
        );
      },
    );
  }

  void _handleStateChanges(BuildContext context, VetState state) {
    if (state is ErrorAcceptIvationState) {
      _showErrorToast(context, state);
    }
    if (state is SuccessAcceptIvationState) {
      _handleAcceptanceSuccess(context, state);
    }
  }

  void _showErrorToast(BuildContext context, ErrorAcceptIvationState state) {
    final errorMessage =
        state.error.errors.isNotEmpty
            ? state.error.errors.values.first.first
            : state.error.message;
    errorToast(context, errorMessage);
  }

  void _handleAcceptanceSuccess(
    BuildContext context,
    SuccessAcceptIvationState state,
  ) {
    final nextScreen =
        state.isHavePet
            ? PetMergeScreen(
              Code: VetCubit.get(context).entities!.code,
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

  Widget _buildBody(BuildContext context, VetCubit cubit) {
    if (cubit.entities == null) return VacShimmer();
    if (!cubit.isGetClinic) return _buildUnavailableRequestView(context);

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

  Widget _buildRequestCard(BuildContext context, VetCubit cubit) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: Decorations.kDecorationBoxShadow(context: context),
        child: Row(
          children: [
            _buildClinicAvatar(cubit),
            const SizedBox(width: 10),
            _buildClinicInfoAndButtons(context, cubit),
          ],
        ),
      ),
    );
  }

  Widget _buildClinicAvatar(VetCubit cubit) {
    return CircleAvatar(
      radius: 30,
      backgroundImage: NetworkImage(
        imageUrl + cubit.entities!.image.toString(),
      ),
    );
  }

  Widget _buildClinicInfoAndButtons(BuildContext context, VetCubit cubit) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          cubit.entities!.name.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        _buildActionButtons(context, cubit),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, VetCubit cubit) {
    return Row(
      children: [
        _buildAcceptButton(context, cubit),
        const SizedBox(width: 5),
        _buildIgnoreButton(context),
      ],
    );
  }

  Widget _buildAcceptButton(BuildContext context, VetCubit cubit) {
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
          child:
              cubit.isAccept
                  ? const CircularProgressIndicator()
                  : Text(S.of(context).accept),
        ),
      ),
    );
  }

  void _handleAcceptRequest(VetCubit cubit) {
    cubit.acceptIvation(
      clinicCode: cubit.entities!.code,
      clientId: cubit.vetClientModelOne!.vetICareId,
      squeakUserId: CacheHelper.getData('clintId'),
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
