import 'package:flutter/material.dart';

class AppColors {
  static final Color colorFFFFFF = HexColor("#FFFFFF");
  static final Color color66CCFF = HexColor("#66CCFF");
  static final Color color0066FF = HexColor("#0066FF");
  static final Color color19191A = HexColor("#9191A");
  static final Color colorF2F2F7 = HexColor("#F2F2F7");
  static final Color color000000 = HexColor("#000000");
  static final Color colorEC407A = HexColor("#EC407A");
  static final Color colorB7B7B7 = HexColor("#B7B7B7");
  static final Color colorDD323A = HexColor("#DD323A");
  static final Color color30A197 = HexColor("#30A197");
  static final Color color0B0C0C = HexColor("#0B0C0C");
  static final Color color666666 = HexColor("#666666");
  static final Color colorF2F2F3 = HexColor("#F2F2F3");
  static final Color color999999 = HexColor("#999999");
  static final Color colorC5C5C5 = HexColor("#C5C5C5");
  static final Color color9C27B0 = HexColor("#9C27B0");
  static final Color colorFFAE64 = HexColor("#FFAE64");
  static final Color colorECF0F1 = HexColor("#ECF0F1");
  static final Color color3E3E3E = HexColor("#3E3E3E");
  static final Color colorDDDDDD = HexColor("#DDDDDD");
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
