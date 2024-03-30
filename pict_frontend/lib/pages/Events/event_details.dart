import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pict_frontend/pages/Events/event_role_selection.dart';
import 'package:pict_frontend/pages/Events/event_ticket_page.dart';
import 'package:pict_frontend/services/event_service.dart';
import 'package:pict_frontend/utils/constants/app_colors.dart';
import 'package:pict_frontend/utils/constants/app_constants.dart';
import 'package:slider_button/slider_button.dart';
// import 'package:qr_flutter/qr_flutter.dart';

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
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: TColors.primaryGreen),
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
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
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
                    Spacer(),
                    isExist == null
                        ? const CircularProgressIndicator()
                        : isExist!
                            ?
                            // ? ElevatedButton(
                            //     onPressed: () {
                            //       Navigator.of(context).push(
                            //         MaterialPageRoute(
                            //           builder: (context) => EventTicketPage(
                            //               event: event,
                            //               userId: widget.userId,
                            //               userImage: widget.userImage),
                            //         ),
                            //       );
                            //     },
                            //     style: ElevatedButton.styleFrom(
                            //       elevation: 0,
                            //       backgroundColor: TColors.buttonPrimary,
                            //       padding: const EdgeInsets.symmetric(
                            //         horizontal: 20,
                            //         vertical: 10,
                            //       ),
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(20),
                            //       ),
                            //     ),
                            //     child: const Text("Show Ticket"),
                            //   )
                            Center(
                                child: SliderButton(
                                backgroundColor: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? TColors.black
                                    : TColors.white,
                                // shimmer: ,
                                buttonColor: TColors.primaryGreen,
                                baseColor: TColors.primaryGreen,

                                action: () async {
                                  ///Do something here OnSlide
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => EventTicketPage(
                                          event: event,
                                          userId: widget.userId,
                                          userImage: widget.userImage),
                                    ),
                                  );
                                },
                                label: Text(
                                  "Show Ticket",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: TColors.primaryGreen),
                                ),
                                icon: Text(">",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.w900,
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? TColors.black
                                                    : TColors.white)),
                              ))
                            : Center(
                                child: SliderButton(
                                backgroundColor: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? TColors.black
                                    : TColors.white,
                                // shimmer: ,
                                buttonColor: TColors.primaryGreen,
                                baseColor: TColors.primaryGreen,

                                action: () async {
                                  ///Do something here OnSlide
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EventRoleSelectionPage(
                                        event: event,
                                      ),
                                    ),
                                  );
                                },
                                label: Text(
                                  "Enroll Now",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: TColors.primaryGreen),
                                ),
                                icon: Text(">",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.w900,
                                            color:
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? TColors.black
                                                    : TColors.white)),
                              ))
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


//  --> old QR