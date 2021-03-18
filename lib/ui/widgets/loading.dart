import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/user_preferences.dart';

class Loading extends StatelessWidget {

  UserPreferences prefs;

  Loading({this.prefs});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: prefs.color_background,
      child: Center(
        child: SpinKitChasingDots(
          color: prefs.color_spinner,
          size: 30,
        ),
      ),
    );
  }
}
