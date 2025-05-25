import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import 'package:squeak/core/utils/export_path/export_files.dart';


import '../../../../../../core/utils/enums/dayOfWeek_enum.dart';
import '../../../../../pets/data/models/pet_model.dart';
import '../../controller/user/user_appointment_cubit.dart';

Widget buildPetFilter(BuildContext context, List<PetData> pets) {
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
        child: PopupMenuButton<PetData>(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
          ),
          offset: Offset(0, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onSelected: (value) {
            UserAppointmentCubit.get(context).selectedPetId = value.petId;
            UserAppointmentCubit.get(context).petName = value.petName;
            UserAppointmentCubit.get(context).filterAppointments();
          },
          itemBuilder: (context) => pets.map((e) {
            return PopupMenuItem<PetData>(
              value: e,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .32,
                child: Text(e.petName),
              ),
            );
          }).toList(),
          child: buildPopupButtonChild(
              context,
              UserAppointmentCubit.get(context).petName ??
                  S.of(context).filter_hint_pets,
              UserAppointmentCubit.get(context).selectedPetId != null),
        ),
      ),
    ),
  );
}

Widget buildStateFilter(BuildContext context) {
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
        child: PopupMenuButton<StateAppointment>(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
          ),
          offset: Offset(0, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onSelected: (value) {
            UserAppointmentCubit.get(context).selectedState = value.state.index;
            UserAppointmentCubit.get(context).selectedStateValue = value.key;
            UserAppointmentCubit.get(context).filterAppointments();
          },
          itemBuilder: (context) => generateDummyDataState(context).map((e) {
            return PopupMenuItem<StateAppointment>(
              value: e,
              child: Text(e.key),
            );
          }).toList(),
          child: buildPopupButtonChild(
              context,
              UserAppointmentCubit.get(context).selectedStateValue ??
                  S.of(context).filter_hint_State,
              UserAppointmentCubit.get(context).selectedStateValue != null),
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
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: Text(
            hint,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
