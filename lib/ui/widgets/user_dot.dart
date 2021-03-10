import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/services/image_service.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/ui/custom_icons.dart';

enum SIZE {
  AUTHOR,
  SMALL,
  MEDIUM,
  LARGE,
  PROFILE,
}

class UserDot extends StatelessWidget {

  ImageProvider image;
  UserData userData;
  UserPreferences prefs;
  Color color;
  String name;
  bool owner;
  bool doShowName;
  bool showPicture;
  final SIZE size;

  UserDot({this.color, this.size, this.owner = false, this.doShowName = false});

  UserDot.fromUserData({UserData userData, this.size, this.owner = false, this.showPicture = true, this.doShowName = false}) {
    color = userData.userColor;
    name = userData.name;
    prefs = UserPreferences.from(userData);

    if(showPicture) {
      image = userData.profilePicture;
    }
  }

  UserDot.placeHolder({this.size, this.owner = false, this.doShowName = false}) {
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
      case SIZE.PROFILE: radius = 70; break;
      default: radius = 20; break;
    }

    double picFraction = 1;
    switch (size) {
      case SIZE.AUTHOR: picFraction = 0; break;
      case SIZE.SMALL: picFraction = 0.9; break;
      case SIZE.MEDIUM: picFraction = 0.9; break;
      case SIZE.LARGE: picFraction = 0.93; break;
      case SIZE.PROFILE: picFraction = 0.95; break;
      default: picFraction = 0; break;
    }

    return Column(
      children: [
        Stack(
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
                  radius: radius * picFraction,
                ),
              ),
            ),
          ]
        ),
        if(doShowName) SizedBox(height: 3),
        if(doShowName && name != null) Text(
          name,
          style: prefs.text_style_tiny,
        ),
      ],
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