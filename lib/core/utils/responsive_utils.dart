import 'package:flutter/material.dart';

double responsiveHeight(double height, BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;
  return (height / 800) * screenHeight;
}

double responsiveWidth(double width, BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  return (width / 360) * screenWidth;
}

double responsiveFontSize(double fontSize, BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  return (fontSize / 360) * screenWidth;
}
