import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pict_frontend/pages/Events/events_new/event_details.dart';
import 'package:pict_frontend/utils/constants/app_colors.dart';

class UpcomingEventsList extends StatelessWidget {
  const UpcomingEventsList({super.key});

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
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          Color color = index % 3 == 0
              ? TColors.primaryYellow
              : index % 3 == 1
                  ? TColors.accentGreen
                  : TColors.accentYellow;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Pict College Clean Drive!",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "50 Volunteers",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "April 28".toUpperCase(),
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const EventDetailsPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                              ),
                              child: Text(
                                "More..",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: TColors.white,
                                        fontWeight: FontWeight.w400),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: Image.asset(
                        "assets/images/overlap3.png",
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
