import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pict_frontend/models/BioWaste.dart';
import 'package:pict_frontend/pages/Biowaste/youtube.dart';
import 'package:pict_frontend/providers/biowaste_notifier.dart';
import 'package:pict_frontend/utils/constants/app_colors.dart';
import 'package:pict_frontend/utils/constants/app_constants.dart';
import 'package:pict_frontend/utils/logging/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class BlogPage extends ConsumerStatefulWidget {
  const BlogPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BlogPageState();
}

class _BlogPageState extends ConsumerState<BlogPage> {
  String? _id;
  String? _name;
  String? _userImage;

  Future<Null> getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _id = prefs.getString("userId");
      _name = prefs.getString("name");
      _userImage = prefs.getString("image");
    });
  }

  @override
  void initState() {
    _id = "";
    _name = "";
    _userImage = "";
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<List<BioWaste>> blogs =
        ref.watch(bioWasteNotifier.notifier).getBlogResources();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Educational Blogs",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: _userImage != ""
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
      body: FutureBuilder(
        future: blogs,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occurred 1',
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
                    "There are no educational blogs available!",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: TColors.black),
                  ),
                );
              }

              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  BioWaste blog = data[index];
                  Color color = index % 3 == 0
                      ? const Color(0xFFE0FFE5)
                      : index % 3 == 1
                          ? const Color(0xFFFFDD65)
                          : const Color(0xFFFEFDED);
                  Color borderColor = index % 3 == 0
                      ? Color.fromARGB(255, 86, 246, 113)
                      : index % 3 == 1
                          ? Color.fromARGB(255, 233, 188, 25)
                          : Color.fromARGB(255, 239, 233, 149);
                  DateTime currentDate = DateTime.now();
                  int differenceInDays =
                      currentDate.difference(blog.datePublished!).inDays;
                  LoggerHelper.info(differenceInDays.toString());

                  return Stack(
                    children: [
                      Card(
                        color: color,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: blog.images!.isEmpty
                                ? Image.asset(
                                    "assets/images/biowaste-fallback.jpg")
                                : Image.network(
                                    "${AppConstants.IP}/biowaste/${blog.images?[0]}",
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          title: Text(
                            blog.title!,
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
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                blog.description!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: TColors.black),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  // We need to launch url
                                  // const url = 'https://blog.logrocket.com';
                                  if (await canLaunchUrl(
                                      Uri.parse(blog.link!))) {
                                    await launchUrl(Uri.parse(blog.link!));
                                  } else {
                                    throw 'Could not launch ${blog.link}';
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0.2,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 5,
                                  ),
                                  foregroundColor: TColors.white,
                                  backgroundColor: TColors.buttonPrimary,
                                  side: BorderSide(
                                    width: 2,
                                    color: color,
                                  ),
                                ),
                                child: Text(
                                  "Open Now",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: TColors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          isThreeLine: true,
                        ),
                      ),
                      if (differenceInDays < 7 && differenceInDays > 0)
                        const Positioned(
                          top: 2, // Adjust position as needed
                          right: 10, // Adjust position as needed
                          child: Badge(
                            backgroundColor: TColors.primaryGreen,
                            textStyle: TextStyle(
                              color: TColors.white,
                            ),
                            label: Text("New"),
                            padding: EdgeInsets.all(5),
                            largeSize: 28,
                          ),
                        ),
                    ],
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
    );
  }
}
