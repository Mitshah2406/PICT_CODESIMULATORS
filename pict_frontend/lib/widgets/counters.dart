import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pict_frontend/providers/report_notifier.dart';
import 'package:pict_frontend/providers/user_notifier.dart';

class Counters extends ConsumerStatefulWidget {
  Counters(
      {super.key, required this.completedEventsCount, required this.userId});
  int? completedEventsCount;
  String? userId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CountersState();
}

class _CountersState extends ConsumerState<Counters> {
  late Future<int> reportsCount;
  late Future<int> rewardsCount;

  @override
  Widget build(BuildContext context) {
    reportsCount = Future.value(0);
    rewardsCount = Future.value(0);

    if (widget.userId != '') {
      setState(() {
        reportsCount = ref
            .read(reportNotifier.notifier)
            .getCountOfAllUserReports(widget.userId.toString());
        rewardsCount = ref
            .read(userNotifier.notifier)
            .getCountOfUserRewards(widget.userId.toString());
      });
    }

    return IntrinsicHeight(
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        MaterialButton(
          onPressed: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/approved.png',
                scale: 2,
              ),
              const SizedBox(
                height: 5,
              ),
              widget.completedEventsCount == null
                  ? const CircularProgressIndicator()
                  : Text(
                      widget.completedEventsCount.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
              const SizedBox(
                height: 5,
              ),
              const Text("Completed"),
              const Text("Events")
            ],
          ),
        ),
        VerticalDivider(
          color: Theme.of(context).dividerColor,
          thickness: 1,
          indent: 40,
          endIndent: 30,
        ),
        MaterialButton(
          onPressed: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/dollar.png',
                scale: 2,
              ),
              const SizedBox(
                height: 5,
              ),
              FutureBuilder<int>(
                future: rewardsCount,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final count = snapshot.data!;
                    return Text(
                      count.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 3,
              ),
              const Text("Rewards"),
              const Text("Earned")
            ],
          ),
        ),
        VerticalDivider(
          color: Theme.of(context).dividerColor,
          thickness: 1,
          indent: 40,
          endIndent: 30,
        ),
        MaterialButton(
          onPressed: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/reports.png',
                scale: 2,
              ),
              const SizedBox(
                height: 5,
              ),
              FutureBuilder<int>(
                future: reportsCount,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final count = snapshot.data!;
                    return Text(
                      count.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 3,
              ),
              const Text("Reports"),
              const Text("Count")
            ],
          ),
        ),
      ]),
    );
  }

  Widget buildButton(BuildContext context, String value, String text,
      {String text2 = ""}) {
    var button = MaterialButton(
      onPressed: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.fire_truck),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(
            height: 3,
          ),
          Text(text),
          text2 == "" ? Text('') : Text(text2),
        ],
      ),
    );
    return button;
  }
}
