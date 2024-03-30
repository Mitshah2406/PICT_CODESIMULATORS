import 'dart:async';

import 'package:filter_list/filter_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pict_frontend/models/Report.dart';
import 'package:pict_frontend/pages/Report/report_detail.dart';
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

class _ReportsPageState extends ConsumerState<ReportsPage> {
  String? _name;
  String? _id;
  String? _userImage;

  Future<Null> getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString("name");
      _id = prefs.getString("userId");
      _userImage = prefs.getString("image");
    });
  }

  @override
  void initState() {
    _name = "";
    _id = "";
    _userImage = "";
    getSession();
    super.initState();
  }

  late Future<List<Report>> reports;
  String? selectedFilter;

  List<String> filterOptions = ['pending', 'rejected', 'resolved'];
  List<String>? selectedList;

  void openFilterDialog() async {
    await FilterListDialog.display<String>(
      context,
      hideSearchField: true,
      headlineText: "Your Filter",
      controlButtons: [ControlButtonType.Reset],
      listData: filterOptions,
      selectedListData: selectedList != null && selectedList!.isNotEmpty
          ? [selectedList![0]]
          : [],
      choiceChipLabel: (e) => AppConstants.capitalize(e.toString()),
      hideSelectedTextCount: true,
      insetPadding: const EdgeInsets.all(20),
      barrierDismissible: true,
      enableOnlySingleSelection: true,

      borderRadius: 20,
      height: 300,
      // searchPlaceholder: "",
      validateSelectedItem: (list, val) => list!.contains(val),
      onItemSearch: (e, query) {
        return e.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (List<String>? list) {
        if (list != null && list.isNotEmpty) {
          setState(() {
            selectedList = list;
          });
        } else {
          setState(() {
            selectedList = null;
          });
        }
        Navigator.pop(context);
      },
    );
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (selectedList == null) {
      selectedFilter = "";
    } else {
      selectedFilter = selectedList![0];
    }
    reports = Future.value([]);

    if (_id != '') {
      // print("Calledd");
      setState(() {
        reports = ref
            .read(reportNotifier.notifier)
            .getAllUserReports(_id.toString(), selectedFilter!);
      });
    }

    // void searchReport(String query) {
    //   print(query);
    //   setState(() {
    //     reports = ref.read(reportNotifier.notifier).getSearchReport(query);
    //   });
    //   print(reports);
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Reports",
          style: Theme.of(context).textTheme.headlineMedium,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Expanded(
                //   child: Container(
                //     padding: const EdgeInsets.all(10),
                //     child: TextFormField(
                //       controller: _searchController,
                //       decoration: InputDecoration(
                //         labelText: 'Search your reports...',
                //         labelStyle: TextStyle(
                //           color: Colors.grey.shade600,
                //           fontSize: 14,
                //         ),
                //         border: const OutlineInputBorder(),
                //         // suffixIcon: const Icon(Icons.search),
                //         // suffixIconColor: TColors.darkGrey,
                //       ),
                //     ),
                //   ),
                // ),
                // IconButton(
                //   onPressed: () {
                //     searchReport(_searchController.text);
                //     print("Called");
                //   },
                //   icon: const Icon(Icons.search),
                // ),
                IconButton(
                  onPressed: openFilterDialog,
                  icon: const Icon(
                    Icons.tune,
                    size: 35,
                  ),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder(
                future: reports,
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          '${snapshot.error} occurred',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: TColors.black),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      final data = snapshot.data;
                      print(data!.length);

                      if (data.isEmpty) {
                        return Center(
                          child: Text(
                            selectedFilter == null
                                ? "You haven't added any report yet!"
                                : "No $selectedFilter reports!",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: TColors.black),
                          ),
                        );
                      }

                      // print(data.map((e) => print(data)));

                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          Report report = data[index];
                          Color color = index % 3 == 0
                              ? TColors.primaryYellow
                              : index % 3 == 1
                                  ? TColors.accentGreen
                                  : TColors.accentYellow;
                          Color borderColor = index % 3 == 0
                              ? Color.fromARGB(255, 239, 189, 8)
                              : index % 3 == 1
                                  ? Color.fromARGB(255, 98, 236, 121)
                                  : Color.fromARGB(255, 79, 212, 102);

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => ReportDetail(
                                      report: report,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: borderColor,
                                  ),
                                  color: color,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              report.description != null
                                                  ? report.description
                                                      .toString()
                                                  : "",
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: TColors.black,
                                                  ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              report.location
                                                          ?.formattedAddress !=
                                                      null
                                                  ? report.location!
                                                      .formattedAddress
                                                      .toString()
                                                  : "",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      color: TColors.black),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      CupertinoPageRoute(
                                                        builder: (context) =>
                                                            ReportDetail(
                                                          report: report,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 8,
                                                      vertical: 5,
                                                    ),
                                                    foregroundColor:
                                                        TColors.black,
                                                    backgroundColor:
                                                        TColors.white,
                                                    side: const BorderSide(
                                                      width: 0,
                                                      color: TColors.white,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "More",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                          color: TColors.black,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                ElevatedButton(
                                                  onPressed: () {},
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 8,
                                                      vertical: 5,
                                                    ),
                                                    foregroundColor:
                                                        TColors.black,
                                                    backgroundColor:
                                                        borderColor,
                                                    side: BorderSide(
                                                      width: 2,
                                                      color: color,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    AppConstants.capitalize(
                                                        report.reportStatus
                                                            .toString()),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!
                                                        .copyWith(
                                                          color: TColors.black,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Hero(
                                        tag: report.id!,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 50,
                                          child: SizedBox(
                                            width: 180,
                                            height: 180,
                                            child: ClipOval(
                                              clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                              child: Image.network(
                                                "${AppConstants.IP}/reportAttachments/${report.reportAttachment}",
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
                    }
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
