import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'utils/hex_color.dart';

Color accentGreenColor = HexColor("#0D988C");
Color appColor = HexColor("#00A79D");

ThemeData getThemeData() {
  return ThemeData(
    fontFamily: "IconFont",
    primaryColor: appColor,
    accentColor: accentGreenColor,
    hintColor: appColor,
    textTheme: TextTheme(
      headline1: TextStyle(
          fontWeight: FontWeight.w600, fontSize: 25, color: Colors.black),
      headline2: TextStyle(
          fontWeight: FontWeight.w600, color: Colors.black, fontSize: 20),
      headline4: TextStyle(
          fontWeight: FontWeight.w500, color: Colors.black, fontSize: 18),
      headline5: TextStyle(
          fontWeight: FontWeight.w500, color: Colors.black, fontSize: 16),
      headline6: TextStyle(
          fontWeight: FontWeight.w500, color: Colors.black, fontSize: 14),
      subtitle1: TextStyle(color: Colors.grey),
    ),
  );
}

// ThemeData(
//           hintColor: new Color(0xff0ad7cb),
//           primaryColor: new Color(0xff12a89f),
//           primaryColorDark: Color(0xff1d8a84),
//           primaryColorLight: Color(0xff0ad7cb),
//           fontFamily: "Montserrat",
//           canvasColor: Colors.white)
