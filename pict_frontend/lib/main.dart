import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pict_frontend/firebase_options.dart';
import 'package:pict_frontend/intro_screen.dart';
// import 'package:pict_frontend/localizations/locales.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final FlutterLocalization localization = FlutterLocalization.instance;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
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
      },
    );
  }

  // void configureLocalization() {
  //   localization.init(mapLocales: LOCALES, initLanguageCode: "en");
  //   localization.onTranslatedLanguage = onTranslatedLanguage;
  // }

  // void onTranslatedLanguage(Locale? locale) {
  //   setState(() {});
  // }
}
