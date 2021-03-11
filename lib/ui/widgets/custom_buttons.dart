import 'dart:ui';
import 'package:flutter/cupertino.dart';
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


Widget customButton({String text, Color fillColor, Color textColor, Color splashColor, double width = 30, Function onTap, double borderRadius = 18.0}) {
  if(splashColor == null) splashColor = color_splash_light;

  Widget child;

  child = Text(
    text,
    style: TextStyle(
      fontFamily: 'OpenSans',
      color: textColor,
      fontSize: 16,
    ),
  );

  return SizedBox(
    height: 28,
    child: ButtonTheme(
      height: 28,
      minWidth: width,
      child: RaisedButton(
        elevation: 5,
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
      ),
    ),
  );
}

Widget signInButton({String text, Color borderColor, Color textColor, Color splashColor, Function onTap, double borderRadius = 22.0, Widget image}) {
  if(splashColor == null) splashColor = color_splash_light;

  Widget child, childImage;

  child = Text(
    text,
    style: TextStyle(
      fontFamily: 'OpenSans',
      color: textColor,
      fontSize: 16,
    ),
  );

  if(image != null) {
    childImage = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        image,
        SizedBox(width: 20,),
        child,
      ],
    );
  }

  return SizedBox(
    height: 44,
    child: ButtonTheme(
      height: 44,
      child: FlatButton(
        onPressed: onTap,
        child: image == null ? SizedBox(child: Center(child: child), width: double.infinity,) : childImage,
        color: Colors.transparent,
        highlightColor: splashColor,
        focusColor: splashColor,
        hoverColor: splashColor,
        textColor: color_text_light,
        splashColor: splashColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 2, color: borderColor),
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
      ),
    ),
  );
}

Widget circleButton({Icon icon, Color fillColor, Color splashColor, Function onTap}) {
  return SizedBox(
    width: 28,
    height: 28,
    child: RawMaterialButton(
      onPressed: onTap,
      elevation: 5,
      fillColor: fillColor,
      child: icon,
      shape: CircleBorder(),
      focusColor: splashColor,
      hoverColor: splashColor,
      highlightColor: splashColor,
      splashColor: splashColor,
    ),
  );
}
