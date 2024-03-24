import 'package:flutter/material.dart';
import 'package:pict_frontend/utils/constants/app_colors.dart';

class TAppBarTheme {
  static const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: Colors.black, size: 24),
    actionsIconTheme: IconThemeData(color: TColors.primaryGreen, size: 24),
    titleTextStyle: TextStyle(
        fontSize: 20, fontWeight: FontWeight.w600, color: TColors.primaryGreen),
  ); // AppBarTheme

  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: TColors.primaryGreen, size: 24),
    actionsIconTheme: IconThemeData(color: TColors.primaryGreen, size: 24),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: TColors.primaryGreen,
    ),
  ); // AppBarTheme
}
