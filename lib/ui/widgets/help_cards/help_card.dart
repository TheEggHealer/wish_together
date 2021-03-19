import 'package:flutter/material.dart';
import 'package:wishtogether/models/user_preferences.dart';

class HelpCard extends StatelessWidget {

  UserPreferences prefs;
  List<Widget> content;

  HelpCard({this.prefs, this.content});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(16),
      child: Card(
        elevation: 6,
        color: prefs.color_card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              minWidth: size.width,
              minHeight: size.height * 0.5
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content ?? [],
            ),
          ),
        ),
      ),
    );
  }
}
