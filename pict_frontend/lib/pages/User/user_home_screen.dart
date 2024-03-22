import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pict_frontend/pages/Events/user_completed_events.dart';
import 'package:pict_frontend/pages/Report/addReport.dart';
import 'package:pict_frontend/pages/Report/reports.dart';
import 'package:pict_frontend/pages/User/user_profile.dart';
import 'package:pict_frontend/utils/session/SharedPreference.dart';
import 'package:pict_frontend/pages/Auth/signin_screen.dart';
import 'package:pict_frontend/pages/Events/event_details.dart';
import 'package:pict_frontend/pages/Events/events.dart';
import 'package:pict_frontend/providers/event_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pict_frontend/pages/Auth/signin_screen.dart';
import 'package:pict_frontend/utils/geolocation/geolocation_service.dart';
import 'package:pict_frontend/utils/session/SharedPreference.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  String? _name;
  String? _id;

  Future<Null> getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString("name");
      _id = prefs.getString("userId");
    });
    await GeolocationService.determinePosition();
  }

  @override
  void initState() {
    _name = "";
    _id = "";
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final getUpcomingEvents = ref.watch(getAllUpcomingEvents);
    // final getOngoingEvents = ref.watch(getAllOngoingEvents);
    // final getRegisteredEventsOfUsers =
    //     ref.watch(getUserRegisteredEvents(_id.toString()));
    // print(getUpcomingEvents.value?.map((e) => print(e.eventName)));
    // print(getOngoingEvents.value?.map((e) => print(e.eventName)));
    // print(getRegisteredEventsOfUsers.value?.map(
    //     (e) => e.registeredParticipants?.map((curr) => print(curr['userId']))));
    // print(getRegisteredEventsOfUsers.value?.map((e) => print(e.eventName)));
    // final getCompletedEventsOfUsers =
    //     ref.watch(getUserCompletedEvents(_id.toString()));
    // print(getCompletedEventsOfUsers.value?.map((e) => print(e.whatsAppLink)));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_name.toString()),
        actions: [
          TextButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                      "Are you sure you want to logout?",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content:
                        const Text("Once logged out, you need to login again"),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          String res = await Utils.logout();

                          if (res == "ok") {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return const SignInPage();
                            }));
                          }
                        },
                        child: const Text("Okay"),
                      )
                    ],
                  );
                },
              );
            },
            child: const Text(
              "Logout",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const EventsPage();
                }),
              );
            },
            child: const Text("Go to Events Page"),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const UserCompletedEventsPage();
                }),
              );
            },
            child: const Text("Go to User Completed Events"),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const AddReportPage();
                }),
              );
            },
            child: const Text("Add Report"),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const ReportsPage();
                }),
              );
            },
            child: const Text("Your Report"),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const UserProfilePage();
                }),
              );
            },
            child: const Text("Go to user profile"),
          )
        ],
      ),
    );
  }
}
