import 'package:flutter/material.dart';

import '../../../../../../core/service/service_locator/locatore_export_path.dart'
    show MainCubit;

class PetTypeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const PetTypeOption({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Icon(icon, size: 50, color: Colors.blue),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color:
                  MainCubit.get(context).isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
