import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:pict_frontend/pages/Auth/signup_screen.dart';
import 'package:pict_frontend/utils/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            bodyWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildImage("assets/images/intro_1.png"),
                Text(
                  textAlign: TextAlign.center,
                  "Welcome to the Future of Waste Management",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: TColors.primaryGreen),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    textAlign: TextAlign.center,
                    "Join us on a journey towards sustainability, where every action counts and every choice makes a difference.",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: TColors.darkGrey),
                  ),
                )
              ],
            ),
            title: "",
            decoration: getPageDecoration(),
          ),
          PageViewModel(
            bodyWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildImage("assets/images/intro_2.png"),
                Text(
                  textAlign: TextAlign.center,
                  "Practice the 3 R's",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: TColors.primaryGreen),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    textAlign: TextAlign.center,
                    "Explore innovative solutions, discover the power of recycling, and embrace the challenge of minimizing waste for a healthier planet. Together, lets build a greener, cleaner future for generations to come",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: TColors.darkGrey),
                  ),
                )
              ],
            ),
            title: "",
            decoration: getPageDecoration(),
          ),
          PageViewModel(
            bodyWidget: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildImage("assets/images/intro_3.png"),
                Text(
                  "Lets care for Mother Earth",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: TColors.primaryGreen),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    textAlign: TextAlign.center,
                    "Explore innovative solutions, discover the power of recycling, and embrace the challenge of minimizing waste for a healthier planet. Together, lets build a greener, cleaner future for generations to come.",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: TColors.darkGrey),
                  ),
                )
              ],
            ),
            title: "",
            decoration: getPageDecoration(),
          ),
        ],
        onDone: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool("isVisited", true);

          Navigator.push(context,
              CupertinoPageRoute(builder: (BuildContext context) {
            return const SignUpPage();
          }));
        },
        scrollPhysics: const ClampingScrollPhysics(),
        showDoneButton: true,
        showNextButton: true,
        showSkipButton: true,
        skip: Text(
          "Skip",
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: TColors.darkGrey),
        ),
        next: const Icon(Icons.navigate_next),
        done: Text("Done",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: TColors.darkGrey)),
        dotsDecorator: getDotsDecorator(),
      ),
    );
  }

  //widget to add the image on screen
  Widget buildImage(String imagePath) {
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
    );
  }

  //method to customise the page style
  PageDecoration getPageDecoration() {
    return const PageDecoration(
      imagePadding: EdgeInsets.only(top: 120),
      pageColor: Colors.white,
      bodyPadding: EdgeInsets.only(top: 8, left: 20, right: 20),
      titlePadding: EdgeInsets.only(top: 50),
      bodyTextStyle: TextStyle(color: Colors.black54, fontSize: 15),
    );
  }

  //method to customize the dots style
  DotsDecorator getDotsDecorator() {
    return const DotsDecorator(
      spacing: EdgeInsets.symmetric(horizontal: 5),
      activeColor: TColors.primaryGreen,
      color: Colors.grey,
      activeSize: Size(10, 10),
      size: Size(10, 10), // Set size to maintain the size of all dots
    );
  }
}
