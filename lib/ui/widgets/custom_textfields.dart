import 'dart:ui';

import 'package:flutter/material.dart';

TextFormField textField({String helperText, TextStyle textStyle, Color textColor, Color borderColor, Color activeColor, Color errorColor, Icon icon, dynamic Function(String val) validator, Function(String val) onChanged, double borderRadius = 30, obscureText = false,}) {
  return TextFormField(
    validator: validator,
    onChanged: onChanged,
    cursorColor: textColor,
    obscureText: obscureText,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: 18),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(borderRadius)),borderSide: BorderSide(color: borderColor)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(borderRadius)),borderSide: BorderSide(color: activeColor)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(borderRadius)),borderSide: BorderSide(color: errorColor)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(borderRadius)),borderSide: BorderSide(color: errorColor)),
      errorStyle: TextStyle(
          fontFamily: 'RobotoLight',
          color: errorColor
      ),
      border: OutlineInputBorder(borderSide: BorderSide(color: borderColor)),
      hintText: helperText,
      hintStyle: TextStyle(
          fontFamily: 'RobotoLight',
          fontSize: 14,
          color: borderColor
      ),
      prefixIcon: icon,
      focusColor: activeColor,
      hoverColor: activeColor,
    ),
    style: textStyle,
  );
}