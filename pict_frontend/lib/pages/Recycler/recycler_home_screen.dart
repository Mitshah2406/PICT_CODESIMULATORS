import 'package:flutter/material.dart';
import 'package:pict_frontend/config/utils/SharedPreference.dart';
import 'package:pict_frontend/pages/Auth/signin_screen.dart';

class RecyclerHomePage extends StatefulWidget {
  const RecyclerHomePage({super.key});

  @override
  State<RecyclerHomePage> createState() => _RecyclerHomePageState();
}

class _RecyclerHomePageState extends State<RecyclerHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Recycler Home Screen"),
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
