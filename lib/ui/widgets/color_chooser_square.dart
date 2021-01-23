import 'package:flutter/material.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/ui/color_correction.dart';

class ColorChooserSquare extends StatefulWidget {

  final Color color;
  final double radius;
  final double size;
  final Function onTap;

  ColorChooserSquare({this.color, this.size, this.radius, this.onTap});

  @override
  _ColorChooserSquareState createState() => _ColorChooserSquareState();
}

class _ColorChooserSquareState extends State<ColorChooserSquare> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.radius),
        ),
        color: widget.color,
        child: InkWell(
          borderRadius: BorderRadius.circular(widget.radius),
          onTap: () {
            debug('Tapping');
            widget.onTap();
          },
          hoverColor: color_splash_light,
          focusColor: color_splash_light,
          highlightColor: color_splash_light,
          splashColor: color_splash_light,
          child: Container(
            width: widget.size,
            height: widget.size,
            child: Center(
              child: Icon(
                Icons.colorize,
                color: ColorCorrection.useDarkColor(widget.color) ? color_text_dark : color_text_light,
              ),
            ),
          ),
        ),
      )
    );
  }
}

