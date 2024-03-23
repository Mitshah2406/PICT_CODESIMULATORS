import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pict_frontend/models/Report.dart';
import 'package:pict_frontend/providers/report_notifier.dart';
import 'package:pict_frontend/utils/constants/app_colors.dart';
import 'package:pict_frontend/utils/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReportsPageState();
}

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

class _ReportsPageState extends ConsumerState<ReportsPage> {
  String? _name;
  String? _id;

  Future<Null> getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString("name");
      _id = prefs.getString("userId");
    });
  }

  @override
  void initState() {
    _name = "";
    _id = "";
    getSession();
    super.initState();
  }

  String? selectedFilter = "pending";

  List<String> filterOptions = ['pending', 'rejected', 'resolved'];
  late Future<List<Report>> reports;

  @override
  Widget build(BuildContext context) {
    reports = Future.value([]);

    if (_id != '') {
      setState(() {
        reports = ref
            .read(reportNotifier.notifier)
            .getAllUserReports(_id.toString(), selectedFilter!);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Reports"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Wrap(
            spacing: 8.0,
            children: filterOptions.map((filter) {
              return FilterChip(
                selectedColor: TColors.primaryGreen,
                label: Text(capitalize(filter)),
                selected: selectedFilter == filter,
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      selectedFilter = filter;
                    }
                  });
                },
              );
            }).toList(),
          ),
          Expanded(
            child: FutureBuilder(
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error} occurred',
                        style: const TextStyle(fontSize: 18),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final data = snapshot.data;

                    if (data!.isEmpty) {
                      return const Center(
                        child: Text("You haven't added any report yet!"),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final report = data[index];

                        return Card(
                          child: Center(
                            child: ListTile(
                              titleAlignment: ListTileTitleAlignment.center,
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  child: FadeInImage.memoryNetwork(
                                    fit: BoxFit.cover,
                                    width: 80,
                                    height: 50,
                                    placeholder: kTransparentImage,
                                    image:
                                        "${AppConstants.IP}/reportAttachments/${report.reportAttachment}",
                                  ),
                                ),
                              ),
                              title: Text(
                                report.uploaderName!,
                                style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Text(
                                maxLines: 2,
                                report.description!,
                                style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              // trailing:
                              isThreeLine: true,
                            ),
                          ),
                        );
                      },
                    );
                  }
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              future: reports,
            ),
          )
        ],
      ),
    );
  }
}
