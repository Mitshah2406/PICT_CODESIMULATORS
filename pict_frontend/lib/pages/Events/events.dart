import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pict_frontend/config/utils/SharedPreference.dart';
import 'package:pict_frontend/pages/Auth/signin_screen.dart';
import 'package:pict_frontend/pages/Events/event_details.dart';
import 'package:pict_frontend/providers/event_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventsPage extends ConsumerStatefulWidget {
  const EventsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => EventsPageState();
}

class EventsPageState extends ConsumerState<EventsPage> {
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
    final eventService = ref.watch(getAllEvents);
    // final event = ref.watch(getEventById(''));

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

      body: eventService.when(
        data: (events) {
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return EventDetailsPage(event: event);
                    }),
                  );
                },
                child: ListTile(
                  title: Text(event.eventName ?? ''),
                  // Add more ListTile properties as needed
                ),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Text('Error: $error'),
      ),
      // body: Column(
      //   children: [
      //     ,
      //     // Expanded(
      //     //     child: event.when(
      //     //   data: (events) {
      //     //     return Text(events.eventName!);
      //     //   },
      //     //   loading: () => const Center(
      //     //     child: CircularProgressIndicator(),
      //     //   ),
      //     //   error: (error, stackTrace) => Text('Error: $error'),
      //     // ))
      //   ],
      // ),
    );
  }
}
