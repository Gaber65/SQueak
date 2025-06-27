import 'package:flutter/material.dart';
import 'package:squeak/features/pets/presentation/view/add_pet_screen.dart';
import 'package:squeak/features/pets/presentation/view/widgets/get_pet/pet_card.dart';
import 'package:squeak/features/pets/presentation/view/widgets/get_pet/pet_type_option.dart';
import 'package:squeak/features/qr/presentation/view/new_scanner.dart';

import '../../../../../../core/utils/export_path/export_files.dart';
import '../../../../domain/entities/pet_entity.dart';
import '../../../controller/pet_cubit.dart';
import 'empty_state.dart';

class PetScreenContent extends StatefulWidget {
  final List<PetEntities> pets;
  final PetCubit cubit;
  final PetState state;

  const PetScreenContent({
    super.key,
    required this.pets,
    required this.cubit,
    required this.state,
  });

  @override
  State<PetScreenContent> createState() => _PetScreenContentState();
}

class _PetScreenContentState extends State<PetScreenContent> {
  bool _isSnackBarVisible = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isSnackBarVisible) {
          _hideSnackBar();
          return false;
        }
        _navigateToHome();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(S.of(context).myPets),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => _handleBackPress(),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(2.0),
            child:
                widget.state is DeletePetLoadingState
                    ? const LinearProgressIndicator()
                    : Container(),
          ),
        ),
        body:
            widget.pets.isEmpty
                ? EmptyState(
                  onAddPetPressed: () => showPetTypeSelection(context),
                )
                : _buildPetList(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorManager.primaryColor,
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () => showPetTypeSelection(context),
        ),
      ),
    );
  }

  Widget _buildPetList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: widget.pets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return PetCard(pet: widget.pets[index], cubit: widget.cubit);
      },
    );
  }

  void _handleBackPress() {
    if (_isSnackBarVisible) {
      _hideSnackBar();
    } else {
      _navigateToHome();
    }
  }

  void _hideSnackBar() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    setState(() => _isSnackBarVisible = false);
  }

  void _navigateToHome() {
    navigateAndFinish(context, const LayoutScreen());
  }
}

void showPetTypeSelection(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              S.of(context).selectPetType,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: PetTypeOption(
                    image: 'assets/cat-with-gold.jpg',
                    label: isArabic() ? 'قطة' : 'Cat',
                    onTap:
                        () => navigateToAddPet(
                          isArabic() ? 'قطة' : 'Cat',
                          'assets/cat-with-gold.jpg',
                          'f1131363-3b9f-40ee-9a89-0573ee274a10',
                          context,
                        ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: PetTypeOption(
                    image: 'assets/dog.png',
                    label: isArabic() ? 'كلب' : 'Dog',
                    onTap:
                        () => navigateToAddPet(
                          isArabic() ? 'كلب' : 'Dog',
                          'assets/dog.png',
                          'bca48207-f05d-4e9f-a631-06f34eb5af39',
                          context,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      );
    },
  );
}

void navigateToAddPet(
  String speciesName,
  String imagePath,
  String speciesId,
  BuildContext context,
) {
  Navigator.pop(context);
  navigateToScreen(
    context,
    AddPetScreen(
      dropdownValueSpecies: speciesName,
      pathImage: imagePath,
      species: speciesId,
    ),
  );
}
