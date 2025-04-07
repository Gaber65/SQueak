import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helper/build_service/main_cubit/main_cubit.dart';

class AssetImageModel {
  static String defaultUserImage =
      'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?size=626&ext=jpg&uid=R78903714&ga=GA1.1.798062041.1678310296&semt=ais';
  static String defaultPetImage =
      'https://img.freepik.com/free-vector/hand-drawn-animal-rescue-illustration_52683-109643.jpg?t=st=1724850971~exp=1724854571~hmac=310725afd1c40b0312d37d37e8cc8982f8cba5177dc34f988d94b9eccae6e977&w=826';
  static String defaultPetImageDelete =
      'https://img.freepik.com/premium-vector/sad-dog_161669-74.jpg?size=626&ext=jpg&uid=R78903714&ga=GA1.2.131510781.1692744483&semt=ais';

  static String defaultNoDataFound =
      'https://img.freepik.com/free-vector/no-data-concept-illustration_114360-536.jpg?w=740&t=st=1711500004~exp=1711500604~hmac=a8caa2ffe35a9993e4130c9c1d9786c949807796be4d6794519bcbe59997601f';
}
class ColorTheme {
  static Color primaryColor = const Color(0xFF0D6EFD,);
  static Color secondColor = const Color.fromRGBO(255, 112, 41, 1.0);
  static Color gray = const Color.fromRGBO(242, 242, 242, 1);
}

void navigateToScreen(
  BuildContext context,
  Widget widget,
) {
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    ),
  );
}

void navigateToScreenName(
  BuildContext context,
  String widget,
) {
  Navigator.pushNamed(
    context,
    widget,
  );
}

void navigateAndFinish(context, widget) {
  Navigator.pushAndRemoveUntil(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    ),
    (route) => false,
  );
}

class FontStyleThame {
  static TextStyle textStyle({
    double fontSize = 20,
    Color? fontColor,
    FontWeight? fontWeight,
    required context,
  }) {
    return GoogleFonts.notoSans(
      color: fontColor == null
          ? MainCubit.get(context).isDark
              ? Colors.white
              : Colors.black
          : fontColor,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }
}
