import 'package:flutter/material.dart';
import 'package:pict_frontend/pages/Events/events_new/upcoming_events_list.dart';

import 'package:pict_frontend/utils/constants/app_colors.dart';

class EventsHomePage extends StatefulWidget {
  const EventsHomePage({super.key});

  @override
  State<EventsHomePage> createState() => _EventsHomePageState();
}

class _EventsHomePageState extends State<EventsHomePage> {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                      height: 200,
                      decoration: const BoxDecoration(
                        color: TColors.secondaryGreen,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: TColors.white,
                            radius: 30,
                            child: Text(
                              "+5",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(color: TColors.black),
                            ),
                          ),
                          Text(
                            "Upcoming Events!",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: TColors.white),
                          )
                        ],
                      )),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    children: [
                      Text(
                        "YOUR\nEVENTS",
                        softWrap: true,
                        style:
                            Theme.of(context).textTheme.displaySmall!.copyWith(
                                  color: TColors.black,
                                  fontWeight: FontWeight.w900,
                                ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        width:
                            150, // Increased width to accommodate larger avatars
                        height:
                            100, // Increased height to accommodate larger avatars
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: TColors.secondaryGreen,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Positioned(
                              left: 0,
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius:
                                    30, // Increased radius for larger avatar
                                child: CircleAvatar(
                                  radius:
                                      25, // Adjusted radius to fit within the outer circle
                                  backgroundColor: Colors.transparent,
                                  child: Image.asset(
                                    "assets/images/overlap1.png",
                                    width: 200,
                                    height: double.infinity,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left:
                                  30, // Adjusted left position to prevent overlapping
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius:
                                    30, // Increased radius for larger avatar
                                child: CircleAvatar(
                                  radius:
                                      25, // Adjusted radius to fit within the outer circle
                                  backgroundColor: Colors.transparent,
                                  child: Image.asset(
                                    "assets/images/overlap2.png",
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left:
                                  60, // Adjusted left position to prevent overlapping
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius:
                                    30, // Increased radius for larger avatar
                                child: CircleAvatar(
                                  radius:
                                      25, // Adjusted radius to fit within the outer circle
                                  backgroundColor: Colors.transparent,
                                  child: Image.asset(
                                    "assets/images/overlap3.png",
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Events \nOn This Month",
                softWrap: true,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: TColors.black, fontWeight: FontWeight.w900),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 290,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const UpcomingEventsList();
                        }));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        width: 150,
                        height: 290,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: index % 2 == 0
                              ? TColors.primaryYellow
                              : TColors.secondaryYellow,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: const BoxDecoration(
                                color: Colors.amber,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                              ),
                              child: Image.asset(
                                "assets/images/overlap1.png",
                                height: 130,
                                width: 170,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Pict College Cleanliness Drive",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(color: TColors.white),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  backgroundColor: TColors.black,
                                ),
                                child: Text(
                                  "April 30",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: TColors.primaryGreen,
                                      ),
                                ))
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
