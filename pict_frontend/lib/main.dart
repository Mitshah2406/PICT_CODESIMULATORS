import 'package:flutter/material.dart';
import 'package:pict_frontend/pages/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      themeMode: ThemeMode.system,
      // theme: ThemeData(),
      // darkTheme: ThemeData(),
    );
  }
}
