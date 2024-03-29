import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pict_frontend/utils/constants/app_colors.dart';
import 'package:pict_frontend/utils/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GamificationHomePage extends ConsumerStatefulWidget {
  const GamificationHomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GamificationHomePageState();
}

class _GamificationHomePageState extends ConsumerState<GamificationHomePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Gamification",
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
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xFFFC5EBAA),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 170,
                          height: 250,
                          decoration: const BoxDecoration(
                            color: TColors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, top: 10),
                                child: Text(
                                  "Your week",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: TColors.darkerGrey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: TColors.white,
                                    radius: 50,
                                    child:
                                        Image.asset("assets/images/chart.png"),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        "assets/images/report_game.png",
                                        scale: 1.5,
                                      ),
                                      const Text("4/7"),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Image.asset(
                                        "assets/images/report_game.png",
                                        scale: 1.5,
                                      ),
                                      const Text("4/7"),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Image.asset(
                                "assets/images/game_wave.png",
                                // scale: 1,
                                // fit: BoxFit.cover,
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 145,
                            height: 60,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: TColors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Image.asset("assets/images/badge.png"),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: 145,
                            height: 170,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: TColors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Tasks",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color: TColors.darkerGrey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: 10,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        title: const Text(
                                          overflow: TextOverflow.ellipsis,
                                          "Hello Taskssss",
                                        ),
                                        trailing: Image.asset(
                                          "assets/images/villager.png",
                                          scale: 2,
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  "Your Today's Task",
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: TColors.darkerGrey, fontSize: 30),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   CupertinoPageRoute(
                      //     builder: (context) => EventDetailsPage(
                      //       event: event,
                      //       userId: widget.userId,
                      //       userImage: widget.userImage,
                      //     ),
                      //   ),
                      // );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFC5EBAA),
                        // color: color,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Your task title comes here..",
                                    softWrap: true,
                                    // textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: TColors.black),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: TColors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 10,
                                      ),
                                    ),
                                    child: Text(
                                      "Do Now",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            color: TColors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Hero(
                              tag: "1",
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 40,
                                child: SizedBox(
                                  width: 180,
                                  height: 180,
                                  child: ClipOval(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    // child: event.eventPoster == null
                                    //     ? Image.network(
                                    //         "${AppConstants.IP}/poster/fallback-poster.png",
                                    //         fit: BoxFit.cover,
                                    //       )
                                    // :
                                    // Image.network(
                                    //       "${AppConstants.IP}/poster/${event.eventPoster}",
                                    //       fit: BoxFit.cover,
                                    //     ),
                                    child: Image.asset(
                                      "assets/images/villager.png",
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
