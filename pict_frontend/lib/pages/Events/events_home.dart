import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pict_frontend/models/Event.dart';
import 'package:pict_frontend/pages/Events/event_details.dart';
import 'package:pict_frontend/pages/Events/event_list.dart';
import 'package:pict_frontend/providers/event_notifier.dart';

import 'package:pict_frontend/utils/constants/app_colors.dart';
import 'package:pict_frontend/utils/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventsHomePage extends ConsumerStatefulWidget {
  const EventsHomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EventsHomePageState();
}

class _EventsHomePageState extends ConsumerState<EventsHomePage> {
  String? _id;
  String? _userImage;

  Future<Null> getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _id = prefs.getString("userId");
      _userImage = prefs.getString("image");
    });
  }

  @override
  void initState() {
    _id = "";
    _userImage = "";
    getSession();

    super.initState();
  }

  late AsyncValue<List<Event>> latest3registeredEvent;
  late List<Event>? registeredEvent;

  @override
  Widget build(BuildContext context) {
    latest3registeredEvent = const AsyncValue.loading();
    registeredEvent = [];
    final upcomingEventCount = ref.watch(getUpcomingEventsCount).value;
    final allUpcomingEvent = ref.watch(getAllUpcomingEvents).value;
    print("allUpcomingEvent");
    print(allUpcomingEvent);
    final upcomingEventOfMonth = ref.watch(getUpcomingEventsOfMonth);

    if (_id != '') {
      setState(() {
        latest3registeredEvent =
            ref.watch(getLatestUserRegisteredEvents(_id.toString()));
        registeredEvent =
            ref.watch(getUserRegisteredEvents(_id.toString())).value;
      });
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Events",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: _userImage!.isNotEmpty
                ? CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: SizedBox(
                      width: 180,
                      height: 180,
                      child: ClipOval(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: _userImage == "null"
                            ? Image.asset(
                                "assets/images/villager.png",
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                "${AppConstants.IP}/userImages/$_userImage",
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  )
                : const CircularProgressIndicator(),
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventList(
                            userId: _id!,
                            name: "All Upcoming Events",
                            events: allUpcomingEvent!,
                            userImage: _userImage!,
                          ),
                        ),
                      );
                    },
                    child: Container(
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
                            radius: 40,
                            child: upcomingEventCount != null
                                ? Text(
                                    "+$upcomingEventCount",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(color: TColors.black),
                                  )
                                : const CircularProgressIndicator(),
                          ),
                          Text(
                            "Upcoming Events!",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: TColors.white,
                                ),
                          )
                        ],
                      ),
                    ),
                  ),
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
                                  fontWeight: FontWeight.w900,
                                ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventList(
                                userId: _id!,
                                name: "Your Events",
                                events: registeredEvent!,
                                userImage: _userImage!,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 150,
                          height: 100,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: TColors.secondaryGreen,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: latest3registeredEvent.when(
                            data: (events) {
                              if (events.isEmpty) {
                                return const Center(
                                  child: Text("No Events!"),
                                );
                              }

                              return Stack(
                                alignment: Alignment.center,
                                children: events.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final event = entry.value;
                                  final topPosition = index *
                                      35.0; // Adjust the spacing between events

                                  return Positioned(
                                    left: topPosition,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 35,
                                      child: SizedBox(
                                        width: 180,
                                        height: 180,
                                        child: ClipOval(
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
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
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            error: (error, stackTrace) => Text('Error: $error'),
                          ),
                        ),
                      ),
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
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 270,
                child: upcomingEventOfMonth.when(
                  data: (events) {
                    // print("Upcoming Events of this month");
                    // print(events);

                    if (events.isEmpty) {
                      return Center(
                        child: Text(
                          "No Upcoming Events For this Month",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: TColors.black),
                        ),
                      );
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: events.length,
                      padding: const EdgeInsets.only(
                        left: 0,
                        right: 10,
                        top: 10,
                        bottom: 10,
                      ),
                      itemBuilder: (context, index) {
                        final event = events[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return EventDetailsPage(
                                event: event,
                                userImage: _userImage!,
                                userId: _id!,
                              );
                            }));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            width: 155,
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
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(100),
                                    ),
                                  ),
                                  child: Hero(
                                    tag: event.id!,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 20,
                                      child: SizedBox(
                                        width: 180,
                                        height: 180,
                                        child: ClipOval(
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
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
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  event.eventName.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(color: TColors.black),
                                ),
                                Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: TColors.black,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "${AppConstants.months[event.eventStartDate!.month - 1]} ${event.eventStartDate!.day}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: TColors.primaryGreen,
                                        ),
                                  ),
                                )
                              ],
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
      ),
    );
  }
}
