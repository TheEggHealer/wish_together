import 'package:flutter/material.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/ui/color_correction.dart';
import 'package:wishtogether/ui/constant_colors.dart';

import '../ui/constant_colors.dart';

class UserPreferences {

  bool darkMode;

  UserPreferences({this.darkMode});

  UserPreferences.from(UserData userData) {
    if(userData == null) {
      darkMode = false;
      debug('UserData was null, setting to light mode...');
    } else {
      this.darkMode = userData.settings['dark_mode'] ?? false;
    }
  }

  ///Text Styles
  get text_style_wish_together => TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 28,
      color: color_background
  );
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
  get text_style_sub_sub_header => TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 16,
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
  get text_style_drawer_header => TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 20,
    color: color_drawer_header,
  );
  get text_style_drawer_list => TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 16,
    color: color_sub_header,
  );
  get text_style_error => TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 14,
    color: color_deny,
  );
  get text_style_settings => TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 16,
    color: color_bread,
  );
  get text_style_settings_warning => TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 16,
    color: color_deny,
  );
  get text_style_notification => TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 10,
    color: color_light_background,
  );


  ///Colors
  get color_primary       => darkMode ? color_dark_primary       : color_light_primary;
  get color_background    => darkMode ? color_dark_background    : color_light_background;
  get color_sub_header    => darkMode ? color_dark_sub_header    : color_light_sub_header;
  get color_bread         => darkMode ? color_dark_bread         : color_light_bread;
  get color_card          => darkMode ? color_dark_card          : color_light_card;
  get color_comment       => darkMode ? color_dark_comment       : color_light_comment;
  get color_accept        => darkMode ? color_dark_accept        : color_light_accept;
  get color_deny          => darkMode ? color_dark_deny          : color_light_deny;
  get color_border        => darkMode ? color_dark_border        : color_light_border;
  get color_icon          => darkMode ? color_dark_icon          : color_light_icon;
  get color_divider       => darkMode ? color_dark_divider       : color_light_divider;
  get color_splash        => darkMode ? color_dark_splash        : color_light_splash;
  get color_drawer_top    => darkMode ? color_dark_drawer_top    : color_light_drawer_top;
  get color_drawer_header => darkMode ? color_dark_drawer_header : color_light_drawer_header;
  get color_drawer_logo   => darkMode ? color_dark_drawer_logo   : color_light_drawer_logo;
  get color_spinner       => darkMode ? color_dark_spinner       : color_light_spinner;
  get color_switch_track  => darkMode ? color_dark_switch_track  : color_light_switch_track;
  get color_shadow        => darkMode ? color_dark_shadow        : color_light_shadow;
  get color_notification  => darkMode ? color_dark_notification  : color_light_notification;


  ///Special text styles and colors
  TextStyle text_style_wishlist_card(Color backgroundColor) {
    return TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 16,
      color: color_wishlist_card(backgroundColor),
    );
  }

  TextStyle text_style_wishlist_tiny(Color backgroundColor) {
    return TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 10,
      color: color_wishlist_card(backgroundColor),
    );
  }

  Color color_wishlist_card(Color backgroundColor) {
    bool useDark = ColorCorrection.useDarkColor(backgroundColor);
    return useDark ? color_light_sub_header : color_dark_sub_header;
  }

}