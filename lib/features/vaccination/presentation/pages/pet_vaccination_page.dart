import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/export_path/export_files.dart';
import '../../../pets/domain/entities/pet_entity.dart';
import '../cubit/ui/vaccination_ui_cubit.dart';
import '../widgets/vaccination_form.dart';
import '../widgets/vaccination_list.dart';
import '../widgets/vaccination_loading.dart';
import '../cubit/data/vaccination_data_cubit.dart';

class PetVaccinationPage extends StatelessWidget {
  final PetEntities petModel;

  const PetVaccinationPage({super.key, required this.petModel});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final commentController = TextEditingController();

    return MultiBlocProvider(
      providers: [
        BlocProvider<VaccinationDataCubit>(
          create: (context) => sl<VaccinationDataCubit>(),
        ),
        BlocProvider<VaccinationUiCubit>(
          create:
              (context) =>
                  sl<VaccinationUiCubit>()
                    ..listenToDataCubit()
                    ..loadVaccinationNames()
                    ..loadPetReminders(petModel.petId),
        ),
      ],
      child: BlocConsumer<VaccinationUiCubit, VaccinationUiState>(
        listener: (context, state) {
          if (state is VaccinationUiError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is ReminderActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isArabic() ? 'تم بنجاح' : 'Success'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          final uiCubit = context.read<VaccinationUiCubit>();

          return WillPopScope(
            onWillPop: () async {
              if (uiCubit.isButtonSheetShown) {
                uiCubit.changeBottomSheetShow(isShow: true);
                uiCubit.resetForm();
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
                      TextSpan(text: S.of(context).addRecord),
                      TextSpan(text: isArabic() ? ' ل ' : ' For '),
                      TextSpan(
                        text: petModel.petName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              body:
                  uiCubit.isVacLoading
                      ? const VaccinationLoading()
                      : VaccinationList(
                        petModel: petModel,
                        reminders: uiCubit.reminders,
                      ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.startFloat,
              floatingActionButton:
                  uiCubit.reminders.isNotEmpty
                      ? uiCubit.isButtonSheetShown
                          ? null
                          : FloatingActionButton(
                            backgroundColor: ColorManager.primaryColor,
                            child: Icon(
                              uiCubit.isButtonSheetShown
                                  ? Icons.done
                                  : Icons.add,
                            ),
                            onPressed: () {
                              if (uiCubit.valueIdItem.isNotEmpty) {
                                _handleCreateReminder(
                                  context,
                                  uiCubit,
                                  commentController,
                                );
                              } else {
                                uiCubit.changeBottomSheetShow(
                                  isShow: uiCubit.isButtonSheetShown,
                                );
                              }
                            },
                          )
                      : null,
              bottomSheet:
                  uiCubit.isButtonSheetShown
                      ? VaccinationForm(
                        formKey: formKey,
                        commentController: commentController,
                        petModel: petModel,
                      )
                      : null,
            ),
          );
        },
      ),
    );
  }

  void _handleCreateReminder(
    BuildContext context,
    VaccinationUiCubit uiCubit,
    TextEditingController commentController,
  ) {
    DateTime tomorrowDateItem = uiCubit.currentDateItem.add(
      const Duration(days: 1),
    );
    uiCubit
        .createReminder(
          petId: petModel.petId,
          data:
              (uiCubit.currentDateItem.toString().substring(0, 10) ==
                      DateTime.now().toString().substring(0, 10))
                  ? tomorrowDateItem.toString().substring(0, 10)
                  : uiCubit.currentDateItem.toString().substring(0, 10),
          comments: commentController.text,
          typeId: uiCubit.valueIdItem,
          valueVacItem: uiCubit.valueVacItem,
          context: context,
          petName: petModel.petName,
        )
        .then((_) {
          commentController.clear();
          uiCubit.resetForm();
        });
  }
}
