import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:squeak/features/appointments/models/get_appointment_model.dart';

import '../../../../core/helper/build_service/main_cubit/main_cubit.dart';
import '../../../../core/thames/styles.dart';
import '../../../../generated/l10n.dart';
import '../../../pets/models/pet_model.dart';
import '../../controller/user/user_appointment_cubit.dart';

Widget buildPetFilter(BuildContext context, List<PetsData> pets) {
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
        child: PopupMenuButton<PetsData>(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
          ),
          offset: Offset(0, 40),
          child: buildPopupButtonChild(
              context,
              UserAppointmentCubit.get(context).petName ??
                  S.of(context).filter_hint_pets,
              UserAppointmentCubit.get(context).selectedPetId != null),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onSelected: (value) {
            UserAppointmentCubit.get(context).selectedPetId = value.petId;
            UserAppointmentCubit.get(context).petName = value.petName;
            UserAppointmentCubit.get(context).filterAppointments();
          },
          itemBuilder: (context) => pets.map((e) {
            return PopupMenuItem<PetsData>(
              value: e,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .32,
                child: Text(e.petName),
              ),
            );
          }).toList(),
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
          child: buildPopupButtonChild(
              context,
              UserAppointmentCubit.get(context).selectedStateValue ??
                  S.of(context).filter_hint_State,
              UserAppointmentCubit.get(context).selectedStateValue != null),
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
