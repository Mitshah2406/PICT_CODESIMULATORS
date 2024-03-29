import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:pict_frontend/pages/Biowaste/blogs.dart';
import 'package:pict_frontend/pages/Biowaste/videos.dart';
import 'package:pict_frontend/pages/ChatBot/chatbot.dart';
import 'package:pict_frontend/pages/Events/event_details.dart';
import 'package:pict_frontend/providers/event_notifier.dart';
import 'package:pict_frontend/utils/constants/app_colors.dart';
import 'package:pict_frontend/utils/constants/app_constants.dart';
import 'package:pict_frontend/utils/logging/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pict_frontend/utils/geolocation/geolocation_service.dart';

import '../../models/Event.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  String? _name;
  String? _id;
  String? _userImage;
  String? _location;

  Future<Null> getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await GeolocationService.determinePosition();
    GeolocationService.storeLocation();
    setState(() {
      _name = prefs.getString("name");
      _id = prefs.getString("userId");
      _userImage = prefs.getString("image");
      _location = prefs.getString("cityName");
    });
  }

  @override
  void initState() {
    _name = "";
    _id = "";
    _userImage = "";
    _location = "";
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(getAllEvents);

    LoggerHelper.info(events.toString());
    print(_id);

    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    AppBar(
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 25,
                              color: TColors.white,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              maxLines: 1,
                              _location!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                            )
                          ],
                        ),
                      ),
                      centerTitle: true,
                      backgroundColor: TColors.primaryGreen,
                      // leading: Icon(Icons.),
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
                      // title: ,
                    ),
                    ClipPath(
                      child: SizedBox(
                        height: 80,
                        width: double.infinity,
                        child: Container(
                          decoration: const BoxDecoration(
                            // boxShadow: BoxShadow.lerp(a, b, t),
                            color: TColors.primaryGreen,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(100),
                            ),
                          ),
                          // color: ,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "EcoSaathi",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Text(
                "Services Categories",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: TColors.black, fontSize: 22),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const VideosPage(),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: TColors.black),
                          ),
                          child: Image.asset(
                            "assets/images/videos.png",
                            scale: 2,
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          "Videos",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: TColors.darkGrey,
                                  ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const BlogPage(),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: TColors.black),
                          ),
                          child: Image.asset(
                            "assets/images/blogs.png",
                            scale: 2,
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          "Blogs",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: TColors.darkGrey,
                                  ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const ChatBot(),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: TColors.black),
                          ),
                          child: Image.asset(
                            "assets/images/bot.png",
                            scale: 2,
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          "WasteBot",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: TColors.darkGrey,
                                  ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   CupertinoPageRoute(
                      //     builder: (context) => const ChatBot(),
                      //   ),
                      // );
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: TColors.black),
                          ),
                          child: Image.asset(
                            "assets/images/market.png",
                            scale: 2,
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          "Market",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: TColors.darkGrey,
                                  ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.all(10),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: [
            //       Container(
            //         height: 70,
            //         width: 70,
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(20),
            //           border: Border.all(color: TColors.black),
            //         ),
            //       ),
            //       Container(
            //         height: 70,
            //         width: 70,
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(20),
            //           border: Border.all(color: TColors.black),
            //         ),
            //       ),
            //       Container(
            //         height: 70,
            //         width: 70,
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(20),
            //           border: Border.all(color: TColors.black),
            //         ),
            //       ),
            //       Container(
            //         height: 70,
            //         width: 70,
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(20),
            //           border: Border.all(color: TColors.black),
            //         ),
            //       )
            //     ],
            //   ),
            // )
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20, bottom: 0),
              child: Text(
                "Recommended For You",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: TColors.black, fontSize: 22),
              ),
            ),

            Expanded(
              child: events.when(
                data: (events) {
                  if (events.isEmpty) {
                    return const Center(
                      child: Text("There are no events!"),
                    );
                  }

                  return ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      Event event = events[index];
                      Color color = index % 3 == 0
                          ? TColors.primaryYellow
                          : index % 3 == 1
                              ? TColors.accentGreen
                              : TColors.accentYellow;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => EventDetailsPage(
                                  event: event,
                                  userId: _id!,
                                  userImage: _userImage!,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          event.eventName.toString(),
                                          softWrap: true,
                                          // textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall!
                                              .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: TColors.black),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        event.volunteers!.isNotEmpty
                                            ? Text(
                                                event.volunteers!.length == 1
                                                    ? "${event.volunteers!.length} Volunteer"
                                                    : "${event.volunteers!.length} Volunteers",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelLarge!
                                                    .copyWith(
                                                        color: TColors.black),
                                              )
                                            : const SizedBox.shrink(),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "${AppConstants.months[event.eventStartDate!.month - 1]} ${event.eventStartDate!.day}"
                                              .toUpperCase(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge!
                                              .copyWith(color: TColors.black),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
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
                                ],
                              ),
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
            )
          ],
        ),
      ),
    );
  }
}
