import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wishtogether/constants.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) { //TODO Fix this shit
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color_primary,
        elevation: 10,
        title: Row(
          children: [
            Text(
              'Loading...',
              style: textstyle_appbar,
            ),
          ],
        ),
      ),
      body: Container(
        color: color_background,
        child: Center(
          child: SpinKitChasingDots(
            color: color_loading_spinner,
            size: 30,
          ),
        ),
      ),
    );
  }
}
