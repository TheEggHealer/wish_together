import 'package:flutter/material.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/dialog/custom_dialog.dart';

class ConfirmationDialog extends StatefulWidget {

  final IconData icon;
  final String title;
  final String confirmationText;
  Function(bool) callback;

  ConfirmationDialog({this.icon, this.title, this.confirmationText, this.callback});

  @override
  _ConfirmationDialogState createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      icon: widget.icon,
      title: widget.title,
      content: Column(
        children: [
          Text(
            widget.confirmationText,
            style: textstyle_comment,
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
