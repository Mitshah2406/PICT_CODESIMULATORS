import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pict_frontend/pages/Biowaste/blogs.dart';
import 'package:pict_frontend/pages/Biowaste/videos.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pict_frontend/utils/geolocation/geolocation_service.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  String? _name;
  String? _id;

  Future<Null> getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString("name");
      _id = prefs.getString("userId");
    });
    await GeolocationService.determinePosition();
  }

  @override
  void initState() {
    _name = "";
    _id = "";
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final getUpcomingEvents = ref.watch(getAllUpcomingEvents);
    // final getOngoingEvents = ref.watch(getAllOngoingEvents);
    // final getRegisteredEventsOfUsers =
    //     ref.watch(getUserRegisteredEvents(_id.toString()));
    // print(getUpcomingEvents.value?.map((e) => print(e.eventName)));
    // print(getOngoingEvents.value?.map((e) => print(e.eventName)));
    // print(getRegisteredEventsOfUsers.value?.map(
    //     (e) => e.registeredParticipants?.map((curr) => print(curr['userId']))));
    // print(getRegisteredEventsOfUsers.value?.map((e) => print(e.eventName)));
    // final getCompletedEventsOfUsers =
    //     ref.watch(getUserCompletedEvents(_id.toString()));
    // print(getCompletedEventsOfUsers.value?.map((e) => print(e.whatsAppLink)));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_name.toString()),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VideosPage(),
                ),
              );
            },
            child: const Text("Go to videos"),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BlogPage(),
                ),
              );
            },
            child: const Text("Go to Blogs"),
          ),
        ],
      ),
    );
  }
}
