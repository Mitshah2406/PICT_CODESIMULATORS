import 'package:flutter/material.dart';

class AppConstants {
  static const String port = "4000";
  static const String IP = "http://10.10.12.201:$port";

  static Color bgColorAuth = const Color(0xfff7f6fb);
  static const String registerIcon = "assets/images/register.svg";
  static const String loginIcon = "assets/images/login.png";

  static const months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  static String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  static const apiKey = "AIzaSyDkSgyeo_gOT2GtjSQLu7QqW-zWoq0frjI";
}
