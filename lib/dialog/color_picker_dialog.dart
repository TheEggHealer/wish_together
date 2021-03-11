import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/dialog/custom_dialog.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/ui/custom_icons.dart';
import 'package:wishtogether/ui/widgets/custom_buttons.dart';

class ColorPickerDialog extends StatefulWidget {

  Color currentColor;
  Function onDone;
  UserPreferences prefs;

  ColorPickerDialog({this.prefs, this.currentColor, this.onDone});

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      prefs: widget.prefs,
      title: 'Pick a color',
      icon: CustomIcons.color_picker,
      content: ColorPicker(
        enableAlpha: false,
        labelTextStyle: widget.prefs.text_style_bread,
        pickerColor: widget.currentColor,
        onColorChanged: (color) {
          setState(() {
            widget.currentColor = color;
          });
        },
        showLabel: false,
        pickerAreaHeightPercent: 0.8,
      ),
      acceptButton: 'Done',
      denyButton: 'Cancel',
      onAccept: () {
        widget.onDone(widget.currentColor);
        Navigator.pop(context);
      },
      onDeny: () {
        Navigator.pop(context);
      }
    );
  }
}
