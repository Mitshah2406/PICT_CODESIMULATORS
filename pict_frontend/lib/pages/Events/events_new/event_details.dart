import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pict_frontend/pages/Events/events_new/event_role_selection.dart';
import 'package:pict_frontend/services/event_service.dart';
import 'package:pict_frontend/utils/constants/app_colors.dart';
import 'package:pict_frontend/utils/constants/app_constants.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../models/Event.dart';

class EventDetailsPage extends StatefulWidget {
  const EventDetailsPage(
      {super.key,
      required this.event,
      required this.userId,
      required this.userImage});
  final Event event;
  final String userImage;
  final String userId;

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  bool? isExist;

  Future<Null> checkIfAlreadyRegistered() async {
    bool res = await EventService.checkIfUserAlreadyRegistered(
      widget.userId,
      widget.event.id!,
    );

    setState(() {
      isExist = res;
    });
  }

  @override
  void initState() {
    isExist = false;
    checkIfAlreadyRegistered();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;

    print("Daaa");
    print(isExist);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          event.eventName.toString(),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: widget.userImage.isNotEmpty
                ? CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: SizedBox(
                      width: 180,
                      height: 180,
                      child: ClipOval(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: widget.userImage == "null"
                            ? Image.asset(
                                "assets/images/villager.png",
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                "${AppConstants.IP}/userImages/${widget.userImage}",
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  )
                : const CircularProgressIndicator(),
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          event.eventAttachment!.isNotEmpty
              ? Image.network(
                  "${AppConstants.IP}/eventAttachments/${event.eventAttachment![0]}",
                  fit: BoxFit.cover,
                  height: 300,
                  width: double.infinity,
                )
              : Image.asset("assets/images/event_detail_bg.png"),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  topRight: Radius.circular(30)),
              child: Container(
                height: 470,
                margin: const EdgeInsets.all(15),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: TColors.accentGreen,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.eventName.toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: TColors.black,
                                ),
                              ),
                              event.volunteers!.isNotEmpty
                                  ? Text(
                                      "${event.volunteers?.length} Volunteers",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(
                                            fontSize: 20,
                                            decoration:
                                                TextDecoration.underline,
                                            fontWeight: FontWeight.w300,
                                            color: TColors.black,
                                          ),
                                    )
                                  : const Text(""),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Hero(
                          tag: event.id!,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 60,
                            child: SizedBox(
                              width: 180,
                              height: 180,
                              child: ClipOval(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: event.eventPoster == null
                                    ? Image.network(
                                        fit: BoxFit.cover,
                                        "${AppConstants.IP}/poster/fallback-poster.png",
                                      )
                                    : Image.network(
                                        "${AppConstants.IP}/poster/${event.eventPoster}",
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.locationPinLock,
                          color: TColors.primaryGreen,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${event.eventAddress}, ${event.eventCity}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.black),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.calendar,
                          color: TColors.primaryGreen,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${event.eventStartDate!.day} ${AppConstants.months[event.eventStartDate!.month - 1]}, ${event.eventStartDate!.year}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.black),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.clock,
                          color: TColors.primaryGreen,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${event.eventStartTime} AM",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.black),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      event.eventDescription.toString(),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: TColors.black, fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    isExist == null
                        ? const CircularProgressIndicator()
                        : isExist!
                            ? ElevatedButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    backgroundColor: Colors.white,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Scaffold(
                                        backgroundColor: Colors.white,
                                        body: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              QrImageView(
                                                data:
                                                    "${widget.userId}-${event.id!}",
                                                size: 250,
                                                embeddedImageStyle:
                                                    const QrEmbeddedImageStyle(),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: TColors.buttonPrimary,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text("Show QR"),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EventRoleSelectionPage(event: event),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: TColors.primaryGreen,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text("Enroll Now"),
                              )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
