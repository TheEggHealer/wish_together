import 'package:flutter/material.dart';
import 'package:wishtogether/models/user_data.dart';

enum SIZE {
  SMALL,
  MEDIUM,
  LARGE
}

class UserDot extends StatelessWidget {

  final UserData userData;
  final SIZE size;

  UserDot({this.userData, this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: userData.userColor,
        shape: BoxShape.circle,
      ),
      child: SizedBox(
        width: size == SIZE.SMALL ? 20 : size == SIZE.MEDIUM ? 40 : 60,
        height: size == SIZE.SMALL ? 20 : size == SIZE.MEDIUM ? 40 : 60,
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