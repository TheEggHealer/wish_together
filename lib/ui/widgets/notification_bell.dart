import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/screens/drawer/notifications_screen.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/ui/custom_icons.dart';
import 'package:wishtogether/ui/widgets/notification_counter.dart';

class NotificationBell extends StatefulWidget {

  final UserData userData;

  NotificationBell({this.userData});

  @override
  _NotificationBellState createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  @override
  Widget build(BuildContext context) {
    UserPreferences prefs = UserPreferences.from(widget.userData);

    return Material(
      color: Colors.transparent,
      child: Stack(
          children: [
            IconButton(
              icon: Icon(
                CustomIcons.bell,
                color: prefs.color_drawer_header,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<UserData>.value(
                  value: DatabaseService(uid: widget.userData.uid).userDocument,
                  child: NotificationScreen(),
                )));
              },
              splashRadius: 20,
              splashColor: prefs.color_splash,
              hoverColor: prefs.color_splash,
              highlightColor: prefs.color_splash,
              focusColor: prefs.color_splash,
            ),
            if(widget.userData.nbrOfUnseenNotifications > 0) Positioned(
              right: 5,
              top: 5,
              child: NotificationCounter(
                prefs: prefs,
                number: widget.userData.nbrOfUnseenNotifications,
              )
            )
          ]
      ),
    );
  }
}
