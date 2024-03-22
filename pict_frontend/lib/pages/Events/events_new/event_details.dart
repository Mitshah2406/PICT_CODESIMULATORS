import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pict_frontend/pages/Events/events_new/event_role_selection.dart';
import 'package:pict_frontend/utils/constants/app_colors.dart';

class EventDetailsPage extends StatefulWidget {
  const EventDetailsPage({super.key});

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Events",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CircleAvatar(
              child: Image.asset("assets/images/overlap1.png"),
            ),
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Image.asset(
            "assets/images/event_detail_bg.png",
            fit: BoxFit.cover,
            height: 300,
            width: double.infinity,
          ),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Pict College Clean Drive!",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: TColors.black),
                              ),
                              Text(
                                "50 Volunteers",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                        fontSize: 20,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.w300,
                                        color: TColors.black),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          "assets/images/overlap3.png",
                          width: 130,
                          height: 130,
                          fit: BoxFit.cover,
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
                          "PICT College Campus",
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
                          "28 April, 2024",
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
                          "PICT College Campus",
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
                      "Join us for a day filled with excitement, creativity, and camaraderie at the PICT College Annual Spring Fest! This much-awaited event promises a plethora of activities, competitions, and entertainment for students, faculty, and staff alike.",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: TColors.black, fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                const EventRoleSelectionPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.primaryGreen,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
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
