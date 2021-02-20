import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      headline6: TextStyle(color: Colors.black, fontSize: 14),
      subtitle1: TextStyle(color: Colors.grey),
    ),
  );
}
