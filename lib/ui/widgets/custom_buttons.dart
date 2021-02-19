import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wishtogether/constants.dart';

FlatButton button({String text, Color borderColor, Color textColor, Color splashColor, Function onTap, double borderRadius = 18.0, Image image}) {
  if(splashColor == null) splashColor = borderColor;

  Widget child;

  if(image == null) {
    child = Text(
      text,
      style: TextStyle(
        fontFamily: 'Quicksand',
        fontWeight: FontWeight.bold,
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
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
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

RaisedButton claimButton({String text, Color fillColor, Color textColor, Color splashColor, double width, Function onTap, double borderRadius = 18.0}) {
  if(splashColor == null) splashColor = color_splash_light;

  Widget child;

  child = SizedBox(
    width: width,
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.bold,
          color: textColor,
          fontSize: 16,
        ),
      ),
    ),
  );


  return RaisedButton(
    elevation: 10,
    onPressed: onTap,
    child: child,
    color: fillColor,
    highlightColor: splashColor,
    focusColor: splashColor,
    hoverColor: splashColor,
    textColor: color_text_light,
    splashColor: splashColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    ),
  );
}

FlatButton borderlessButton({String text, Color textColor, Color splashColor, Function onTap}) {
  Widget child;

  child = Text(
    text,
    style: TextStyle(
      fontFamily: 'Quicksand',
      fontWeight: FontWeight.bold,
      color: textColor,
      fontSize: 14,
    ),
  );

  return FlatButton(
    padding: EdgeInsets.symmetric(horizontal: 4),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    onPressed: onTap,
    child: child,
    color: Colors.transparent,
    highlightColor: splashColor,
    focusColor: splashColor,
    hoverColor: splashColor,
    textColor: textColor,
    splashColor: splashColor,
  );
}

