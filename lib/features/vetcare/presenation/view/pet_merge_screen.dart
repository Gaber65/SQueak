// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, deprecated_member_use

import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/pets/presentation/controller/pet_cubit.dart';
import 'package:squeak/features/vaccination/presentation/widgets/vaccination_loading.dart';

import '../../../pets/presentation/view/pet_screen.dart';
import '../../domain/entities/vet_client.dart';
import '../controllers/pet_async/pet_async_cubit.dart';

class PetMergeScreen extends StatelessWidget {
  const PetMergeScreen({
    super.key,
    required this.code,
    required this.isNavigation,
  });
  final String code;
  final bool isNavigation;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              sl<PetAsyncCubit>()..getClientsFromVet(
                code,
                CacheHelper.getData('phone') ?? '',
                false,
              ),

      child: _PetMergeContent(isNavigation: isNavigation),
    );
  }
}

class _PetMergeContent extends StatelessWidget {
  final bool isNavigation;

  const _PetMergeContent({required this.isNavigation});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PetAsyncCubit, PetAsyncState>(
      listener: (context, state) {
        var cubit = PetAsyncCubit.get(context);
        if (state is SuccessAddInSqueakStatuesState) {
          if (cubit.vetClientModel.isNotEmpty) {
            cubit.vetClientModel.removeWhere((element) {
              return element.id == state.petId;
            });

            if (cubit.vetClientModel.isEmpty) {
              _completeMergeProcess(context);
            }
          }
        }
        if (state is ErrorAddInSqueakStatuesState) {
          _showErrorToast(context, state);
        }
      },
      builder: (context, state) {
        final cubit = PetAsyncCubit.get(context);
        return WillPopScope(
          onWillPop: () => _handleBackNavigation(context),
          child: Scaffold(
            appBar: _buildAppBar(context, state),
            body: _buildBody(context, cubit),
          ),
        );
      },
    );
  }

  void _completeMergeProcess(BuildContext context) {
    // LayoutCubit.get(context).getOwnerPet();
    CacheHelper.removeData("CodeForce");

    final targetScreen = isNavigation ? LayoutScreen() : PetScreen();
    navigateAndFinish(context, targetScreen);
  }

  void _showErrorToast(
    BuildContext context,
    ErrorAddInSqueakStatuesState state,
  ) {
    final errorMessage =
        state.error.errors.isNotEmpty
            ? state.error.errors.values.first.first
            : state.error.message;
    errorToast(context, errorMessage);
  }

  Future<bool> _handleBackNavigation(BuildContext context) async {
    return false;
  }

  AppBar _buildAppBar(BuildContext context, PetAsyncState state) {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => navigateAndFinish(context, LayoutScreen()),
      ),
      // automaticallyImplyLeading: false,
      title: Text(S.of(context).petsVetICare),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child:
            (state is LoadingAddInSqueakStatuesState)
                ? const LinearProgressIndicator()
                : Container(),
      ),
    );
  }

  Widget _buildBody(BuildContext context, PetAsyncCubit cubit) {
    if (!cubit.isGetVet) return VaccinationLoading();
    if (cubit.vetClientModel.isEmpty) return _buildEmptyStateView(context);

    return _buildPetListView(context, cubit);
  }

  Widget _buildEmptyStateView(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _handleEmptyStateBackNavigation(context),
      child: Column(
        children: [
          Center(
            child: FastCachedImage(
              url:
                  'https://firebasestorage.googleapis.com/v0/b/squeak-c005f.appspot.com/o/no-data-concept-illustration.png?alt=media&token=a652ca7d-a387-4a8d-803f-3ef40999366a',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            S.of(context).noPetsInVetICare,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<bool> _handleEmptyStateBackNavigation(BuildContext context) async {
    if (isNavigation) {
      navigateAndFinish(context, LayoutScreen());
    } else {
      navigateAndFinish(context, PetScreen());
    }
    return true;
  }

  Widget _buildPetListView(BuildContext context, PetAsyncCubit cubit) {
    return ListView.builder(
      itemCount: cubit.vetClientModel.length,
      itemBuilder: (context, index) {
        return _buildPetItem(context, cubit.vetClientModel[index], cubit);
      },
    );
  }

  Widget _buildPetItem(
    BuildContext context,
    VetClient model,
    PetAsyncCubit cubit,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: Decorations.kDecorationBoxShadow(context: context),
        child: Row(
          children: [
            _buildPetAvatar(context, model),
            const SizedBox(width: 7),
            _buildPetInfoAndActions(context, model, cubit),
          ],
        ),
      ),
    );
  }

  Widget _buildPetAvatar(BuildContext context, VetClient model) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.14,
      child: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(
          model.imageName.isNotEmpty
              ? ConfigModel.serverFirstHalfOfImageUrl +
                  model.imageName.toString()
              : 'https://firebasestorage.googleapis.com/v0/b/squeak-c005f.appspot.com/o/painting-cat-with-gold-medallion-its-collar.jpg?alt=media&token=2fbc1736-9ee5-4feb-8ba8-c670fd1ecc57',
        ),
      ),
    );
  }

  Widget _buildPetInfoAndActions(
    BuildContext context,
    VetClient model,
    PetAsyncCubit cubit,
  ) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPetNameRow(context, model, cubit),
          const SizedBox(height: 5),
          _buildActionButtons(context, model, cubit),
        ],
      ),
    );
  }

  Widget _buildPetNameRow(
    BuildContext context,
    VetClient model,
    PetAsyncCubit cubit,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.62,
          child: Text(
            model.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              color:
                  MainCubit.get(context).isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            // This should be handled by the cubit
            // For now, we'll simulate the success state
            cubit.emit(SuccessAddInSqueakStatuesState(model.id));
          },
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    VetClient model,
    PetAsyncCubit cubit,
  ) {
    return Row(
      children: [
        _buildAddToSqueakButton(context, model, cubit),
        const SizedBox(width: 5),
        _buildLinkPetButton(context, model, cubit),
      ],
    );
  }

  Widget _buildAddToSqueakButton(
    BuildContext context,
    VetClient model,
    PetAsyncCubit cubit,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.35,
      child: ElevatedButton(
        onPressed:
            cubit.state is LoadingAddInSqueakStatuesState
                ? null
                : () => _handleAddToSqueak(cubit, model),
        style: _getActionButtonStyle(context, Colors.green),
        child: Text(
          S.of(context).addToSqueak,
          style: const TextStyle(fontSize: 11),
        ),
      ),
    );
  }

  void _handleAddToSqueak(PetAsyncCubit cubit, VetClient model) {
    cubit.addInSqueakStatues(
      vetCarePetId: model.id,
      statuesOfAddingPetToSqueak: 1,
    );
  }

  Widget _buildLinkPetButton(
    BuildContext context,
    VetClient model,
    PetAsyncCubit cubit,
  ) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.40,
      child: ElevatedButton(
        onPressed:
            cubit.state is LoadingAddInSqueakStatuesState
                ? null
                : () => _showLinkPetDialog(context, model, cubit),
        style: _getActionButtonStyle(context, Colors.orange),
        child: Text(
          S.of(context).linkAnotherPet,
          style: const TextStyle(fontSize: 11),
        ),
      ),
    );
  }

  ButtonStyle _getActionButtonStyle(BuildContext context, Color color) {
    return ElevatedButton.styleFrom(
      foregroundColor: color,
      backgroundColor:
          MainCubit.get(context).isDark
              ? ColorManager.myPetsBaseBlackColor
              : color.withOpacity(0.2),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  void _showLinkPetDialog(
    BuildContext context,
    VetClient model,
    PetAsyncCubit cubit,
  ) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => _buildPetSelectionDialog(context, model, cubit),
    );
  }

  Widget _buildPetSelectionDialog(
    BuildContext context,
    VetClient model,
    PetAsyncCubit cubitVet,
  ) {
    return BlocProvider(
      create: (context) => sl<PetCubit>()..getOwnerPets(),
      child: BlocConsumer<PetCubit, PetState>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = context.read<PetCubit>();
          return CupertinoActionSheet(
            title: Text(
              S.of(context).yourPets,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color:
                    MainCubit.get(context).isDark
                        ? Colors.white
                        : Colors.black87,
              ),
              textAlign: TextAlign.start,
            ),
            actions:
                cubit.pets.map((pet) {
                  return CupertinoActionSheetAction(
                    onPressed: () {
                      cubitVet.addInSqueakStatues(
                        vetCarePetId: model.id,
                        statuesOfAddingPetToSqueak: 2,
                        squeakPetId: pet.petId,
                      );
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 15,
                            backgroundImage: NetworkImage(
                              (pet.imageName?.isNotEmpty ?? false)
                                  ? imageUrl + pet.imageName!
                                  : 'https://firebasestorage.googleapis.com/v0/b/squeak-c005f.appspot.com/o/painting-cat-with-gold-medallion-its-collar.jpg?alt=media&token=2fbc1736-9ee5-4feb-8ba8-c670fd1ecc57',
                            ),
                          ),
                          SizedBox(width: 12),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(
                              pet.petName ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: FontStyleThame.textStyle(context: context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          );
        },
      ),
    );
  }
}
