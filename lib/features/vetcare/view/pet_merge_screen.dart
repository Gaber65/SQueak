import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:squeak/core/utils/export_path/export_files.dart';

import 'package:squeak/features/layout/controller/layout_cubit.dart';
import 'package:squeak/features/layout/layout.dart';
import 'package:squeak/features/pets/view/pet_screen.dart';
import 'package:squeak/features/service/view/pet_vaccination.dart';
import 'package:squeak/features/vetcare/controller/vet_cubit.dart';
import '../models/vetIcare_client_model.dart';

class PetMergeScreen extends StatelessWidget {
  const PetMergeScreen({
    super.key,
    required this.Code,
    required this.isNavigation,
  });
  final String Code;
  final bool isNavigation;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VetCubit()..getClintFormVetVoid(Code, false),
      child: BlocConsumer<VetCubit, VetState>(
        listener: (context, state) {
          var cub = VetCubit.get(context);
          if (state is SuccessAddInSqueakStatuesState) {
            if (cub.vetClientModel.isNotEmpty) {
              cub.vetClientModel
                  .removeWhere((element) => element.id == state.id);

              if (cub.vetClientModel.isEmpty) {
                LayoutCubit.get(context).getOwnerPet();

                CacheHelper.removeData("CodeForce");

                final Widget targetScreen =
                    isNavigation ? LayoutScreen() : PetScreen();
                navigateAndFinish(context, targetScreen);
              }
            }
          }

          if (state is ErrorAddInSqueakStatuesState) {
            errorToast(
              context,
              state.error.errors.isNotEmpty
                  ? state.error.errors.values.first.first
                  : state.error.message,
            );
          }
        },
        builder: (context, state) {
          var cubitVet = VetCubit.get(context);
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(isArabic()
                    ? 'الحيوانات في vetIcare'
                    : 'Pets in vetIcare clinic'),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1.0),
                  child: (state is LoadingAddInSqueakStatuesState)
                      ? LinearProgressIndicator()
                      : Container(),
                ),
              ),
              body: !cubitVet.isGetVet
                  ? VacShimmer()
                  : cubitVet.vetClientModel.isEmpty
                      ? WillPopScope(
                          onWillPop: () async {
                            if (isNavigation) {
                              LayoutCubit.get(context).getOwnerPet();
                              LayoutCubit.get(context).getOwnerPet();
                              navigateAndFinish(context, LayoutScreen());
                            } else {
                              LayoutCubit.get(context).getOwnerPet();
                              navigateAndFinish(context, PetScreen());
                            }
                            return true;
                          },
                          child: Column(
                            children: [
                              Center(
                                child: FastCachedImage(
                                  url:
                                      'https://firebasestorage.googleapis.com/v0/b/squeak-c005f.appspot.com/o/no-data-concept-illustration.png?alt=media&token=a652ca7d-a387-4a8d-803f-3ef40999366a',
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                isArabic()
                                    ? 'لا توجد حيوانات أليفة في هذه العيادة، أو قد تم إضافتها بالفعل على SQueak'
                                    : 'No pets are available in this clinic, or they have already been added to SQueak',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: cubitVet.vetClientModel.length,
                          itemBuilder: (context, index) {
                            return buildPaddingItemPet(
                                context,
                                cubitVet.vetClientModel[index],
                                cubitVet,
                                state);
                          },
                        ),
            ),
          );
        },
      ),
    );
  }

  Padding buildPaddingItemPet(
    BuildContext context,
    VetClientModel model,
    VetCubit cubitVet,
    VetState state,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: Decorations.kDecorationBoxShadow(context: context),
        child: Row(
          children: [
            SizedBox(
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
            ),
            SizedBox(
              width: 7,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                          color: MainCubit.get(context).isDark
                              ? Colors.white
                              : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        cubitVet.emit(SuccessAddInSqueakStatuesState(model.id));
                      },
                      icon: Icon(
                        Icons.close,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: ElevatedButton(
                        onPressed: (state is LoadingAddInSqueakStatuesState)
                            ? null
                            : () {
                                cubitVet.addInSqueakStatues(
                                  vetCarePetId: model.id,
                                  statuesOfAddingPetToSqueak: 1,
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.green,
                          backgroundColor: MainCubit.get(context).isDark
                              ? ColorManager.myPetsBaseBlackColor
                              : Colors.green.shade100.withOpacity(.4),
                          elevation: 0,
                          shape: (RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                        ),
                        child: Text(
                            isArabic() ? 'اضافة الى Squeak' : 'Add to squeak',
                            style: TextStyle(
                              fontSize: 11,
                            )),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    if (LayoutCubit.get(context).pets.isNotEmpty)
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.40,
                        child: ElevatedButton(
                          onPressed: (state is LoadingAddInSqueakStatuesState)
                              ? null
                              : () {
                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (context) {
                                      return BlocConsumer<LayoutCubit,
                                          LayoutState>(
                                        listener: (context, state) {
                                          // TODO: implement listener
                                        },
                                        builder: (context, state) {
                                          final cubit =
                                              context.read<LayoutCubit>();

                                          return CupertinoActionSheet(
                                            title: Text(
                                              isArabic()
                                                  ? 'حيوانتك'
                                                  : 'Your SQueak Pet',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: MainCubit.get(context)
                                                        .isDark
                                                    ? Colors.white
                                                    : Colors.black87,
                                              ),
                                              textAlign: TextAlign.start,
                                            ),
                                            actions: cubit.pets.map((pet) {
                                              return CupertinoActionSheetAction(
                                                onPressed: () {
                                                  cubitVet.addInSqueakStatues(
                                                    vetCarePetId: model.id,
                                                    statuesOfAddingPetToSqueak:
                                                        2,
                                                    squeakPetId: pet.petId,
                                                  );
                                                  Navigator.pop(context);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 8.0,
                                                    right: 8.0,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 15,
                                                        backgroundImage:
                                                            NetworkImage(
                                                          pet.imageName
                                                                  .isNotEmpty
                                                              ? imageUrl +
                                                                  pet.imageName
                                                              : 'https://firebasestorage.googleapis.com/v0/b/squeak-c005f.appspot.com/o/painting-cat-with-gold-medallion-its-collar.jpg?alt=media&token=2fbc1736-9ee5-4feb-8ba8-c670fd1ecc57',
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 12,
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                        child: Text(
                                                          '${pet.petName}',
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: FontStyleThame
                                                              .textStyle(
                                                            context: context,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }).toList(), // Convert the Iterable to a List
                                            cancelButton:
                                                CupertinoActionSheetAction(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Cancel"),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.orange,
                            backgroundColor: MainCubit.get(context).isDark
                                ? ColorManager.myPetsBaseBlackColor
                                : Colors.orange.shade100.withOpacity(.4),
                            elevation: 0,
                            shape: (RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                          ),
                          child: Text(
                              isArabic()
                                  ? 'الارتباط أليف آخر'
                                  : 'Link another pet',
                              style: TextStyle(
                                fontSize: 11,
                              )),
                        ),
                      ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
