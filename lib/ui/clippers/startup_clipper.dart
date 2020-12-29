import 'package:flutter/cupertino.dart';
import 'package:wishtogether/constants.dart';

class StartupClipper extends CustomClipper<Path> {

  @override
  getClip(Size size) {
    double bottomLeft = size.height;
    double bottomRight = bottomLeft - size.height * C_startup_scaffold_diff;
    double width = size.width;

    Path path = Path();
    path.lineTo(0, bottomLeft);
    path.lineTo(width, bottomRight);
    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return false; //May have to be changed
  }

}