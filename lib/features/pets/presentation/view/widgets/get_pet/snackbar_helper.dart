import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/pets/presentation/view/add_pet_screen.dart';


bool isSnackBarVisible = false;

SnackBar buildPetSelectionSnackBar(BuildContext context) {
  return SnackBar(
    backgroundColor:
        MainCubit.get(context).isDark ? Colors.black26 : Colors.black54,
    duration: const Duration(seconds: 5),
    onVisible: () {
      isSnackBarVisible = true;
    },
    content: Row(
      children: [
        Expanded(
          child: Container(
            height:
                ResponsiveScreen.isMobile(context)
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
                  AddPetScreen(
                    dropdownValueSpecies: isArabic() ? 'قطة' : 'Cat',
                    pathImage: 'assets/cat-with-gold.jpg',
                    species: 'f1131363-3b9f-40ee-9a89-0573ee274a10',
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Container(
            height:
                ResponsiveScreen.isMobile(context)
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
                  AddPetScreen(
                    species: isArabic() ? 'كلب' : 'Dog',
                    pathImage: 'assets/dog.png',
                    dropdownValueSpecies:
                        'bca48207-f05d-4e9f-a631-06f34eb5af39',
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
