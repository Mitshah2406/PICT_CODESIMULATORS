import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pict_frontend/models/Event.dart';
import 'package:pict_frontend/providers/event_notifier.dart';
import 'package:pict_frontend/providers/report_notifier.dart';
import 'package:pict_frontend/utils/constants/app_constants.dart';
import 'package:pict_frontend/widgets/counters.dart';
import 'package:pict_frontend/widgets/customShape.dart';
import 'package:pict_frontend/widgets/profileOptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

class UserProfilePage extends ConsumerStatefulWidget {
  const UserProfilePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserProfilePageState();
}

class _UserProfilePageState extends ConsumerState<UserProfilePage> {
  String? _id;
  String? _name;
  String? _email;
  String? _userImage;

  Future<Null> getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _id = prefs.getString("userId");
      _name = prefs.getString("name");
      _email = prefs.getString("email");
      _userImage = prefs.getString("image");
    });
  }

  @override
  void initState() {
    _id = "";
    _name = "";
    _email = "";
    _userImage = "";
    getSession();
    super.initState();
  }

  // int? userReportCount;

  late AsyncValue<List<Event>> eventsCount;
  int? completedCount;

  @override
  Widget build(BuildContext context) {
    eventsCount = const AsyncValue.loading();

    if (_id != '') {
      setState(() {
        eventsCount = ref.watch(getUserCompletedEvents(_id.toString()));
        completedCount = eventsCount.value?.length;
      });
    }

    return Scaffold(
      // bottomNavigationBar: BottomNavVendor(index: 3),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Column(
              children: [
                AppBar(
                  centerTitle: true,
                  backgroundColor: Colors.green,
                  actions: [
                    IconButton(
                      onPressed: () {
                        // if (Get.isDarkMode) {
                        //   Get.changeTheme(ThemeManager.lightTheme);
                        // } else {
                        //   Get.changeTheme(ThemeManager.darkTheme);
                        // }
                        // ;
                      },
                      icon: const Icon(
                        Icons.dark_mode,
                        color: Colors.white,
                      ),
                    )
                  ],
                  title: const Text(
                    "Your Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                ClipPath(
                  clipper: CustomShape(),
                  child: SizedBox(
                    height: 200,
                    child: Container(
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            Positioned.fill(
              bottom: 350,
              child: Align(
                alignment: Alignment.center,
                child: _userImage!.isNotEmpty
                    ? CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 70,
                        child: SizedBox(
                          width:
                              180, // Diameter of the CircleAvatar is twice the radius
                          height: 180,
                          child: ClipOval(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: _userImage == "null"
                                ? Image.asset(
                                    "assets/images/logo.png",
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
              ),
            ),
            Positioned.fill(
              bottom: 160,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  _name.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              bottom: 110,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  _email.toString(),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              bottom: -50,
              child: Align(
                alignment: Alignment.center,
                child: Counters(
                  completedEventsCount: completedCount,
                  userId: _id,
                ),
              ),
            ),
            Positioned.fill(
              bottom: 10,
              child: Align(
                alignment: Alignment.center,
                child: profileOptions(
                  name: _name,
                  email: _email,
                  userId: _id,
                  userImage: _userImage,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
