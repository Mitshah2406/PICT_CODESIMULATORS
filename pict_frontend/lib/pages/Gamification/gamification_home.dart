import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pict_frontend/models/Task.dart';
import 'package:pict_frontend/providers/task_notifier.dart';
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
  void initState() {
    _id = "";
    _userImage = "";
    getSession();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<List<Task>> tasks = ref.read(taskNotifier.notifier).getRandomTask();

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
      body: Padding(
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
                              padding: const EdgeInsets.only(left: 15, top: 10),
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
                                  child: Image.asset("assets/images/chart.png"),
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
              Expanded(
                child: FutureBuilder(
                  future: tasks,
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
                              "No daily task Assigned!",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: TColors.black),
                            ),
                          );
                        }

                        // print(data.map((e) => print(data)));

                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            Task task = data[index];

                            print(task);

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFC5EBAA),
                                  // color: color,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              task.taskTitle.toString(),
                                              softWrap: true,
                                              // textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: TColors.black),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              task.taskDescription.toString(),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              // textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    color: TColors.darkGrey,
                                                  ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Column(
                                                      children: [
                                                        Text(
                                                          "Capture a picture to complete your task",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleLarge!
                                                                  .copyWith(
                                                                    color: TColors
                                                                        .black,
                                                                  ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary,
                                                            ),
                                                          ),
                                                          height: 180,
                                                          width: 200,
                                                          child: content,
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            final res = await ref
                                                                .read(taskNotifier
                                                                    .notifier)
                                                                .validateTask(
                                                                    task.taskTitle
                                                                        .toString(),
                                                                    _selectedImage!
                                                                        .path,
                                                                    _id
                                                                        .toString(),
                                                                    task.id
                                                                        .toString());

                                                            print(res);
                                                          },
                                                          child: const Text(
                                                              "Submit"),
                                                        )
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                backgroundColor: TColors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 40,
                                        child: SizedBox(
                                          width: 180,
                                          height: 180,
                                          child: ClipOval(
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            child: Image.asset(
                                              "assets/images/task.jpg",
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
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
      ),
    );
  }
}
