import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pict_frontend/models/Event.dart';
import 'package:pict_frontend/providers/event_notifier.dart';
import 'package:pict_frontend/services/event_service.dart';
import 'package:qr_flutter/qr_flutter.dart';

class EventDetailsPage extends StatefulWidget {
  const EventDetailsPage(
      {super.key, required this.event, required this.userId});
  final Event event;
  final String userId;

  @override
  State<StatefulWidget> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  bool? isExist;
  String? selectedOption = 'participant';

  @override
  void initState() {
    isExist = false;
    checkIfAlreadyRegistered();
    super.initState();
  }

  Future<Null> checkIfAlreadyRegistered() async {
    bool res = await EventService.checkIfUserAlreadyRegistered(
        widget.userId, widget.event.id!);

    setState(() {
      isExist = res;
    });
  }

  List<String> options = ["participant", "volunteer"];

  @override
  Widget build(BuildContext context) {
    final Event event = widget.event;
    final String userId = widget.userId;

    // final isExist =
    //     ref.watch(checkIfUserAlreadyRegistered([userId, event.id!]));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(event.eventName!),
      ),
      body: isExist!
          ? TextButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return Scaffold(
                      body: Center(
                        child: Column(
                          children: [
                            QrImageView(
                              data: "$userId-${event.id!}",
                              size: 280,
                              embeddedImageStyle: const QrEmbeddedImageStyle(
                                  // size: Size(
                                  //   100,

                                  // )
                                  // size: const Size(
                                  //   100,
                                  //   100,
                                  // ),
                                  ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Text("Show QR"),
            )
          : TextButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        "You are participating as ?",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Wrap(
                        spacing: 8.0,
                        children: [
                          FilterChip(
                            autofocus: true,
                            selectedColor: Colors.green,
                            label: const Text('Participant'),
                            selected: selectedOption == 'participant',
                            onSelected: (bool selected) {
                              setState(() {
                                selectedOption = selected
                                    ? 'participant'
                                    : null; // Update selectedOption
                              });
                            },
                          ),
                          FilterChip(
                            selectedColor: Colors.green,
                            label: const Text('Volunteer'),
                            selected: selectedOption == 'volunteer',
                            onSelected: (bool selected) {
                              setState(() {
                                selectedOption = selected
                                    ? 'volunteer'
                                    : null; // Update selectedOption
                              });
                            },
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            // print(userId +
                            //     " " +
                            //     event.id! +
                            //     " " +
                            //     selectedOption!);
                            String res = await EventService.registerEvent(
                                userId, event.id!, selectedOption);

                            if (res == "ok") {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("You are successfully registered."),
                                ),
                              );
                              checkIfAlreadyRegistered();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Failed to registered. Please Try again!"),
                                ),
                              );
                            }
                          },
                          child: const Text("Okay"),
                        )
                      ],
                    );
                  },
                );
              },
              child: const Text("Enrolled in event"),
            ),
    );
  }
}
