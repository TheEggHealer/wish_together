import 'package:flutter/material.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/ui/custom_icons.dart';

class EmptyList extends StatelessWidget {

  final double verticalPadding;
  final UserPreferences prefs;
  final String header;
  final String instructions;
  final RichText richInstructions;

  EmptyList({this.prefs, this.header, this.verticalPadding, this.instructions, this.richInstructions});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: 60),
      child: Center(
        child: Column(
          children: [
            Icon(
              CustomIcons.empty,
              size: 110,
              color: prefs.color_drawer_logo,
            ),
            SizedBox(height: 20),
            Text(
              header,
              textAlign: TextAlign.center,
              style: prefs.text_style_soft_bold,
            ),
            SizedBox(height: 10),
            if(richInstructions == null) Text(
              instructions,
              textAlign: TextAlign.center,
              style: prefs.text_style_soft,
            ) else richInstructions,
          ],
        ),
      ),
    );
  }
}
