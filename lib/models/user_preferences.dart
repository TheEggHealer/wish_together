import 'package:flutter/material.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/ui/constant_colors.dart';

class UserPreferences {

  bool darkMode;

  UserPreferences({this.darkMode});

  UserPreferences.from(UserData userData) {
    if(userData == null) {
      darkMode = false;
      debug('UserData was null, setting to light mode...');
    } else {
      this.darkMode = userData.firstTime;
    }
  }

  ///Text Styles
  get text_style_header => TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 36,
      fontWeight: FontWeight.w700,
      color: color_primary
  );
  get text_style_sub_header => TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: color_sub_header
  );
  get text_style_bread => TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 14,
      color: color_bread
  );
  get text_style_wisher => TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 22,
      color: color_sub_header
  );
  get text_style_button => TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 16,
      color: color_background
  );
  get text_style_item_header => TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 20,
      color: color_sub_header
  );
  get text_style_item_sub_header => TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 18,
      color: color_bread
  );
  get text_style_tiny => TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 10,
    color: color_bread,
  );


  ///Colors
  get color_primary    => darkMode ? color_dark_primary : color_light_primary;
  get color_background => darkMode ? color_dark_background : color_light_background;
  get color_sub_header => darkMode ? color_dark_sub_header : color_light_sub_header;
  get color_bread      => darkMode ? color_dark_bread : color_light_bread;
  get color_card       => darkMode ? color_dark_card : color_light_card;
  get color_comment    => darkMode ? color_dark_comment : color_light_comment;
  get color_accept     => darkMode ? color_dark_accept : color_light_accept;
  get color_deny       => darkMode ? color_dark_deny : color_light_deny;
  get color_border     => darkMode ? color_dark_border : color_light_border;
  get color_icon       => darkMode ? color_dark_icon : color_light_icon;
  get color_divider    => darkMode ? color_dark_divider : color_light_divider;
  get color_splash     => darkMode ? color_dark_splash : color_light_splash;

}