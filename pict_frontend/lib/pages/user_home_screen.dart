import 'package:flutter/material.dart';

import 'package:pict_frontend/pages/Auth/signin_screen.dart';
import 'package:pict_frontend/utils/session/SharedPreference.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _name;

  Future<Null> getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString("name");
    });
  }

  @override
  void initState() {
    _name = "";
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
      body: const Center(
        child: Text("HEllo world"),
      ),
    );
  }
}
