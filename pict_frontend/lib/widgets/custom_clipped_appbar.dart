import 'package:flutter/material.dart';
import 'package:pict_frontend/utils/constants/custom_appbar_shape.dart';

class CustomClippedAppbar extends StatefulWidget {
  const CustomClippedAppbar({super.key});

  @override
  State<CustomClippedAppbar> createState() => _CustomClippedAppbarState();
}

class _CustomClippedAppbarState extends State<CustomClippedAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 150,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      flexibleSpace: ClipPath(
        clipper: CustomAppBarShape(),
        child: Container(
          height: 250,
          width: MediaQuery.of(context).size.width,
          color: Colors.red,
          child: const Center(
              child: Text(
            "Subscribe to Proto Coders Point",
            style: TextStyle(fontSize: 20, color: Colors.white),
          )),
        ),
      ),
    );
  }
}
