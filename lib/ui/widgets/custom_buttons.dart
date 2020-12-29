import 'dart:ui';
import 'package:flutter/material.dart';

FlatButton button({String text, Color borderColor, Color textColor, Color splashColor, Function onTap, double borderRadius = 18.0, Image image}) {
  if(splashColor == null) splashColor = borderColor;

  Widget child;

  if(image == null) {
    child = Text(
      text,
      style: TextStyle(
        fontFamily: 'RobotoLight',
        fontWeight: FontWeight.w900,
        color: textColor,
        fontSize: 16,
      ),
    );
  }
  else {
    child = Stack(
      children: [
        Center(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'RobotoLight',
              fontWeight: FontWeight.w900,
              color: textColor,
              fontSize: 16,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: image,
        )
      ],
    );
  }

  return FlatButton(
    onPressed: onTap,
    child: child,
    color: Colors.transparent,
    highlightColor: splashColor,
    focusColor: splashColor,
    hoverColor: splashColor,
    textColor: textColor,
    splashColor: splashColor,
    shape: RoundedRectangleBorder(
      side: BorderSide(width: 1, color: borderColor),
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    ),
  );
}