import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pict_frontend/models/Task.dart';
import 'package:pict_frontend/pages/User/user_home_screen.dart';
import 'package:pict_frontend/providers/task_notifier.dart';
import 'package:pict_frontend/utils/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ValidateTask extends ConsumerStatefulWidget {
  const ValidateTask({super.key, required this.task});
  final Task task;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ValidateTaskState();
}

class _ValidateTaskState extends ConsumerState<ValidateTask> {
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

  File? _selectedImage;

  void _takePicture() async {
    final ImagePicker imagePicker = ImagePicker();

    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxHeight: 600);

    if (pickedImage == null) {
      return;
    }

    File fileImage = File(pickedImage.path);

    setState(() {
      _selectedImage = fileImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Task task = widget.task;

    Widget content = TextButton.icon(
      onPressed: _takePicture,
      icon: const Icon(
        Icons.camera,
        color: TColors.primaryGreen,
      ),
      label: Text(
        "Take Image",
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: TColors.primaryGreen),
      ),
    );

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(task.taskTitle.toString()),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Capture a picture to complete your task",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: TColors.primaryGreen,
                  ),
                ),
                height: 250,
                width: double.infinity,
                child: content,
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () async {
                  final res =
                      await ref.read(taskNotifier.notifier).validateTask(
                            task.taskTitle.toString(),
                            _selectedImage!.path,
                            _id.toString(),
                            task.id.toString(),
                          );

                  if (res == true) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Hurray!'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset("assets/images/dollar.png"),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Your task is completed successfully!. You have earned an reward!",
                              )
                            ],
                          ),
                          actions: [
                            TextButton(
                              child: const Text('Okay'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    Fluttertoast.showToast(
                      msg: "The task is not validated",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                },
                child: const Text("Submit your task"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
