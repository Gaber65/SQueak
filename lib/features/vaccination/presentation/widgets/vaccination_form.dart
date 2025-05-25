import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/export_path/export_files.dart';
import '../../../../generated/l10n.dart';
import '../../../pets/domain/entities/pet_entity.dart';
import '../cubit/ui/vaccination_ui_cubit.dart';
import 'form_components.dart';

class VaccinationForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController commentController;
  final PetEntities petModel;

  const VaccinationForm({
    Key? key,
    required this.formKey,
    required this.commentController,
    required this.petModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VaccinationUiCubit, VaccinationUiState>(
      builder: (context, state) {
        final cubit = context.read<VaccinationUiCubit>();

        return SizedBox(
          height: 350,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: buildDropDownBreed(cubit.vaccinationNames, context),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      cubit.selectTime(context);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color:
                            MainCubit.get(context).isDark
                                ? Colors.black26
                                : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          cubit.picked == null
                              ? "Select the time"
                              : formatTimeToAmPmReminder(
                                "${cubit.picked!.hour} : ${cubit.picked!.minute}",
                              ),
                        ),
                      ),
                    ),
                  ),
                  if (cubit.valueVacItem == "other" ||
                      cubit.valueVacItem == "أخرى") ...[
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: MyTextForm(
                        controller: cubit.otherController,
                        prefixIcon: const SizedBox(),
                        maxLines: 1,
                        enable: false,
                        hintText: S.of(context).reminderOtherHintText,
                        obscureText: false,
                      ),
                    ),
                  ],
                  if (cubit.valueVacItem == "Feed" || cubit.valueVacItem.contains('إطعام')) ...[
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: buildDropDownFeedSubType(
                        cubit.feedSubType,
                        context,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: buildDropDownFreq(cubit.reminderFreq, context),
                  ),
                  const SizedBox(height: 10),
                  buildSelectDateVac(context, cubit),
                  const SizedBox(height: 10),
                  MyTextForm(
                    controller: commentController,
                    prefixIcon: const SizedBox(),
                    maxLines: 5,
                    enable: false,
                    hintText:
                        isArabic()
                            ? 'الرجاء ادخال عنوان التلقيح '
                            : 'Please enter your vaccination comment',
                    validatorText: null,
                    obscureText: false,
                  ),
                  const SizedBox(height: 30),
                  CustomElevatedButton(
                    isLoading: false,
                    formKey: formKey,
                    onPressed:
                        () => _handleSave(context, cubit, commentController),
                    buttonText: S.of(context).save,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleSave(
    BuildContext context,
    VaccinationUiCubit cubit,
    TextEditingController commentController,
  ) {
    if (cubit.picked == null) {
      errorToast(
        context,
        isArabic() ? "الرجاء اختيار الوقت" : "Please select the time",
      );
      return;
    }

    DateTime tomorrowDateItem = cubit.currentDateItem.add(
      const Duration(days: 1),
    );
    cubit
        .createReminder(
          petId: petModel.petId,
          data:
              (cubit.currentDateItem.toString().substring(0, 10) ==
                      DateTime.now().toString().substring(0, 10))
                  ? cubit.currentDateItem.toString().substring(0, 10)
                  : cubit.currentDateItem.toString().substring(0, 10),
          comments: commentController.text,
          typeId: cubit.valueIdItem,
          valueVacItem: cubit.valueVacItem,
          context: context,
          petName: petModel.petName,
        )
        .then((_) {
          commentController.clear();
          cubit.resetForm();
        });
  }
}
