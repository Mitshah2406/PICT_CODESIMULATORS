import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pict_frontend/config/utils/SharedPreference.dart';
import 'package:pict_frontend/pages/Auth/signin_screen.dart';
import 'package:pict_frontend/pages/Events/event_details.dart';
import 'package:pict_frontend/pages/Events/events.dart';
import 'package:pict_frontend/providers/event_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          )
        ],
      ),
    );
  }
}
