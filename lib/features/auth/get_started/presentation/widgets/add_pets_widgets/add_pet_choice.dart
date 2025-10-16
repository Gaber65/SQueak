import 'package:flutter/material.dart';
import 'package:squeak/core/utils/theme/color_mangment/color_manager.dart';

class AddPetChoice extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final bool isSelected;
  final bool isLoading;
  final VoidCallback onTap;

  const AddPetChoice({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.isSelected,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
        child: Container(
          margin: const EdgeInsets.only(left: 8),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? ColorManager.primaryColor : Colors.white10,
            border: Border.all(
              // ignore: deprecated_member_use
              color: ColorManager.primaryColor.withOpacity(.7),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              isLoading && value == "other"
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(icon, color: Colors.white),
              const SizedBox(height: 4),
              Text(
                isLoading && value == "other" ? "Loading..." : label,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}