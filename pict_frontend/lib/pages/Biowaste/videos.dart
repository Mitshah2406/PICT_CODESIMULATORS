import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pict_frontend/models/BioWaste.dart';
import 'package:pict_frontend/pages/Biowaste/youtube.dart';
import 'package:pict_frontend/providers/biowaste_notifier.dart';
import 'package:pict_frontend/utils/constants/app_colors.dart';
import 'package:pict_frontend/utils/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideosPage extends ConsumerStatefulWidget {
  const VideosPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VideosPageState();
}

class _VideosPageState extends ConsumerState<VideosPage> {
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
    Future<List<BioWaste>> videos =
        ref.watch(bioWasteNotifier.notifier).getVideoResources();

    print(videos);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Educational Videos",
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
        future: videos,
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
                    "There are no educational videos available!",
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
                  BioWaste video = data[index];
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
                      currentDate.difference(video.datePublished!).inDays;

                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
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
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: borderColor,
                                      width: 1,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 42,
                                    child: SizedBox(
                                      width: 180,
                                      height: 180,
                                      child: ClipOval(
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        child: video.images!.isEmpty
                                            ? Image.asset(
                                                "assets/images/biowaste-fallback.jpg")
                                            : Image.network(
                                                "${AppConstants.IP}/biowaste/${video.images?[0]}",
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        video.title!,
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
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        video.description!,
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
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  YoutubeScreen(
                                                link: video.link!,
                                                title: video.title!,
                                              ),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0.2,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 5,
                                          ),
                                          foregroundColor: TColors.white,
                                          backgroundColor:
                                              const Color(0xFFFA7070),
                                          side: BorderSide(
                                            width: 2,
                                            color: color,
                                          ),
                                        ),
                                        child: Text(
                                          "Watch Now",
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
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Conditionally show badge
                      if (differenceInDays < 7 && differenceInDays > 0)
                        const Positioned(
                          top: 2,
                          right: 10,
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
