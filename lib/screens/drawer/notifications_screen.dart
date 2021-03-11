import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/ui/widgets/custom_scaffold.dart';
import 'package:wishtogether/ui/widgets/notification_widget.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  UserData user;

  @override
  Widget build(BuildContext context) {

    user = Provider.of<UserData>(context) ?? UserData.empty();
    UserPreferences prefs = UserPreferences.from(user);

    List<NotificationWidget> items = user.notifications.map((e) => NotificationWidget(e, user)).toList();

    return CustomScaffold(
      prefs: prefs,
      backButton: true,
      title: 'Notifications',
      body: Column(
        children: items,
      ),
    );
  }
}
