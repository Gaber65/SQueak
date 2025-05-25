import 'package:flutter/material.dart';
import '../../../domain/entities/boarding_type_entity.dart';

class BoardingTypeDropdown extends StatelessWidget {
  final List<BoardingTypeEntity> boardingTypes;
  final BoardingTypeEntity? selectedBoardingType;
  final Function(BoardingTypeEntity) onChanged;

  const BoardingTypeDropdown({
    super.key,
    required this.boardingTypes,
    required this.selectedBoardingType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Boarding Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<BoardingTypeEntity>(
              value: selectedBoardingType,
              hint: const Text('Select Boarding Type'),
              isExpanded: true,
              items: boardingTypes.map((BoardingTypeEntity type) {
                return DropdownMenuItem<BoardingTypeEntity>(
                  value: type,
                  child: Text(type.name),
                );
              }).toList(),
              onChanged: (BoardingTypeEntity? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}