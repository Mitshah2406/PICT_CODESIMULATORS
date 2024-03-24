import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pict_frontend/models/Report.dart';
import 'package:pict_frontend/pages/Report/reports.dart';
import 'package:pict_frontend/providers/report_notifier.dart';
import 'package:pict_frontend/utils/constants/app_colors.dart';
import 'package:pict_frontend/widgets/image_input.dart';
import 'package:pict_frontend/widgets/location_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddReportPage extends ConsumerStatefulWidget {
  const AddReportPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddReportPageState();
}

class _AddReportPageState extends ConsumerState<AddReportPage> {
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  Location? location;

  String? _id;
  String? _name;
  String? _email;

  Future<Null> getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _id = prefs.getString("userId");
      _name = prefs.getString("name");
      _email = prefs.getString("email");
    });
  }

  @override
  void initState() {
    _id = "";
    _name = "";
    _email = "";
    getSession();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  void _addReport() async {
    if (_formKey.currentState!.validate()) {
      final enteredDescription = _descriptionController.text;

      if (_selectedImage == null || location == null) {
        showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              backgroundColor: Colors.red,
              content: Text(
                "Please add image and send location to submit report",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onError,
                    ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Okay",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
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
      print(newReport.reportAttachment);
      final res = await ref.read(reportNotifier.notifier).addReport(newReport);
      print(res);

      if (res) {
        // Fluttertoast.showToast(msg: "Report added successfully");
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const ReportsPage();
        }));
      }
      // Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Report Dumpsites",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: TColors.primaryGreen,
              ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                controller: _descriptionController,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  labelText: "Enter description",
                  labelStyle:
                      TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                style: const TextStyle(
                  color: TColors.black,
                  fontSize: 16,
                ),
                maxLength: 50,
              ),
              Text(
                "Camera photo",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
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
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
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
                    "Submit Report",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
      ),
    );
  }
}
