import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/user_data.dart';
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

    List<NotificationWidget> items = user.notifications.map((e) => NotificationWidget(e, user)).toList();

    return Scaffold(
      backgroundColor: color_background,
      appBar: AppBar(
        backgroundColor: color_primary,
        elevation: 10,
        title: Row(
          children: [
            Text(
                'Notifications'
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: items,
        ),
      ),
    );
  }
}
