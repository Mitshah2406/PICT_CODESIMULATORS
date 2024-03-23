import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pict_frontend/models/Event.dart';
import 'package:pict_frontend/pages/Auth/signin_screen.dart';
import 'package:pict_frontend/pages/Events/event_list.dart';
import 'package:pict_frontend/pages/Report/reports.dart';
import 'package:pict_frontend/pages/User/edit_user_profile.dart';
import 'package:pict_frontend/providers/event_notifier.dart';
import 'package:pict_frontend/utils/session/SharedPreference.dart';
import 'package:pict_frontend/widgets/language_dropdown.dart';

class profileOptions extends ConsumerStatefulWidget {
  profileOptions(
      {super.key,
      required this.name,
      required this.email,
      required this.userId,
      required this.userImage});
  String? userId;
  String? name;
  String? email;
  String? userImage;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _profileOptionsState();
}

class _profileOptionsState extends ConsumerState<profileOptions> {
  late List<Event>? getCompletedEventsOfUsers;
  //  registeredEvent;

  void signOut() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Are you sure?",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text("Once logged out, you need to login again"),
          actions: [
            TextButton(
              onPressed: () async {
                String res = await Utils.logout();

                if (res == "ok") {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return const SignInPage();
                  }));
                }
              },
              child: const Text("Okay"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    getCompletedEventsOfUsers = [];

    if (widget.userId != '') {
      setState(() {
        getCompletedEventsOfUsers = ref
            .watch(
              getUserCompletedEvents(widget.userId.toString()),
            )
            .value;
      });
    }

    return Card(
      margin: const EdgeInsets.fromLTRB(20, 410, 20, 0),
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                // ? We need to push the user to edit profile page.
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return EditProfilePage(
                    name: widget.name,
                    email: widget.email,
                    userId: widget.userId,
                    userImage: widget.userImage,
                  );
                }));
              },
              child: ListTile(
                leading: Icon(
                  Icons.edit_note,
                  size: 28,
                  color: Theme.of(context).primaryColor,
                ),
                title: const Text(
                  "Edit Profile",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                trailing: const Icon(Icons.keyboard_arrow_right),
              ),
            ),
            Divider(
              color: Theme.of(context).dividerColor,
              thickness: 1,
              indent: 8,
              endIndent: 10,
            ),
            GestureDetector(
              onTap: () {
                // ? Push the user to the get all completed events
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return EventList(
                    userId: widget.userId!,
                    name: "Your Completed Event",
                    events: getCompletedEventsOfUsers!,
                    userImage: widget.userImage!,
                  );
                }));
              },
              child: ListTile(
                leading: Icon(
                  size: 28,
                  Icons.done_all,
                  color: Theme.of(context).primaryColor,
                ),
                title: const Text(
                  "My Completed Events",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: const Icon(Icons.keyboard_arrow_right),
              ),
            ),
            Divider(
              color: Theme.of(context).dividerColor,
              thickness: 1,
              indent: 8,
              endIndent: 10,
            ),
            GestureDetector(
              onTap: () {
                // ? Push the user to their reports page
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const ReportsPage();
                }));
              },
              child: ListTile(
                leading: Icon(
                  Icons.report,
                  size: 28,
                  color: Theme.of(context).primaryColor,
                ),
                title: const Text(
                  "My Reports",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: const Icon(Icons.keyboard_arrow_right),
              ),
            ),
            Divider(
              color: Theme.of(context).dividerColor,
              thickness: 1,
              indent: 8,
              endIndent: 10,
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.globe,
                size: 28,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text(
                "Languages",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text("English"),
              trailing: const langDropdownMenu(),
            ),
            Divider(
              color: Theme.of(context).dividerColor,
              thickness: 1,
              indent: 8,
              endIndent: 10,
            ),
            GestureDetector(
              onTap: () {
                signOut();
              },
              child: const ListTile(
                leading: Icon(
                  Icons.logout_outlined,
                  size: 28,
                  color: Colors.red,
                ),
                title: Text(
                  "Sign out",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
