import 'package:flutter/material.dart';
import 'package:pict_frontend/pages/User/user_dashboard.dart';

import 'package:pict_frontend/utils/constants/app_colors.dart';

class EventEnrollSuccessPage extends StatefulWidget {
  const EventEnrollSuccessPage({super.key});

  @override
  State<EventEnrollSuccessPage> createState() => _EventEnrollSuccessPageState();
}

class _EventEnrollSuccessPageState extends State<EventEnrollSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              // Wrapping the image with Center widget
              child: SizedBox(
                height: 200,
                child: Image.asset(
                  "assets/images/congrats_event_tick.png",
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text("Congratulations!",
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(
              height: 20,
            ),
            Text(
              "You have successfully enrolled for the event!",
              textAlign: TextAlign.center,
              softWrap: true,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const UserDashboard(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primaryGreen,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text("Go To Home"),
            )
          ],
        ),
      ),
    );
  }
}
