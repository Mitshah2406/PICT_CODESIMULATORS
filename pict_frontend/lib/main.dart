import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:pict_frontend/firebase_options.dart';
import 'package:pict_frontend/pages/noti_screen.dart';
import 'package:pict_frontend/pages/splash_screen.dart';
import 'package:pict_frontend/utils/firebase/firebase_api.dart';
import 'package:pict_frontend/utils/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initializeFirebaseNotifications();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      routes: {
        NotiScreen.notificationRoute: (context) => const NotiScreen(),
      },
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
    );
  }
}
