import 'package:flutter/material.dart';

abstract class BaseThemeData {
  Color primaryColor = const Color(0XFF403BF3);
  Color secondaryColor = const Color(0XFFFFB934);
  Color thirdColor = const Color(0x0ff00000);
  Color primaryTextColor = const Color(0XFF403BF3);
  Color secondaryTextColor = const Color(0XFFFFB934);

  Color background = const Color(0XFFF5F5F5);
  Color hintColor = const Color(0XFFB6B7B6);
  Color backgroundContainer = const Color(0xFFEFEFEF);
  Color dividerColor = const Color(0XFFC6C6C6);
  Color fadeTextColor = Colors.grey;

  Color appColor = const Color(0xFF403BF3);

  Color successColor = Colors.green;
  Color errorColor = const Color(0xFFFF4F4F);

  Color transparentColor = Colors.transparent;

  Color blackColor = const Color(0xFF2C2C2C);
  Color whiteColor = const Color(0xFFFFFFFF);

  Color greenColor = const Color(0xFF3AC754);
  Color green44Color = const Color(0xFF2AB644);
  Color greenEDColor = const Color(0xFFECFFED);
  Color greenF3Color = const Color(0xFFF6FFF3);

  Color bgGreenColor = const Color(0xFFE9FFEC);

  Color allSidesColor = const Color(0xFFF1F1F1);

  Color redColor = const Color(0xFFFF5555);
  Color redF5Color = const Color(0xFFFFF5F5);

  Color pinkColor = const Color(0xFFF7658B);

  Color yellowColor = const Color(0xFFFFD900);

  Color grayColor = const Color(0xFF676767);
  Color grayB9Color = const Color(0xFFB9B9B9);

  Color oldSilverColor = const Color(0xFF828282);

  Color silverColor = const Color(0xFFF2F2F2);

  Color blueColor = const Color(0xFF007AFF);
  Color blueFCColor = const Color(0xFF1DA6FC);
  Color blueFFColor = const Color(0xFFE5EDFF);
  Color blueBFFColor = const Color(0xFF9E9BFF);

  Color cardSendTimeColor = const Color(0xFF8E9AA3);

  Gradient? redOrangeGradient = const LinearGradient(
    colors: [Color(0xFFDB021F), Color(0xFFFB8C33)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
