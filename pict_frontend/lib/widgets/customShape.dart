import 'package:flutter/cupertino.dart';

class CustomShape extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var path = Path();
    print(height);
    path.lineTo(0, height - 90);
    path.quadraticBezierTo(width * .50, height - 200, width, height - 90);
    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
