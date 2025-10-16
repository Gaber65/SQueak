import 'package:flutter/material.dart';
import 'package:squeak/core/service/service_locator/locatore_export_path.dart';
import 'package:squeak/features/appointments/exam/presentation/view/supplier/widgets/search_section.dart';
import 'package:squeak/features/pets/domain/entities/pet_entity.dart';
import 'clinic_card.dart';

class SuppliersSection extends StatelessWidget {
  final AppointmentCubit cubit;
  final AppointmentState state;
  final PetEntities? petSelectFromIcon;

  const SuppliersSection({
    super.key,
    required this.cubit,
    required this.state,
    this.petSelectFromIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (state is UnFollowLoading) LinearProgressIndicator(),
        buildSearchTextField(cubit, context),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => AppointmentCubit.get(context).getSuppliersList(),
            child: ListView.builder(
              itemCount: cubit.filteredSuppliers.length,
              itemBuilder:
                  (context, index) => ClinicCard(
                    clinic: cubit.suppliers!.data[index],
                    petSelectFromIcon: petSelectFromIcon,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
