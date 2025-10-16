import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:squeak/core/utils/export_path/export_files.dart';
import 'package:squeak/features/pets/presentation/view/widgets/get_pet/pet_screen_content.dart';

import '../../../qr/presentation/controller/qr_cubit.dart';
import '../controller/pet_cubit.dart';

class PetScreen extends StatelessWidget {
  const PetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<PetCubit>()..getOwnerPets()),
        BlocProvider(create: (context) => sl<QrCubit>()),
      ],
      child: BlocConsumer<QrCubit, QrState>(
        listener: (context, state) {
          if (state is QrLinkSuccess) {
            successToast(context, state.message);
            Navigator.pop(context);
            PetCubit.get(context).getOwnerPets();
          } else if (state is QrUnlinkSuccess) {
            successToast(context, state.message);
            PetCubit.get(context).getOwnerPets();
          }
          if (state is QrError) {
            errorToast(context, state.message);
          }
        },
        builder: (context, state) {
          return BlocConsumer<PetCubit, PetState>(
            listener: (context, state) {
              if (state is DeletePetSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(S.of(context).petDeletedSuccessfully),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            // ✅ Only rebuild when pets list actually changes
            buildWhen: (previous, current) {
              return current is GetOwnerPetsLoadingState ||
                  current is GetOwnerPetsSuccessState ||
                  current is GetOwnerPetsErrorState ||
                  current is PetCreateSuccessState ||
                  current is DeletePetSuccessState ||
                  current is MergePetsSuccessState;
            },
            builder: (context, state) {
              final cubit = PetCubit.get(context);
              final qrCubit = QrCubit.get(context);
              return PetScreenContent(
                pets: cubit.pets,
                cubit: cubit,
                state: state,
                qrCubit: qrCubit,
              ); 
            },
          );
        },
      ),
    );
  }
}
