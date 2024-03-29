
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pict_frontend/config/firebase_api.dart';
import 'package:pict_frontend/firebase_options.dart';
import 'package:pict_frontend/intro_screen.dart';
import 'package:pict_frontend/pages/noti_screen.dart';
import 'package:pict_frontend/pages/splash_screen.dart';
import 'package:pict_frontend/providers/theme_notifier.dart';
import 'package:pict_frontend/utils/detector_service.dart';
import 'package:pict_frontend/utils/firebase/firebase_api.dart';
import 'package:pict_frontend/utils/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initializeFirebaseNotifications();
  runApp(const ProviderScope(child: MyApp()));
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      navigatorKey: navigatorKey,
      routes: {
        NotiScreen.notificationRoute: (context) => const NotiScreen(),
      },
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      themeMode: themeMode,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
    );
  }
}
