import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pict_frontend/pages/Auth/signin_screen.dart';
import 'package:pict_frontend/pages/Organizer/scanner.dart';
import 'package:pict_frontend/providers/event_notifier.dart';
import 'package:pict_frontend/utils/constants/app_constants.dart';
import 'package:pict_frontend/utils/session/SharedPreference.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

class OrganizerHomePage extends ConsumerStatefulWidget {
  const OrganizerHomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OrganizerHomePageState();
}

class _OrganizerHomePageState extends ConsumerState<OrganizerHomePage> {
  String? _name;
  String? _id;
  String? _email;

  Future<Null> getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString("name");
      _email = prefs.getString("email");
      _id = prefs.getString("organizerId");
    });
    // await GeolocationService.determinePosition();
  }

  @override
  void initState() {
    _name = "";
    _id = "";
    _email = "";
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final getOngoingEvents =
        ref.watch(getOngoingEventsByEmail(_email.toString()));

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
                          print("Hello");
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
      body: getOngoingEvents.when(
        data: (events) {
          print(events);

          if (events.isEmpty) {
            return const Center(
              child: Text("There are no ongoing events!"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Card(
                child: Center(
                  child: ListTile(
                    titleAlignment: ListTileTitleAlignment.center,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        child: FadeInImage.memoryNetwork(
                          fit: BoxFit.cover,
                          width: 80,
                          height: 50,
                          placeholder: kTransparentImage,
                          image: event.eventPoster == null
                              ? "${AppConstants.IP}/poster/fallback-poster.png"
                              : "${AppConstants.IP}/poster/${event.eventPoster}",
                        ),
                      ),
                    ),
                    title: Text(
                      event.eventName!,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      maxLines: 2,
                      event.eventDescription!,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ScannerPage(),
                        ));
                      },
                      icon: const Icon(Icons.qr_code_scanner),
                    ),
                    isThreeLine: true,
                  ),
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
    );
  }
}
