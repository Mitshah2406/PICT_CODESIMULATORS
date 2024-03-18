import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pict_frontend/config/firebase_api.dart';
import 'package:pict_frontend/firebase_options.dart';
import 'package:pict_frontend/pages/noti_screen.dart';
import 'package:pict_frontend/pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initializeFirebaseNotifications();
  runApp(ProviderScope(child: MyApp()));
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // final ThemeData theme = ThemeData();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: theme.copyWith(
      //   colorScheme: theme.colorScheme.copyWith(secondary: Colors.green),
      // ),
      navigatorKey: navigatorKey,
      routes: {
        NotiScreen.notificationRoute: (context) => const NotiScreen(),
      },
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      themeMode: ThemeMode.system,
      // theme: ThemeData(),
      // darkTheme: ThemeData(),
    );
  }
}
