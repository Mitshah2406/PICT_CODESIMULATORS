import 'package:beep_player/beep_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pict_frontend/pages/Auth/signin_screen.dart';
import 'package:pict_frontend/providers/event_notifier.dart';
import 'package:pict_frontend/services/event_service.dart';
import 'package:pict_frontend/utils/constants/app_constants.dart';
import 'package:pict_frontend/utils/logging/logger.dart';
import 'package:pict_frontend/utils/session/SharedPreference.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
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

  static const BeepFile _beepFile = BeepFile(
    'assets/audios/beep.wav',
  );
  static const BeepFile _beepFileError = BeepFile(
    'assets/audios/beep-error.wav',
  );

  @override
  void initState() {
    _name = "";
    _id = "";
    _email = "";
    getSession();
    BeepPlayer.load(_beepFile);
    BeepPlayer.load(_beepFileError);
    super.initState();
  }

  @override
  void dispose() {
    BeepPlayer.unload(_beepFile);
    BeepPlayer.unload(_beepFileError);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final getOngoingEvents =
        ref.watch(getOngoingEventsByEmail(_email.toString()));
    String userId = '';
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
                      onPressed: () async {
                        var res =
                            await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              const SimpleBarcodeScannerPage(),
                        ));
                        setState(() {
                          if (res is String) {
                            userId = res;
                            LoggerHelper.info(userId);
                          }
                        });

                        try {
                          var res =
                              await EventService.markPresent(userId, event.id);

                          print("Response from backend");
                          LoggerHelper.debug(res.toString());

                          if (res.isNotEmpty) {
                            if (res['status'] == 'ok') {
                              BeepPlayer.play(
                                _beepFile,
                              );
                            } else {
                              BeepPlayer.play(_beepFileError);
                            }
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                    "Output: ",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: Text(res['message']!),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Okay"),
                                    )
                                  ],
                                );
                              },
                            );
                          }
                        } catch (e) {
                          print(e);
                        }
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
