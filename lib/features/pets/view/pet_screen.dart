import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/core/constant/global_widget/responsive_screen.dart';
import 'package:squeak/core/helper/build_service/main_cubit/main_cubit.dart';
import 'package:squeak/core/thames/decorations.dart';
import 'package:squeak/core/thames/styles.dart';
import 'package:squeak/features/appointments/view/supplier/get_supplier.dart';
import 'package:squeak/features/layout/controller/layout_cubit.dart';
import 'package:squeak/features/layout/layout.dart';
import 'package:squeak/features/pets/models/pet_model.dart';
import 'package:squeak/features/pets/controller/pet_cubit.dart';
import 'package:squeak/features/service/view/pet_vaccination.dart';
import 'package:squeak/core/constant/global_function/global_function.dart';
import 'package:squeak/core/constant/global_widget/offline_widget.dart';
import 'package:squeak/core/helper/remotely/end-points.dart';
import 'package:squeak/core/thames/color_manager.dart';
import 'package:squeak/generated/l10n.dart';
import 'add_pet_detail.dart';
import 'edit_pet_detail.dart';

class PetScreen extends StatelessWidget {
  const PetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PetCubit()
        ..getAllBreed()
        ..getOwnerPet(),
      child: BlocConsumer<PetCubit, PetState>(
        listener: (context, state) {
          if (state is DeletePetSuccessState) {
            LayoutCubit.get(context).getOwnerPet();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).petDeletedSuccessfully),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = PetCubit.get(context);
          return _PetScreenContent(pets: cubit.pets, cubit: cubit);
        },
      ),
    );
  }
}

class _PetScreenContent extends StatefulWidget {
  final List<PetsData> pets;
  final PetCubit cubit;

  const _PetScreenContent({required this.pets, required this.cubit});

  @override
  State<_PetScreenContent> createState() => _PetScreenContentState();
}

class _PetScreenContentState extends State<_PetScreenContent> {
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
        ),
        body: widget.pets.isEmpty
            ? buildEmptyState()
            : _buildPetList(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorTheme.primaryColor,
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () => _showPetTypeSelection(),
        ),
      ),
    );
  }

  /// handle the string here
  Widget buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 80,
            backgroundImage: FastCachedImageProvider(
                'https://firebasestorage.googleapis.com/v0/b/squeak-c005f.appspot.com/o/happy-pets-animal-ai-art-388_720x.webp?alt=media&token=eee507ff-48c5-450d-88d9-4203537ed79b'),
          ),
          const SizedBox(height: 24),
          Text(
            S.of(context).noPetsFound,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorTheme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: _showPetTypeSelection,
            child: Text(S.of(context).addYourFirstPet),
          ),
        ],
      ),
    );
  }

  Widget _buildPetList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: widget.pets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _PetCard(pet: widget.pets[index], cubit: widget.cubit);
      },
    );
  }

  void _showPetTypeSelection() {
    showModalBottomSheet(
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
                      child: _PetTypeOption(
                        image: 'assets/cat-with-gold.jpg',
                        label: isArabic() ? 'قطة' : 'Cat',
                        onTap: () => _navigateToAddPet(
                          isArabic() ? 'قطة' : 'Cat',
                          'assets/cat-with-gold.jpg',
                          'f1131363-3b9f-40ee-9a89-0573ee274a10',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _PetTypeOption(
                        image: 'assets/dog.png',
                        label: isArabic() ? 'كلب' : 'Dog',
                        onTap: () => _navigateToAddPet(
                          isArabic() ? 'كلب' : 'Dog',
                          'assets/dog.png',
                          'bca48207-f05d-4e9f-a631-06f34eb5af39',
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

        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),

        ));
  }

  void _navigateToAddPet(String speciesName, String imagePath, String speciesId) {
    Navigator.pop(context);
    navigateToScreen(
      context,
      AddPet(
        dropdownValueSpecies: speciesName,
        pathImage: imagePath,
        species: speciesId,
      ),
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

class _PetCard extends StatelessWidget {
  final PetsData pet;
  final PetCubit cubit;

  const _PetCard({required this.pet, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _navigateToEditPet(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildPetHeader(context),
              const SizedBox(height: 16),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPetHeader(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(
            pet.imageName.toString().contains('PetAvatar') ||
                pet.imageName.toString().isEmpty
                ? 'https://img.freepik.com/free-vector/hand-drawn-animal-rescue-illustration_52683-109643.jpg?t=st=1724850971~exp=1724854571~hmac=310725afd1c40b0312d37d37e8cc8982f8cba5177dc34f988d94b9eccae6e977&w=826'
                : '$imageUrl${pet.imageName}',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pet.petName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                pet.birthdate.isEmpty
                    ? ''
                    : pet.birthdate.substring(0, 10),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        _buildCalendarButton(context),
      ],
    );
  }

  Widget _buildCalendarButton(BuildContext context) {
    return OfflineWidget(
      offlineChild: _IconCircle(
        icon: IconlyLight.calendar,
        onPressed: () => OfflineWidget.showOfflineWidget(context),
      ),
      onlineChild: _IconCircle(
        icon: IconlyLight.calendar,
        onPressed: () => navigateToScreen(
          context,
          MySupplierScreen(
            petId: pet.petId,
            isSpayed: pet.isSpayed,
            petNameFromAppoinmentIcon: pet.petName,
            genderForPetFromAppoinmentScreen: pet.gender,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OfflineWidget(
            offlineChild: _ActionButton(
              text: S.of(context).addPetService,
              color: Colors.green,
              onPressed: () => OfflineWidget.showOfflineWidget(context),
            ),
            onlineChild: _ActionButton(
              text: isArabic() ? "تذكيرات" : "Reminders",
              color: Colors.green,
              onPressed: () => navigateToScreen(
                context,
                PetVaccination(petModel: pet),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OfflineWidget(
            offlineChild: _ActionButton(
              text: isArabic() ? 'حذف' : 'Delete',
              color: Colors.red,
              onPressed: () => OfflineWidget.showOfflineWidget(context),
            ),
            onlineChild: _ActionButton(
              text: isArabic() ? 'حذف' : 'Delete',
              color: Colors.red,
              onPressed: () => _showDeleteConfirmation(context),
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToEditPet(BuildContext context) {
    navigateToScreen(
      context,
      EditPet(
        pets: pet,
        breedData: cubit.allBreeds,
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showCustomConfirmationDialog(
      context: context,
      description: isArabic()
          ? Text.rich(
        TextSpan(
          text: 'هل أنت متأكد أنك تريد حذف ',
          children: [
            TextSpan(
              text: pet.petName,
              style: TextStyle(
                  fontWeight: FontWeight.bold),
            ),
            TextSpan(text: '?'),
          ],
        ),
      )
          : Text.rich(
        TextSpan(
          text: 'Are you sure you want to delete ',
          children: [
            TextSpan(
              text: pet.petName,
              style: TextStyle(
                  fontWeight: FontWeight.bold),
            ),
            TextSpan(text: '?'),
          ],
        ),
      ),
      imageUrl:
      'https://img.freepik.com/premium-vector/sad-dog_161669-74.jpg?size=626&ext=jpg&uid=R78903714&ga=GA1.2.131510781.1692744483&semt=ais',
      onConfirm: () async {
        await cubit.deletePet( pet.petId);
        Navigator.of(context).pop(
            true); // You can pop with true to signal confirmation.
      },
    );
  }
}

class _PetTypeOption extends StatelessWidget {
  final String image;
  final String label;
  final VoidCallback onTap;

  const _PetTypeOption({
    required this.image,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              image,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _IconCircle extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _IconCircle({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: MainCubit.get(context).isDark
          ? ColorManager.myPetsBaseBlackColor
          : Colors.green.shade100.withOpacity(.4),
      child: IconButton(
        icon: Icon(icon),
        color: MainCubit.get(context).isDark ? Colors.white : Colors.black,
        onPressed: onPressed,
        iconSize: 20,
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: color,
        backgroundColor: MainCubit.get(context).isDark
            ? ColorManager.myPetsBaseBlackColor
            : color.withOpacity(0.1),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }



}



//////////////////////////////////////////////////////////////

bool isSnackBarVisible = false;


SnackBar buildSnackBar(
    BuildContext context,
    ) {
  return SnackBar(
    backgroundColor:
    MainCubit.get(context).isDark ? Colors.black26 : Colors.black54,
    duration: const Duration(seconds: 5),
    onVisible: () {
      // Automatically set the flag when SnackBar becomes visible
      isSnackBarVisible = true;
    },
    content: Row(
      children: [
        Expanded(
          child: Container(
            height: ResponsiveScreen.isMobile(context)
                ? MediaQuery.of(context).size.height / 5
                : MediaQuery.of(context).size.height / 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/cat-with-gold.jpg'),
              ),
            ),
            child: MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                navigateToScreen(
                  context,

                  /// TODO : Mohamed Elkerm hard coded values (Wronggggggggggggggggg!!!!!!!!!!!!!!!!)
                  AddPet(
                    dropdownValueSpecies: isArabic() ? 'قطة' : 'Cat',
                    pathImage: 'assets/cat-with-gold.jpg',
                    species: 'f1131363-3b9f-40ee-9a89-0573ee274a10',
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Container(
            height: ResponsiveScreen.isMobile(context)
                ? MediaQuery.of(context).size.height / 5
                : MediaQuery.of(context).size.height / 3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/dog.png'),
              ),
            ),
            child: MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                navigateToScreen(
                  context,
                  AddPet(
                    dropdownValueSpecies: isArabic() ? 'كلب' : 'Dog',
                    pathImage: 'assets/dog.png',
                    species: 'bca48207-f05d-4e9f-a631-06f34eb5af39',
                  ),
                );
              },
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildEmptyPetsContent(
    BuildContext context,
    ) {
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundImage: FastCachedImageProvider(
              'https://firebasestorage.googleapis.com/v0/b/squeak-c005f.appspot.com/o/happy-pets-animal-ai-art-388_720x.webp?alt=media&token=eee507ff-48c5-450d-88d9-4203537ed79b'),
          radius: 70,
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            if (isSnackBarVisible) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              isSnackBarVisible = false;
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(buildSnackBar(context));
              isSnackBarVisible = true;
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.red,
            backgroundColor: Colors.red.shade100.withOpacity(.4),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(isArabic() ? S.of(context).addPet : 'Add New Pet'),
        ),
      ],
    ),
  );
}
