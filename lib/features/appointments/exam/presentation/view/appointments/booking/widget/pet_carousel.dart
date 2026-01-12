// ignore_for_file: deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:squeak/core/service/global_widget/image_detail.dart';
import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/appointments/exam/data/models/client_clinic_model.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';

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
  final Function(PetEntities) onPetSelected;
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
        onPetSelected(firstPet);

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
        Row(
          children: [
            Icon(Icons.pets, color: ColorManager.primaryColor, size: 20),
            SizedBox(width: 8),
            Text(
              isArabic() ? 'اختر الأليف' : 'Select Your Pet',
              style: FontStyleThame.textStyle(
                context: context,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
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
                padding: const EdgeInsets.all(12), // padding: var(--spacing-20)
                decoration: BoxDecoration(
                  color:
                      pets[index].isSelected
                          ? ColorManager.primaryColor.withOpacity(0.1)
                          : Theme.of(context)
                              .colorScheme
                              .surface, // background: var(--surface-color)
                  borderRadius: BorderRadius.circular(
                    12,
                  ), // border-radius: var(--radius-12)
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                        0.05,
                      ), // rgba(0, 0, 0, 0.05)
                      blurRadius: 8, // 0 2px 8px
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Pet Image Circle
                    CircleAvatar(
                      radius: 33,
                      backgroundImage: SafeFastCachedImageProviderExtension.safe(imageUrl +
                            (pets[index].imageName?.isNotEmpty == true
                                ? pets[index].imageName!
                                : ""),
                      ),
                      child: Text(
                        pets[index].imageName?.isNotEmpty == true
                            ? ""
                            : pets[index].petName!.substring(0, 1),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    // Pet Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            pets[index].petName ?? 'Unknown Pet',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            pets[index].breed?.enBreed ?? 'Unknown Breed',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorManager.primaryColor.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  pets[index].gender == 2 ? 'Female' : 'Male',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: ColorManager.primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '• ${pets[index].birthdate!.isEmpty ? '' : formatAge(DateTime.parse(pets[index].birthdate!))}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Checkmark
                    if (pets[index].isSelected)
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.check, color: Colors.white, size: 20),
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
              onPetSelected(pets[index]);
            },
            height: 120,
            viewportFraction: 0.92,
            initialPage: 0,
            enableInfiniteScroll: false,
            reverse: false,
            autoPlay: false,
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
          ),
        ),
        if (pets.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pets.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        pets[index].isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade300,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
