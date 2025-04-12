import 'dart:convert';

import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

import '../../../core/constant/global_function/global_function.dart';
import '../../../core/constant/global_widget/offline_widget.dart';
import '../../../core/helper/remotely/end-points.dart';
import '../../../core/thames/color_manager.dart';
import '../../../generated/l10n.dart';
import '../../service/view/service_page.dart';
import 'add_pet_detail.dart';
import 'edit_pet_detail.dart';

bool isSnackBarVisible = false;

class PetScreen extends StatelessWidget {
  const PetScreen({
    super.key,
  });

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
          }
        },
        builder: (context, state) {
          var cubit = PetCubit.get(context);
          return buildPetsScreen(context, cubit.pets, cubit);
        },
      ),
    );
  }

  Widget buildPetsScreen(BuildContext context, List<PetsData> dataPet, cubit) {
    return WillPopScope(
      onWillPop: () async {
        if (isSnackBarVisible) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          isSnackBarVisible = false;
          return false;
        } else {
          isSnackBarVisible = true;
          navigateAndFinish(context, LayoutScreen());
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(S.of(context).myPets),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () {
              if (isSnackBarVisible) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                isSnackBarVisible = false;
              } else {
                isSnackBarVisible = true;
                navigateAndFinish(context, LayoutScreen());
              }
            },
          ),
        ),
        body: dataPet.isEmpty
            ? buildEmptyPetsContent(
                context,
              )
            : ListView.builder(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return buildDetailsContent(
                    dataPet[index],
                    context,
                    cubit,
                  );
                },
                itemCount: dataPet.length,
              ),
        floatingActionButton: dataPet.isNotEmpty
            ? FloatingActionButton(
                backgroundColor: ColorTheme.primaryColor,
                foregroundColor: Colors.white,
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
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }
}

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

Widget buildDetailsContent(PetsData pet, context, PetCubit cubit) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        print(pet.breed);
        navigateToScreen(
          context,
          EditPet(
            pets: pet,
            breedData: cubit.allBreeds,
          ),
        );
      },
      child: Container(
        decoration: Decorations.kDecorationBoxShadow(context: context),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          '${pet.petName}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: FontStyleThame.textStyle(
                            context: context,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        pet.birthdate.isEmpty
                            ? pet.birthdate
                            : pet.birthdate.substring(0, 10),
                      ),
                    ],
                  ),
                  const Spacer(),
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      pet.imageName.toString().contains('PetAvatar') ||
                              pet.imageName.toString().isEmpty
                          ? 'https://img.freepik.com/free-vector/hand-drawn-animal-rescue-illustration_52683-109643.jpg?t=st=1724850971~exp=1724854571~hmac=310725afd1c40b0312d37d37e8cc8982f8cba5177dc34f988d94b9eccae6e977&w=826'
                          : '$imageUrl${pet.imageName}',
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.height * 0.01,
                  ),
                  OfflineWidget(
                    offlineChild: CircleAvatar(
                      backgroundColor: MainCubit.get(context).isDark
                          ? ColorManager.myPetsBaseBlackColor
                          : Colors.green.shade100.withOpacity(.4),
                      child: IconButton(
                        icon: Icon(
                          IconlyLight.calendar,
                        ),
                        color: MainCubit.get(context).isDark
                            ? Colors.white
                            : Colors.black,
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();

                          OfflineWidget.showOfflineWidget(context);
                        },
                      ),
                    ),
                    onlineChild: BlocConsumer<LayoutCubit, LayoutState>(
                      listener: (context, state) {
                        // TODO: implement listener
                      },
                      builder: (context, state) {
                        return CircleAvatar(
                          backgroundColor: MainCubit.get(context).isDark
                              ? ColorManager.myPetsBaseBlackColor
                              : Colors.green.shade100.withOpacity(.4),
                          child: IconButton(
                            icon: Icon(
                              IconlyLight.calendar,
                            ),
                            color: MainCubit.get(context).isDark
                                ? Colors.white
                                : Colors.black,
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              navigateToScreen(
                                context,
                                MySupplierScreen(
                                  petId: pet.petId,
                                  isSpayed: pet.isSpayed,
                                  petNameFromAppoinmentIcon: pet.petName,
                                  genderForPetFromAppoinmentScreen: pet.gender,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: [
                  Expanded(
                    child: OfflineWidget(
                      offlineChild: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();

                          OfflineWidget.showOfflineWidget(context);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.green,
                          backgroundColor:
                              Colors.green.shade100.withOpacity(.4),
                          elevation: 0,
                          shape: (RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          )),
                        ),
                        child: Text(
                          S.of(context).addPetService,
                          overflow: TextOverflow.ellipsis,
                          style: FontStyleThame.textStyle(
                              context: context, fontSize: 14),
                        ),
                      ),
                      onlineChild: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();

                          navigateToScreen(
                            context,
                            PetVaccination(
                              petModel: pet,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.green,
                          backgroundColor: MainCubit.get(context).isDark
                              ? ColorManager.myPetsBaseBlackColor
                              : Colors.green.shade100.withOpacity(.4),
                          elevation: 0,
                          shape: (RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          )),
                        ),
                        child: Text(
                          isArabic() ? "تذكيرات" : "Reminders",
                          overflow: TextOverflow.ellipsis,
                          style: FontStyleThame.textStyle(
                              context: context, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: OfflineWidget(
                      onlineChild: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();

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
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.red,
                          backgroundColor: MainCubit.get(context).isDark
                              ? ColorManager.myPetsBaseBlackColor
                              : Colors.red.shade100.withOpacity(.4),
                          elevation: 0,
                          shape: (RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          )),
                        ),
                        child: Text(
                          isArabic() ? 'حذف' : 'Delete',
                        ),
                      ),
                      offlineChild: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();

                          OfflineWidget.showOfflineWidget(context);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.red,
                          backgroundColor: MainCubit.get(context).isDark
                              ? ColorManager.myPetsBaseBlackColor
                              : Colors.red.shade100.withOpacity(.4),
                          elevation: 0,
                          shape: (RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          )),
                        ),
                        child: Text(
                          isArabic() ? 'حذف' : 'Delete',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
