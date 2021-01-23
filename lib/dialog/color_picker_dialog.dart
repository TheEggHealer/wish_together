import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/ui/widgets/custom_buttons.dart';

class ColorPickerDialog extends StatefulWidget {

  Color currentColor;
  Function onDone;

  ColorPickerDialog({this.currentColor, this.onDone});

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Pick a color'),
      content: SingleChildScrollView(
        child: ColorPicker(
          enableAlpha: false,
          pickerColor: widget.currentColor,
          onColorChanged: (color) {
            setState(() {
              widget.currentColor = color;
            });
          },
          showLabel: true,
          pickerAreaHeightPercent: 0.8,
        ),
      ),
      actions: [
        claimButton(
          fillColor: color_claim_green,
          text: 'Done',
          splashColor: color_splash_light,
          textColor: color_text_light,
          onTap: () {
            widget.onDone(widget.currentColor);
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
