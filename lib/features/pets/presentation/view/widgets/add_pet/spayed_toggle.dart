// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';

import '../../../controller/pet_cubit.dart';

class SpayedToggle extends StatelessWidget {
  const SpayedToggle({super.key, required this.cubit});

  final PetCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blue),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(
              cubit.spayed ? Icons.health_and_safety : Icons.pets,
              color: ColorManager.primaryColor,
            ),
            const SizedBox(width: 12),
            Text(
              cubit.spayed ? S.of(context).spayed : S.of(context).notSpayed,
              style: FontStyleThame.textStyle(
                context: context,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Switch(
              value: cubit.spayed,
              activeColor: ColorManager.primaryColor,
              onChanged: (value) => cubit.changeSpayed(),
            ),
          ],
        ),
      ),
    );
  }
}
