import 'package:flutter/material.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/ui/widgets/custom_buttons.dart';

class CustomDialog extends StatefulWidget {

  UserPreferences prefs;

  IconData icon;
  String title;
  Widget content;

  String acceptButton = '';
  String denyButton = '';
  Function onAccept;
  Function onDeny;

  CustomDialog({this.prefs, this.title, this.icon, this.content, this.acceptButton, this.denyButton, this.onAccept, this.onDeny});

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: widget.prefs.color_background,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    widget.icon,
                    color: widget.prefs.color_icon,
                    size: 30,
                  ),
                  SizedBox(width: 10,),
                  Text(
                    widget.title,
                    style: widget.prefs.text_style_sub_sub_header,
                  )
                ],
              ),
              SizedBox(height: 10),
              widget.content,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if(widget.denyButton != null) customButton(
                    text: widget.denyButton,
                    fillColor: widget.prefs.color_deny,
                    onTap: () {
                      widget.onDeny();
                    },
                    textColor: widget.prefs.color_background,
                  ),
                  SizedBox(width: 10),
                  if(widget.acceptButton != null) customButton(
                    text: widget.acceptButton,
                    fillColor: widget.prefs.color_accept,
                    onTap: () {
                      widget.onAccept();
                    },
                    textColor: widget.prefs.color_background,
                  ),
                ],
              )
            ]
          ),
        ),
      ),
    );
  }
}
