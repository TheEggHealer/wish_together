import 'package:flutter/material.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/dialog/custom_dialog.dart';
import 'package:wishtogether/models/user_preferences.dart';

class ConfirmationDialog extends StatefulWidget {

  final IconData icon;
  final String title;
  final String confirmationText;
  Function(bool) callback;
  UserPreferences prefs;

  ConfirmationDialog({this.icon, this.title, this.confirmationText, this.callback, this.prefs});

  @override
  _ConfirmationDialogState createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      prefs: widget.prefs,
      icon: widget.icon,
      title: widget.title,
      content: Column(
        children: [
          Text(
            widget.confirmationText,
            style: widget.prefs.text_style_bread,
          ),
          SizedBox(height: 20),
        ],
      ),
      acceptButton: 'Confirm',
      denyButton: 'Cancel',
      onAccept: () {
        widget.callback(true);
        Navigator.pop(context);
      },
      onDeny: () {
        widget.callback(false);
        Navigator.pop(context);
      },
    );
  }
}
