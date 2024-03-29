import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pict_frontend/pages/ChatBot/chatbot.dart';
// import 'package:pict_frontend/pages/Events/events.dart';
import 'package:pict_frontend/pages/Events/events_home.dart';
import 'package:pict_frontend/pages/Gamification/gamification_home.dart';
import 'package:pict_frontend/pages/Report/reports.dart';
import 'package:pict_frontend/pages/Report/report_home.dart';
import 'package:pict_frontend/pages/User/user_home_screen.dart';
import 'package:pict_frontend/pages/User/user_profile.dart';
import 'package:pict_frontend/providers/event_notifier.dart';
import 'package:pict_frontend/utils/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDashboard extends ConsumerStatefulWidget {
  const UserDashboard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserDashboardState();
}

class _UserDashboardState extends ConsumerState<UserDashboard> {
  var _currentIndex = 0;
  int? completedCount;

  final tabs = [
    const HomePage(),
    const GamificationHomePage(),
    const ReportPage(),
    const EventsHomePage(),
    const UserProfilePage(),
  ];

  String? _id;
  String? _name;
  String? _email;
  String? _userImage;

  Future<Null> getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _id = prefs.getString("userId");
      _name = prefs.getString("name");
      _email = prefs.getString("email");
      _userImage = prefs.getString("image");
    });
  }

  @override
  void initState() {
    _id = "";
    _name = "";
    _email = "";
    _userImage = "";
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final eventsCount = ref.watch(getUserCompletedEvents(_id.toString()));
    // setState(() {
    //   completedCount = eventsCount.value?.length;
    // });

    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 55,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: TColors.primaryGreen,
        color: TColors.primaryGreen,
        animationDuration: const Duration(milliseconds: 300),
        items: const [
          Icon(Icons.home, size: 26, color: Colors.white),
          Icon(
            Icons.games_rounded,
            size: 26,
            color: Color.fromRGBO(255, 255, 255, 1),
          ),
          Icon(Icons.qr_code_scanner, size: 26, color: Colors.white),
          Icon(Icons.event, size: 26, color: Colors.white),
          Icon(Icons.person, size: 26, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
