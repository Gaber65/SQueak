import 'package:flutter/material.dart';
import 'package:squeak/core/helper/build_service/main_cubit/main_cubit.dart';
import 'package:squeak/features/layout/controller/layout_cubit.dart';

import '../../../../../core/helper/remotely/end-points.dart';
import '../../../../pets/models/pet_model.dart';

Widget buildDropDownSpeciesTest(PetsData pets, context, LayoutCubit cubit) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: MediaQuery.of(context).size.width / 3,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(8),
        color: !MainCubit.get(context).isDark ? Colors.black12 : Colors.white10,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          cubit.breakLoadingAfterUpdated(context, pets);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage('$imageUrl${pets.imageName}'),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                pets.petName,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
