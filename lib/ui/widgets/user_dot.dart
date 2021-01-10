import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wishtogether/database/image_service.dart';
import 'package:wishtogether/models/user_data.dart';

enum SIZE {
  AUTHOR,
  SMALL,
  MEDIUM,
  LARGE
}

class UserDot extends StatelessWidget {

  ImageProvider image;
  UserData userData;
  Color color;
  final SIZE size;

  UserDot({this.color, this.size});

  UserDot.fromUserData({UserData userData, this.size}) {
    color = userData.userColor;

    if(size == SIZE.MEDIUM || size == SIZE.LARGE) {
      image = userData.profilePicture;
    }
  }

  UserDot.placeHolder({this.size}) {
    color = Color(0x00000000);
  }


  @override
  Widget build(BuildContext context) {

    double radius = 0;
    switch (size) {
      case SIZE.AUTHOR: radius = 6; break;
      case SIZE.SMALL: radius = 10; break;
      case SIZE.MEDIUM: radius = 20; break;
      case SIZE.LARGE: radius = 30; break;
    }

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: SizedBox(
            width: radius*2,
            height: radius*2,
          ),
        ),
        if(image != null) Container(
          width: radius*2,
          height: radius*2,
          child: Center(
            child: CircleAvatar(
              backgroundImage: image,
              backgroundColor: Colors.transparent,
              radius: radius * 0.9,
            ),
          ),
        )
      ]
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