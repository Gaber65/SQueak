import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/features/appointments/boarding/presentation/cubit/boarding_state.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';

import '../../../../../../core/service/main_service/presentation/controller/main_cubit/main_cubit.dart' show MainCubit;
import '../../../../../../core/service/service_locator/locatore_export_path.dart';
import '../../../../../../generated/l10n.dart';
import '../../../domain/entities/boarding_status.dart';
import '../../cubit/boarding_cubit.dart';

Widget buildPetFilterBoarding(BuildContext context, List<PetEntities> pets) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
        color: MainCubit.get(context).isDark
            ? Colors.black26
            : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PopupMenuButton<PetEntities>(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
          ),
          offset: Offset(0, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onSelected: (value) {
            BoardingCubit.get(context).selectedPetId = value.petName;
            BoardingCubit.get(context).petName = value.petName;
            BoardingCubit.get(context).emit(FilterState());

            BoardingCubit.get(context).filterBoardings();
          },
          itemBuilder: (context) => pets.map((e) {
            return PopupMenuItem<PetEntities>(
              value: e,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .32,
                child: Text(e.petName),
              ),
            );
          }).toList(),
          child: buildPopupButtonChild(
              context,
              BoardingCubit.get(context).petName ??
                  S.of(context).filter_hint_pets,
              BoardingCubit.get(context).selectedPetId != null),
        ),
      ),
    ),
  );
}

Widget buildStateFilterBoarding(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
        color: MainCubit.get(context).isDark
            ? Colors.black26
            : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PopupMenuButton<StateBoardingEnums>(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
          ),
          offset: Offset(0, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onSelected: (value) {
            BoardingCubit.get(context).selectedState = value.state.index;
            BoardingCubit.get(context).selectedStateValue = value.key;
            BoardingCubit.get(context).emit(FilterState());
            BoardingCubit.get(context).filterBoardings();
          },
          itemBuilder: (context) =>
              generateDummyDataStateForBoarding(context).map((e) {
            return PopupMenuItem<StateBoardingEnums>(
              value: e,
              child: Text(e.key),
            );
          }).toList(),
          child: buildPopupButtonChild(
              context,
              BoardingCubit.get(context).selectedStateValue ??
                  S.of(context).filter_hint_State,
              BoardingCubit.get(context).selectedStateValue != null),
        ),
      ),
    ),
  );
}

Widget buildPopupButtonChild(BuildContext context, String hint, bool active) {
  return Row(
    children: [
      SizedBox(
        width: MediaQuery.of(context).size.width * .32,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 8.0,
          ),
          child: Text(
            hint,
            maxLines: 1,
            style: FontStyleThame.textStyle(
              context: context,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontColor: active
                  ? MainCubit.get(context).isDark
                      ? Colors.white
                      : Colors.black
                  : MainCubit.get(context).isDark
                      ? Colors.white54
                      : Color.fromRGBO(0, 0, 0, .3),
            ),
          ),
        ),
      ),
      const Spacer(),
      Icon(IconlyLight.filter, size: 18),
    ],
  );
}
