import 'package:flutter/material.dart';

class SonomaneColor {
  static Color scaffoldColorLight = const Color(0XFFECEFF1);
  static Color scaffoldColorDark = const Color(0XFF171616);

  static Color primary = const Color(0XFFE72E2C);
  static Color primary2 = const Color(0XFFE64A77);
  static Color secondary = const Color(0XFFE3E3E3);
  static Color secondaryContainerDark = const Color(0XFF202021);
  static Color secondaryContainerLigth = const Color(0XFFE4E4E4);

  static Color blue = const Color(0XFF00C9DB);
  static Color orange = Colors.orangeAccent;

  static Color containerLight = const Color(0XFFFFFFFF);
  static Color containerDark = const Color(0XFF2D2D2D);

  static Color textTitleLight = const Color(0XFF000000);
  static Color textTitleDark = const Color(0XFFFFFFFF);
  static Color textParaghrapLight = const Color(0XFF1E2022);
  static Color textParaghrapDark = const Color(0XFFD7D7D7);

  static Color lightGrey = const Color(0xffeaebec);
}

class NoGlow extends ScrollBehavior {
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
