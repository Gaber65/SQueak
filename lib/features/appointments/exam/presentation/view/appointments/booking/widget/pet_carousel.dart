import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/appointments/exam/data/models/client_clinic_model.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';

import '../../../../../../../pets/data/models/pet_model.dart';

// Extension to add isSelected property to PetClinicModel
extension PetClinicModelExtension on PetClinicModel {
  bool get isSelected => _selectedPetIds.contains(petSqueakId);
  set isSelected(bool value) {
    if (value) {
      _selectedPetIds.add(petSqueakId);
    } else {
      _selectedPetIds.remove(petSqueakId);
    }
  }
}

// Global set to track selected pet IDs
final Set<String> _selectedPetIds = {};

class PetCarousel extends StatelessWidget {
  final List<PetEntities> pets;
  final Function(dynamic) onPetSelected;
  final bool initializeFirstPet;

  const PetCarousel({
    super.key,
    required this.pets,
    required this.onPetSelected,
    this.initializeFirstPet = true,
  });

  @override
  Widget build(BuildContext context) {
    if (pets.isEmpty) {
      return Center(
        child: Text(
          isArabic()
              ? 'لا توجد حيوانات أليفة متاحة. ستتم إضافة حيوان أليف جديد.'
              : 'No pets available. A new pet will be added.',
          style: FontStyleThame.textStyle(
            context: context,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    // Initialize first pet if needed
    if (initializeFirstPet && pets.isNotEmpty) {
      Future.microtask(() {
        final firstPet = pets[0];
        onPetSelected(
          firstPet, // Default isSpayed to false since API doesn't provide it
        );

        // Mark first pet as selected
        for (var element in pets) {
          element.isSelected = false;
        }
        pets[0].isSelected = true;
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic() ? 'اختر حيوانك الأليف' : 'Select Your Pet',
          style: FontStyleThame.textStyle(
            context: context,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        CarouselSlider.builder(
          itemCount: pets.length,
          itemBuilder: (context, index, realIndex) {
            return InkWell(
              onTap: () {
                for (var element in pets) {
                  element.isSelected = false;
                }
                pets[index].isSelected = true;

                onPetSelected(pets[index]);
              },
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 5),
                decoration: Decorations.kDecorationBoxShadow(
                  context: context,
                  color:
                      pets[index].isSelected
                          ? MainCubit.get(context).isDark
                              ? Colors.grey[800]!
                              : Colors.grey[300]!
                          : MainCubit.get(context).isDark
                          ? Colors.black38
                          : Colors.white,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          AssetImageModel
                              .defaultPetImage, // Always use default image since API doesn't provide it
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        pets[index].petName ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          options: CarouselOptions(
            onPageChanged: (index, reason) {
              for (var element in pets) {
                element.isSelected = false;
              }

              pets[index].isSelected = true;

              onPetSelected(
                pets[index], // Default isSpayed to false since API doesn't provide it
              );
            },
            height: 80,
            aspectRatio: 1.5,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: false,
            reverse: false,
            autoPlay: false,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
          ),
        ),
        if (pets.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              isArabic()
                  ? 'اسحب للتبديل بين الحيوانات'
                  : 'Swipe to change pets',
              textAlign: TextAlign.center,
              style: FontStyleThame.textStyle(
                context: context,
                fontSize: 14,
                fontColor: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
