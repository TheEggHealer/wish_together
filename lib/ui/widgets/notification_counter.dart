import 'package:flutter/material.dart';

import '../../models/user_preferences.dart';

class NotificationCounter extends StatelessWidget {

  UserPreferences prefs;
  int number;
  bool border;

  NotificationCounter({this.prefs, this.number, this.border = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: prefs.color_notification,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 2,
            offset: Offset(0, 1.5), // changes position of shadow
          ),
        ]
      ),
      constraints: BoxConstraints(
        minWidth: 18,
        minHeight: 18,
      ),
      child: Center(
        child: Text(
            '$number',
            textAlign: TextAlign.center,
            style: prefs.text_style_notification,
        ),
      ),
    );
  }
}
