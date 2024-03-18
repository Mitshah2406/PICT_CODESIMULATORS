import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pict_frontend/pages/Auth/signup_screen.dart';
import 'package:pict_frontend/pages/User/user_home_screen.dart';
// import 'package:notes/pages/Dashboard.dart';
// import 'package:notes/pages/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    validateUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: const EdgeInsets.only(top: 10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo.jpg",
                  height: 300,
                ),
                const SizedBox(
                  height: 25,
                ),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        letterSpacing: .5,
                      ),
                    ),
                    children: const [
                      TextSpan(
                          text: 'Trash', style: TextStyle(color: Colors.black)),
                      TextSpan(
                        text: 'Track',
                        style: TextStyle(color: Colors.green),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  validateUser() {
    Timer(const Duration(milliseconds: 3500), () async {
      // ! If the user close the app, and then try to open it again, then he will be prompted to login again.

      var result = await SharedPreferences.getInstance();
      bool? data = result.getBool("isloggedIn");

      if (data != null && data == true) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const HomePage();
        }));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const SignUpPage();
        }));
      }
    });
  }
}
