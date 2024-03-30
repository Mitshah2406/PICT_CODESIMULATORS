import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pict_frontend/models/Report.dart';
import 'package:pict_frontend/pages/Report/reports.dart';
import 'package:pict_frontend/providers/report_notifier.dart';
import 'package:pict_frontend/utils/constants/app_colors.dart';
import 'package:pict_frontend/utils/constants/app_constants.dart';
import 'package:pict_frontend/widgets/image_input.dart';
import 'package:pict_frontend/widgets/location_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

class ReportPage extends ConsumerStatefulWidget {
  const ReportPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ReportPageState();
}

class _ReportPageState extends ConsumerState<ReportPage> {
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  Location? location;

  String? _id;
  String? _name;
  String? _email;
  String? _userImage;
  bool isLoading = false;

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

  // @override
  // void dispose() {
  //   super.dispose();
  //   _descriptionController.dispose();
  // }

  void _addReport() async {
    if (_formKey.currentState!.validate()) {
      // setState(() {
      //   isLoading = true;
      // });

      final enteredDescription = _descriptionController.text;

      if (_selectedImage == null || location == null) {
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              backgroundColor: TColors.error,
              content: Text(
                "Please add image and send location to submit report",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: TColors.textWhite,
                    ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Okay",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                )
              ],
            );
          },
        );
        return;
      }

      // print(_selectedImage?.path);

      Report newReport = Report(
        uploaderId: _id.toString(),
        uploaderEmail: _email,
        uploaderName: _name,
        description: enteredDescription,
        location: Location(
          lat: location?.lat,
          lon: location?.lon,
          formattedAddress: location?.formattedAddress.toString(),
        ),
        reportAttachment: _selectedImage!.path,
      );
      print(newReport.location);

      final res = await ref.read(reportNotifier.notifier).addReport(newReport);
      print(res);

      if (res) {
        // Fluttertoast.showToast(msg: "Report added successfully");
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const ReportsPage();
        }));

        setState(() {
          _descriptionController.text = "";
          _selectedImage = null;
          location = null;
        });
      }

      // setState(() {
      //   isLoading = false;
      // });
      // Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Reporting",
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
            ),
            Text(
              "Need To Report!",
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  // isDismissible: true,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  context: context,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please provide description";
                                }
                              },
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              controller: _descriptionController,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                                labelText: "Enter description",
                                labelStyle: TextStyle(
                                    fontSize: 14, color: Colors.grey.shade600),
                              ),
                              style: const TextStyle(
                                color: TColors.black,
                                fontSize: 16,
                              ),
                              maxLength: 50,
                            ),
                            Text(
                              "Camera photo",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                    color: TColors.black,
                                  ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            ImageInput(
                              image: (image) {
                                _selectedImage = image;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Location",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                    color: TColors.black,
                                  ),
                              textAlign: TextAlign.left,
                            ),
                            LocationInput(
                              onSelectLocation: (pickedLocation) {
                                location = pickedLocation;
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: _addReport,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: TColors.primaryGreen,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 10,
                                  ),
                                ),
                                label: Text(
                                  // isLoading
                                  // ? "Validating Report..."
                                  "Submit Report",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: TColors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                ),
                                icon: const Icon(Icons.report),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );

                // Navigator.push(context,
                //     CupertinoPageRoute(builder: (BuildContext context) {
                //   return const AddReportPage();
                // }));
              },
              child: Image.asset(
                alignment: Alignment.center,
                "assets/images/report.png",
                width: 280,
              ),
            ),
            // const SizedBox(
            //   height: 100,
            // ),
            // Divider(
            //   color: Colors.grey.shade500,
            //   endIndent: 10,
            //   indent: 10,
            // ),
            // Expanded(
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 50),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       // crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         GestureDetector(

            //           child: Container(
            //             padding: const EdgeInsets.all(5),
            //             width: 60,
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(50),
            //               border: Border.all(color: Colors.grey),
            //             ),
            //             child: Image.asset(
            //               "assets/images/report_icon.png",
            //               scale: 3,
            //             ),
            //           ),
            //         ),
            //         // const Spacer(
            //         //   flex: 1,
            //         // ),
            //         // Container(
            //         //   padding: const EdgeInsets.all(5),
            //         //   width: 60,
            //         //   decoration: BoxDecoration(
            //         //     borderRadius: BorderRadius.circular(50),
            //         //     border: Border.all(color: Colors.grey),
            //         //   ),
            //         //   child: Image.asset(
            //         //     "assets/images/robot.png",
            //         //     scale: 3,
            //         //   ),
            //         // ),
            //       ],
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
