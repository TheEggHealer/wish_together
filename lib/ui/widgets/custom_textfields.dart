import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wishtogether/models/user_preferences.dart';

TextFormField textField({String helperText, TextStyle textStyle, Color textColor, Color borderColor, Color activeColor, Color errorColor, Icon icon, dynamic Function(String val) validator, Function(String val) onChanged, double borderRadius = 30, obscureText = false, bool email = false}) {
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
    keyboardType: email ? TextInputType.emailAddress : TextInputType.text,
    style: textStyle,
  );
}

TextFormField customTextField({UserPreferences prefs, String helperText, Function(String val) onChanged, TextEditingController controller, bool obscureText = false, bool multiline = false, Function(String val) validator, bool email = false}) {
  double padding = 12;

  return TextFormField(
    validator: validator,
    controller: controller,
    onChanged: onChanged,
    cursorColor: prefs.color_bread,
    obscureText: obscureText,
    style: prefs.text_style_bread,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.only(top: padding, bottom: padding, left: padding),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(padding*2)),borderSide: BorderSide(color: prefs.color_comment, width: 2)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(padding*2)),borderSide: BorderSide(color: prefs.color_primary, width: 2)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(padding*2)),borderSide: BorderSide(color: prefs.color_deny, width: 2)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(padding*2)),borderSide: BorderSide(color: prefs.color_deny, width: 2)),
      errorStyle: prefs.text_style_error,
      border: OutlineInputBorder(borderSide: BorderSide(color: prefs.color_card, width: 2)),
      hintText: helperText,
      hintStyle: prefs.text_style_bread,
      focusColor: prefs.color_primary,
      hoverColor: prefs.color_primary,
    ),
    keyboardType: email ? TextInputType.emailAddress : TextInputType.text,
    maxLines: multiline ? null : 1,
  );
}

TextFormField textFieldComment({String helperText, TextStyle textStyle, Color textColor, Color borderColor, Color activeColor, Color errorColor, Function(String val) onChanged, TextEditingController controller, double borderRadius = 30, obscureText = false, bool multiline = true}) {
  return TextFormField(
    controller: controller,
    onChanged: onChanged,
    cursorColor: textColor,
    obscureText: obscureText,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.only(top: 12, bottom: 12, left: 12),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(borderRadius)),borderSide: BorderSide(color: borderColor, width: 2)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(borderRadius)),borderSide: BorderSide(color: activeColor, width: 2)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(borderRadius)),borderSide: BorderSide(color: errorColor, width: 2)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(borderRadius)),borderSide: BorderSide(color: errorColor, width: 2)),
      errorStyle: TextStyle(
          fontFamily: 'RobotoLight',
          color: errorColor
      ),
      border: OutlineInputBorder(borderSide: BorderSide(color: borderColor, width: 2)),
      hintText: helperText,
      hintStyle: TextStyle(
          fontFamily: 'RobotoLight',
          fontSize: 14,
          color: borderColor
      ),
      focusColor: activeColor,
      hoverColor: activeColor,
    ),
    style: textStyle,
    maxLines: multiline ? null : 1,
  );
}