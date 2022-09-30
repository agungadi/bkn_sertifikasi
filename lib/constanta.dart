import 'package:flutter/material.dart';
import 'package:from_css_color/from_css_color.dart';

ThemeData myTheme = ThemeData(
  fontFamily: "customFont",
  primaryColor: fromCssColor('#5800FF'),
  buttonColor: fromCssColor('#0078AA'),
  accentColor: fromCssColor('#72FFFF'),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(
        fromCssColor('#256D85'),
      ),
    ),
  ),
);
