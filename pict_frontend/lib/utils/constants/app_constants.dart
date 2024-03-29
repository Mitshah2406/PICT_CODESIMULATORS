import 'package:flutter/material.dart';

class AppConstants {
  static const String port = "4000";
<<<<<<< HEAD
  static const String IP = "http://192.168.131.85:$port";
=======
  static const String IP = "http://192.168.185.208:$port";
>>>>>>> 8f7373727d4bf333e4cc78516ceac28216f7387b

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
