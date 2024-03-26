import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pict_frontend/utils/constants/app_colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeScreen extends StatefulWidget {
  const YoutubeScreen({super.key, required this.link, required this.title});
  final String link;
  final String title;

  @override
  State<YoutubeScreen> createState() => _YoutubeScreenState();
}

String? extractYouTubeVideoId(String url) {
  RegExp regExp = RegExp(
    r"(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})",
    caseSensitive: false,
    multiLine: false,
  );
  Match? match = regExp.firstMatch(url);
  return match?.group(1);
}

class _YoutubeScreenState extends State<YoutubeScreen> {
  late YoutubePlayerController _controller;
  bool isFullScreen = false;

  @override
  void initState() {
    super.initState();
    String? videoId = extractYouTubeVideoId(widget.link);

    _controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        forceHD: true,
      ),
    );
    _controller.addListener(() {
      if (_controller.value.isFullScreen != isFullScreen) {
        setState(() {
          isFullScreen = _controller.value.isFullScreen;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        setState(() {
          isFullScreen = false;
        });
      },
      player: YoutubePlayer(
        controller: _controller,
        onEnded: (metadata) => {Navigator.pop(context)},
        liveUIColor: TColors.primaryGreen,
        thumbnail: Image.asset(
          "assets/images/yt.jpg",
          fit: BoxFit.cover,
        ),
        showVideoProgressIndicator: true,
        progressIndicatorColor: TColors.primaryGreen,
      ),
      builder: (context, player) => Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            player,
          ],
        ),
      ),
    );
  }
}
