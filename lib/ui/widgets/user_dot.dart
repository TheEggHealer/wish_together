import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wishtogether/models/user_data.dart';

enum SIZE {
  AUTHOR,
  SMALL,
  MEDIUM,
  LARGE
}

class UserDot extends StatelessWidget {

  Color color;
  final SIZE size;

  UserDot({this.color, this.size});

  UserDot.fromUserData({UserData userData, this.size}) {
    color = userData.userColor;
  }

  UserDot.placeHolder({this.size}) {
    color = Color(0x00000000);
  }

  @override
  Widget build(BuildContext context) {

    double radius = 0;
    switch (size) {
      case SIZE.AUTHOR: radius = 12; break;
      case SIZE.SMALL: radius = 20; break;
      case SIZE.MEDIUM: radius = 40; break;
      case SIZE.LARGE: radius = 60; break;
    }

    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: SizedBox(
        width: radius,
        height: radius,
      ),
    );
  }
}

class DotPainter extends CustomPainter {

  final Color color;
  final double radius;

  DotPainter({this.color, this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    //a circle
    canvas.drawCircle(Offset(0, 0), radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}