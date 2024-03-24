import 'package:beep_player/beep_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pict_frontend/providers/event_notifier.dart';
import 'package:pict_frontend/services/event_service.dart';
import 'package:pict_frontend/utils/constants/app_colors.dart';
import 'package:pict_frontend/utils/constants/custom_appbar_shape.dart';
import 'package:pict_frontend/utils/logging/logger.dart';
import 'package:pict_frontend/widgets/tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../utils/constants/app_constants.dart';

class OrganizerDashboard extends ConsumerStatefulWidget {
  const OrganizerDashboard({super.key});

  @override
  ConsumerState<OrganizerDashboard> createState() => _OrganizerDashboardState();
}

class _OrganizerDashboardState extends ConsumerState<OrganizerDashboard> {
  String? _email;

  Future<Null> getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString("email");
    });
    // await GeolocationService.determinePosition();
  }

  int selected = 0;
  void changeTab(int index) {
    setState(() {
      selected = index;
    });
  }

  static const BeepFile _beepFile = BeepFile(
    'assets/audios/beep.wav',
  );
  static const BeepFile _beepFileError = BeepFile(
    'assets/audios/beep-error.wav',
  );

  @override
  void initState() {
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
    final getCompletedEvents =
        ref.watch(getCompletedEventsByEmail(_email.toString()));
    String userId = '';
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        backgroundColor: Colors.transparent,
        elevation: 5.0,
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: Icon(
        //       Icons.logout,
        //       color: Theme.of(context).brightness == Brightness.dark
        //           ? TColors.black
        //           : TColors.white,
        //     ),
        //   ),
        // ],
        flexibleSpace: ClipPath(
          clipper: CustomAppBarShape(),
          child: Container(
            height: 250,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: TColors.primaryGreen,
              boxShadow: [
                BoxShadow(
                  offset: Offset(2, 2),
                  blurRadius: 20,
                  color: Color.fromRGBO(0, 0, 0, 0.16),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Organizers Dashboard",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? TColors.black
                            : TColors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 26),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.logout,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? TColors.black
                          : TColors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TabView(
              onTap: changeTab,
              selected: selected,
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: selected == 0
                  ? getOngoingEvents.when(
                      data: (events) {
                        print(events);

                        if (events.isEmpty) {
                          return const Center(
                            child: Text("There are no ongoing events!"),
                          );
                        }
                        return ListView.builder(
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            final event = events[index];
                            Color color = index % 2 == 0
                                ? TColors.primaryYellow
                                : TColors.accentGreen;

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              event.eventName!,
                                              softWrap: true,
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall!
                                                  .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    color: TColors.black,
                                                  ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "${event.noOfVolunteersNeeded} Volunteers",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .copyWith(
                                                    color: TColors.black,
                                                  ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "${AppConstants.months[event.eventStartDate!.month - 1]} ${event.eventStartDate!.day}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .copyWith(
                                                      color: TColors.black,
                                                      fontWeight:
                                                          FontWeight.w900),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ElevatedButton.icon(
                                                icon: const Icon(
                                                  FontAwesomeIcons.qrcode,
                                                ),
                                                onPressed: () async {
                                                  var res = await Navigator.of(
                                                          context)
                                                      .push(MaterialPageRoute(
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
                                                    var res = await EventService
                                                        .markPresent(
                                                            userId, event.id);

                                                    print(
                                                        "Response from backend");
                                                    LoggerHelper.debug(
                                                        res.toString());

                                                    if (res.isNotEmpty) {
                                                      if (res['status'] ==
                                                          'ok') {
                                                        BeepPlayer.play(
                                                          _beepFile,
                                                        );
                                                      } else {
                                                        BeepPlayer.play(
                                                            _beepFileError);
                                                      }
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                              "Output: ",
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            content: Text(res[
                                                                'message']!),
                                                            actions: [
                                                              TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    const Text(
                                                                        "Okay"),
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
                                                style: ElevatedButton.styleFrom(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15),
                                                  backgroundColor:
                                                      Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? TColors.black
                                                          : TColors.white,
                                                ),
                                                label: Text(
                                                  "Mark",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          color: Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .dark
                                                              ? TColors.white
                                                              : TColors.black,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                )),
                                          ],
                                        ),
                                      ),
                                      ClipOval(
                                        child: SizedBox(
                                          height: 150,
                                          width: 150,
                                          child: event.eventPoster == null
                                              ? Image.network(
                                                  "${AppConstants.IP}/poster/fallback-poster.png",
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  "${AppConstants.IP}/poster/${event.eventPoster}",
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
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
                    )
                  : getCompletedEvents.when(
                      data: (events) {
                        print(events);

                        if (events.isEmpty) {
                          return const Center(
                            child: Text("There are no ongoing events!"),
                          );
                        }
                        return ListView.builder(
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            final event = events[index];

                            Color color = index % 2 == 0
                                ? TColors.primaryYellow
                                : TColors.accentGreen;

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              event.eventName!,
                                              softWrap: true,
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall!
                                                  .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    color: TColors.black,
                                                  ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "${event.noOfVolunteersNeeded} Volunteers",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .copyWith(
                                                    color: TColors.black,
                                                  ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "${AppConstants.months[event.eventStartDate!.month - 1]} ${event.eventStartDate!.day}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .copyWith(
                                                      color: TColors.black,
                                                      fontWeight:
                                                          FontWeight.w900),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15),
                                                  backgroundColor:
                                                      Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? TColors.black
                                                          : TColors.white,
                                                ),
                                                child: Text(
                                                  "Mark Present",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                          color: Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .dark
                                                              ? TColors.white
                                                              : TColors.black,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                )),
                                          ],
                                        ),
                                      ),
                                      ClipOval(
                                        child: SizedBox(
                                          height: 150,
                                          width: 150,
                                          child: event.eventPoster == null
                                              ? Image.network(
                                                  "${AppConstants.IP}/poster/fallback-poster.png",
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.network(
                                                  "${AppConstants.IP}/poster/${event.eventPoster}",
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
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
            ),
          ],
        ),
      ),
    );
  }
}
