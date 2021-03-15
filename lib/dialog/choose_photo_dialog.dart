import 'package:flutter/material.dart';
import 'package:wishtogether/dialog/custom_dialog.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/ui/custom_icons.dart';
import 'package:wishtogether/ui/widgets/custom_buttons.dart';

class ChoosePhotoDialog extends StatefulWidget {

  UserPreferences prefs;
  Function(Image) callback;

  ChoosePhotoDialog({this.prefs, this.callback});

  @override
  _ChoosePhotoDialogState createState() => _ChoosePhotoDialogState();
}

class _ChoosePhotoDialogState extends State<ChoosePhotoDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      prefs: widget.prefs,
      title: 'Choose photo',
      icon: CustomIcons.camera,
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              customButton(
                text: 'Camera',
                fillColor: widget.prefs.color_accept,
                textColor: widget.prefs.color_background,
                splashColor: widget.prefs.color_splash,
                onTap: () {},
              ),
              customButton(
                text: 'Gallery',
                fillColor: widget.prefs.color_accept,
                textColor: widget.prefs.color_background,
                splashColor: widget.prefs.color_splash,
                onTap: () {},
              )
            ],
          ),
          SizedBox(height: 80),
        ],
      ),
      acceptButton: 'Done',
      denyButton: 'Cancel',
      onAccept: () {},
      onDeny: () {},
    );
  }
}
