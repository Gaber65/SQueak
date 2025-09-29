import 'package:flutter/material.dart';
import 'package:squeak/core/utils/theme/color_mangment/color_manager.dart';

class AddPetAdditionalDetails extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const AddPetAdditionalDetails({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.025,
            horizontal: screenWidth * 0.05,
          ),
          decoration: BoxDecoration(
            color: isSelected ? ColorManager.primaryColor : Colors.white10,
            border: Border.all(
              // ignore: deprecated_member_use
              color: ColorManager.primaryColor.withOpacity(.7),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.02),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  color: ColorManager.editScreenBaseFontColor,
                ),
                child: Icon(
                  icon,
                  color: Colors.blueAccent,
                  size: screenWidth * 0.06,
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.04,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}