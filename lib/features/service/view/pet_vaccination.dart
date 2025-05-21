import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/pets/data/models/pet_model.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import 'package:squeak/features/service/controller/vac_cubit/vaccination_cubit.dart';
import 'package:squeak/features/service/models/vaccination_entities.dart';


import '../../../generated/l10n.dart';
import 'component/record_components.dart';

class PetVaccination extends StatelessWidget {
  PetVaccination({
    super.key,
    required this.petModel,
  });

  final PetEntities petModel;

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VaccinationCubit()
        ..getVaccinationName()
        ..getVacPet(petId: petModel.petId),
      child: BlocConsumer<VaccinationCubit, VaccinationState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = VaccinationCubit.get(context);
          return WillPopScope(
            onWillPop: () async {
              if (cubit.isButtonSheetShown) {
                cubit.isButtonSheetShown = false;
                cubit.valueIdItem = '';
                cubit.valueVacItem =
                    isArabic() ? 'اختر نوع الخدمة' : 'Select Service';
                cubit.otherController.clear();
                cubit.emit(ChangeStateVacState());
                return false;
              } else {
                Navigator.pop(context);
                return true;
              }
            },
            child: Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                centerTitle: true,
                title: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: S.of(context).addRecord,
                      ),
                      TextSpan(
                        text: isArabic() ? ' ل ' : ' For ',
                      ),
                      TextSpan(
                        text: petModel.petName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              body: cubit.isVacLoading
                  ? VacShimmer()
                  : Column(
                      children: [
                        // Container(
                        //   color: Colors.red,
                        //   height: MediaQuery.of(context).size.height*0.05,
                        //   child: Row(
                        //     children: [
                        //       InputChip(
                        //         label: Text('Input 1'),
                        //         onSelected: (bool value) {},
                        //       ),
                        //       InputChip(
                        //         label: Text('Input 2'),
                        //         onSelected: (bool value) {},
                        //       ),
                        //       InputChip(
                        //         label: Text('Input 3'),
                        //         onSelected: (bool value) {},
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Expanded(
                          child: buildConditional(
                            model: cubit.petVacs,
                            context: context,
                            contextBloc: context,
                            petModel: petModel,
                            cubit: cubit,
                            listOfServices: cubit.listOfServices,
                            vacEntitiesData: cubit.vaccinationName,
                          ),
                        ),
                      ],
                    ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.startFloat,
              floatingActionButton: cubit.isButtonSheetShown
                  ? null
                  : FloatingActionButton(
                      backgroundColor: ColorManager.primaryColor,
                      child: cubit.isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Icon(cubit.isButtonSheetShown
                              ? Icons.done
                              : Icons.add),
                      onPressed: () {
                        if (cubit.valueIdItem.isNotEmpty) {
                          DateTime tomorrowDateItem =
                              cubit.currentDateItem.add(Duration(days: 1));
                          print("1111111111111");
                          cubit.createVac(
                            petId: petModel.petId,
                            data: (cubit.currentDateItem
                                        .toString()
                                        .substring(0, 10) ==
                                    DateTime.now().toString().substring(0, 10))
                                ? tomorrowDateItem.toString().substring(0, 10)
                                : cubit.currentDateItem
                                    .toString()
                                    .substring(0, 10),
                            comments: commentController.text,
                            typeId: cubit.valueIdItem,
                            valueVacItem: cubit.valueVacItem,
                            context: context,
                            petName: petModel.petName,
                          );
                          cubit.valueVacItem =
                              isArabic() ? 'اختر نوع الخدمة' : 'Select Service';
                          cubit.valueFeedItem = isArabic()
                              ? 'اختر نوع الطعام'
                              : 'Select Feed Type';
                          cubit.valueIdItem = '';
                          commentController.clear();
                          cubit.isButtonSheetShown = false;
                          cubit.emit(ChangeStateVacState());
                        } else {
                          cubit.changeBottomSheetShow(
                              isShow: cubit.isButtonSheetShown);
                        }
                      },
                    ),
              bottomSheet: cubit.isButtonSheetShown
                  ? SizedBox(
                      height: 350,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: formKey,
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Close the keyboard
                                },
                                child: buildDropDownBreed(
                                  cubit.vaccinationName,
                                  context,
                                ),
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  cubit.selectTime(context);
                                },
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(cubit.picked == null
                                            ? "Select the time"
                                            : "${cubit.picked!.hour} : ${cubit.picked!.minute}"
                                        // cubit.picked == null ? "Select the time" : "${cubit.picked!.hour} : ${cubit.picked!.minute}"
                                        ),
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: MainCubit.get(context).isDark
                                        ? Colors.black26
                                        : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(
                                      8.0,
                                    ),
                                  ),
                                ),
                              ),
                              cubit.valueVacItem == "other" ||
                                      cubit.valueVacItem == "أخرى"
                                  ? const SizedBox(height: 10)
                                  : SizedBox(),
                              cubit.valueVacItem == "other" ||
                                      cubit.valueVacItem == "أخرى"
                                  ? GestureDetector(
                                      onTap: () {
                                        // Close the keyboard
                                      },
                                      child: MyTextForm(
                                        controller: cubit.otherController,
                                        prefixIcon: SizedBox(),
                                        maxLines: 1,
                                        enable: false,
                                        hintText:
                                            S.of(context).reminderOtherHintText,
                                        obscureText: false,
                                      ),
                                    )
                                  : SizedBox(),
                              cubit.valueVacItem == "Feed" ||
                                      cubit.valueVacItem == "اطعام"
                                  ? const SizedBox(height: 10)
                                  : SizedBox(),
                              cubit.valueVacItem == "Feed" ||
                                      cubit.valueVacItem == "اطعام"
                                  ? GestureDetector(
                                      onTap: () {
                                        // Close the keyboard
                                      },
                                      child: buildDropDownFeedSubType(
                                        cubit.feedSubType,
                                        context,
                                      ),
                                    )
                                  : SizedBox(),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  // Close the keyboard
                                },
                                child: buildDropDownFreq(
                                  cubit.reminderFreq,
                                  context,
                                ),
                              ),
                              const SizedBox(height: 10),
                              buildSelectDateVac(context, cubit),
                              const SizedBox(height: 10),
                              MyTextForm(
                                controller: commentController,
                                prefixIcon: SizedBox(),
                                maxLines: 5,
                                enable: false,
                                hintText: isArabic()
                                    ? 'الرجاء ادخال عنوان التلقيح '
                                    : 'Please enter your vaccination comment',
                                validatorText: null,
                                obscureText: false,
                              ),
                              const SizedBox(height: 30),
                              CustomElevatedButton(
                                isLoading: cubit.isLoading,
                                formKey: formKey,
                                onPressed: () {
                                  DateTime tomorrowDateItem = cubit
                                      .currentDateItem
                                      .add(Duration(days: 1));
                                  print("222222222");
                                  if (cubit.picked == null) {
                                    errorToast(
                                        context,
                                        isArabic()
                                            ? "الرجاء اختيار الوقت"
                                            : "Please select the time");
                                    cubit.isLoading = false;
                                    return;
                                  } else {
                                    cubit
                                        .createVac(
                                      petId: petModel.petId,
                                      data: (cubit.currentDateItem
                                                  .toString()
                                                  .substring(0, 10) ==
                                              DateTime.now()
                                                  .toString()
                                                  .substring(0, 10))
                                          ? cubit.currentDateItem
                                              .toString()
                                              .substring(0, 10)
                                          : cubit.currentDateItem
                                              .toString()
                                              .substring(0, 10),
                                      comments: commentController.text,
                                      typeId: cubit.valueIdItem,
                                      valueVacItem: cubit.valueVacItem,
                                      context: context,
                                      petName: petModel.petName,
                                    )
                                        .then((e) {
                                      commentController.clear();
                                      cubit.feedSubTypeValue = '';
                                      cubit.valueVacItem = isArabic()
                                          ? 'اختر نوع الخدمة'
                                          : 'Select Service';
                                      cubit.feedSubTypeValue = isArabic()
                                          ? 'نوع معين الطعام'
                                          : 'select feed sub type';
                                    });
                                  }
                                },
                                buttonText: S.of(context).save,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }

  Widget buildDropDownBreed(
    List<VaccinationNameModel> vacEntitiesData,
    context,
  ) {
    return DropdownButtonFormField<VaccinationNameModel>(
      decoration: buildInputDecoration(context),
      isExpanded: true,
      iconSize: 18,
      menuMaxHeight: 200,
      validator: (value) {
        if (value == null || value.vacName == '') {
          return isArabic()
              ? 'الرجاء اختيار نوع التلقيح'
              : 'Please select vaccination type';
        }
        return null;
      },
      iconEnabledColor: Colors.black,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      hint: Text(VaccinationCubit.get(context).valueVacItem),
      onChanged: (newValue) {
        VaccinationCubit.get(context).changeSelect(
          vacName: newValue!.vacName,
          vacId: newValue.vacID,
        );
        print(VaccinationCubit.get(context).valueIdItem);
        print("111111111111111111111");
        print(VaccinationCubit.get(context).valueVacItem);
      },
      items: vacEntitiesData.map((VaccinationNameModel value) {
        return DropdownMenuItem<VaccinationNameModel>(
          value: value,
          child: Text(
            value.vacName,
          ),
        );
      }).toList(),
    );
  }

  Widget buildDropDownFeedSubType(
    List<String> feedSubTypeList,
    context,
  ) {
    return DropdownButtonFormField<String>(
      decoration: buildInputDecoration(context),
      isExpanded: true,
      iconSize: 18,
      menuMaxHeight: 200,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return isArabic()
              ? 'الرجاء اختيار نوع معين الطعام'
              : 'Please select feed sub type';
        }
        return null;
      },
      iconEnabledColor: Colors.black,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      hint: Text(VaccinationCubit.get(context).feedSubTypeValue),
      onChanged: (newValue) {
        VaccinationCubit.get(context).feedSubTypeValue = newValue.toString();
        print(VaccinationCubit.get(context).feedSubTypeValue);
        print(VaccinationCubit.get(context).feedSubTypeValue);
      },
      items: feedSubTypeList.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget buildDropDownFreq(
    List<String> freq,
    context,
  ) {
    return DropdownButtonFormField<String>(
      decoration: buildInputDecoration(context),
      isExpanded: true,
      iconSize: 18,
      menuMaxHeight: 200,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return isArabic()
              ? 'الرجاء اختيار عدد مرات التكرار'
              : 'Please select frequency';
        }
        return null;
      },
      iconEnabledColor: Colors.black,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      hint: Text(VaccinationCubit.get(context).currentFreq),
      onChanged: (newValue) {
        VaccinationCubit.get(context).currentFreq = newValue.toString();
        print(VaccinationCubit.get(context).currentFreq);
        print(VaccinationCubit.get(context).currentFreq);
      },
      items: freq.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  InputDecoration buildInputDecoration(context) {
    return InputDecoration(
      contentPadding: EdgeInsets.only(
        right: 10,
        left: 10,
      ),
      fillColor:
          MainCubit.get(context).isDark ? Colors.black26 : Colors.grey.shade200,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusColor: Colors.grey.shade200,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      labelStyle: FontStyleThame.textStyle(
        context: context,
        fontColor: MainCubit.get(context).isDark
            ? ColorManager.sWhite
            : ColorManager.black_87,
        fontSize: 18,
        fontWeight: FontWeight.normal,
      ),
      filled: true,
    );
  }
}

Widget buildSelectDateVac(context, VaccinationCubit cubit) {
  // DateTime tomorrowDateItem = cubit.currentDateItem.add(Duration(days: 1));

  return InkWell(
      onTap: () {
        cubit.selectDate(
          context,
        );
      },
      child: IgnorePointer(
        child: MyTextForm(
          controller: TextEditingController(
              text: cubit.currentDateItem == null || cubit.currentDateItem == ''
                  ? isArabic()
                      ? 'من فضلك ادخل تاريخ الميلاد'
                      : 'Please enter date of birth'
                  : cubit.currentDateItem.toString().substring(0, 10)),
          enabled: false,
          prefixIcon: const Icon(
            Icons.calendar_month,
            size: 14,
          ),
          enable: false,
          hintText: isArabic()
              ? 'من فضلك ادخل تاريخ الميلاد'
              : 'Please enter date of birth',
          validatorText: isArabic()
              ? 'من فضلك ادخل تاريخ الميلاد'
              : 'Please enter date of birth',
          obscureText: false,
        ),
      ));
}

class VacShimmer extends StatelessWidget {
  const VacShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Shimmer.fromColors(
                baseColor: Colors.grey,
                highlightColor: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40))),
                            width: 40,
                            height: 14,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40))),
                            width: 120,
                            height: 14,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40))),
                            width: 40,
                            height: 14,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40))),
                            width: 40,
                            height: 14,
                          ),
                          const Spacer(),
                          CircleAvatar(
                            child: IconButton(
                              onPressed: () {
                                // showDialog(
                                //   context: context,
                                //   builder: (BuildContext context) {
                                //     return AlertDialog(
                                //       title: const Text(
                                //         "Edit Your Pet Service",
                                //       ),
                                //       content: Column(
                                //         mainAxisSize: MainAxisSize.min,
                                //         children: [
                                //           const SizedBox(
                                //             height: 18,
                                //           ),
                                //           // textField(
                                //           //   'Comment',
                                //           //   Icons.feedback,
                                //           //   commentController,
                                //           //   'Please add Comment',
                                //           //   maxLines: 1,
                                //           // ),
                                //           const SizedBox(
                                //             height: 12,
                                //           ),
                                //           Row(
                                //             children: [
                                //               const Text(
                                //                   'Service State'),
                                //               const Spacer(),
                                //               Switch(
                                //                 value: VaccinationCubit
                                //                         .get(
                                //                             contextBloc)
                                //                     .edit,
                                //                 onChanged: (value) {
                                //                   VaccinationCubit.get(
                                //                           contextBloc)
                                //                       .changeEdit(
                                //                     comments: model[
                                //                         'comments'],
                                //                     petId: petId,
                                //                     id: VaccinationCubit
                                //                             .get(
                                //                                 contextBloc)
                                //                         .ids[index],
                                //                     gender:
                                //                         '${model['gender']}',
                                //                     data: model['data'],
                                //                     pitName: model[
                                //                         'pitName'],
                                //                     typeId:
                                //                         model['typeId'],
                                //                     typeVaccination: model[
                                //                         'typeVaccination'],
                                //                   );
                                //                 },
                                //               ),
                                //             ],
                                //           ),
                                //           const SizedBox(
                                //             height: 12,
                                //           ),
                                //           MyElevatedButton(
                                //             onPressed: () {
                                //               VaccinationCubit.get(
                                //                       contextBloc)
                                //                   .updateDate(
                                //                 comments:
                                //                     commentController
                                //                         .text,
                                //                 petId: petId,
                                //                 id: VaccinationCubit
                                //                         .get(
                                //                             contextBloc)
                                //                     .ids[index],
                                //                 gender:
                                //                     '${model['gender']}',
                                //                 data: model['data'],
                                //                 pitName:
                                //                     model['pitName'],
                                //                 statues:
                                //                     model['statues'],
                                //                 typeId: model['typeId'],
                                //                 typeVaccination: model[
                                //                     'typeVaccination'],
                                //               )
                                //                   .then((value) {
                                //                 Navigator.pop(context);
                                //               });
                                //             },
                                //             colors: Colors.red,
                                //             text: 'Save',
                                //           ),
                                //         ],
                                //       ),
                                //     );
                                //   },
                                // );
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
