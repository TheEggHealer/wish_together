import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

const C_startup_scaffold_height = 0.40;
const C_startup_scaffold_diff = 0.25;

const Color color_primary = Color(0xffE8C364);
const Color color_primary_gradient_end = Color(0xffF7DE9E);
const Color color_background = Color(0xffF1F1F1);
const Color color_comment_background = Color(0x11000000);
const Color color_card_background = Color(0xffffffff);
const Color color_card_disabled = Color(0xfff4f4f4);

const Color color_text_light = Color(0xffffffff);
const Color color_text_light_sub = Color(0xaaffffff);
const Color color_text_dark = Color(0xff535353);
const Color color_text_dark_sub = Color(0xff999999);
const Color color_text_error = Color(0xffff5555);
const Color color_text_comment = Color(0xff404040);

const Color color_claim_green = Color(0xff8CD373);

const Color color_divider_light = color_text_light;
const Color color_divider_dark = Color(0xa0535353);

const Color color_loading_spinner = Color(0x22000000);
const Color color_splash_light = Color(0x55ffffff);
const Color color_splash_dark = Color(0x10000000);

const Color color_card_date = Color(0xaaffffff);

LinearGradient startup_scaffold_gradient = LinearGradient(
  begin: Alignment(0, 0),
  end: Alignment(0.2, 0.8),
  colors: [
    color_primary,
    color_primary_gradient_end,
  ]
);

const TextStyle textstyle_comment = TextStyle(
  fontFamily: 'Quicksand',
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: color_text_comment,
);

const TextStyle textstyle_comment_author = TextStyle(
  fontFamily: 'Quicksand',
  fontSize: 12,
  fontWeight: FontWeight.bold,
  color: color_text_dark_sub,
);

const TextStyle textstyle_card_header_light = TextStyle(
  fontFamily: 'Quicksand',
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: color_text_light,
);

const TextStyle textstyle_card_header_dark = TextStyle(
  fontFamily: 'Quicksand',
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: color_text_dark,
);

const TextStyle textstyle_card_dark_sub = TextStyle(
  fontFamily: 'Quicksand',
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: color_text_dark_sub,
);

const TextStyle textstyle_card_date_light = TextStyle(
  fontFamily: 'Quicksand',
  fontSize: 12,
  fontWeight: FontWeight.bold,
  color: color_card_date,
);

const TextStyle textstyle_appbar = TextStyle(
  fontFamily: 'RobotoLight',
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: color_text_light,
);

const TextStyle textstyle_title = TextStyle(
  fontFamily: 'Quicksand',
  fontSize: 30,
  fontWeight: FontWeight.bold,
  color: color_text_light,
);

const TextStyle textstyle_drawer_header = TextStyle(
  fontFamily: 'RobotoLight',
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: color_text_light,
);

const TextStyle textstyle_header = TextStyle(
  fontFamily: 'Quicksand',
  fontSize: 23,
  fontWeight: FontWeight.bold,
  color: color_text_dark,
);

const TextStyle textstyle_subheader = TextStyle(
  fontFamily: 'Quicksand',
  fontSize: 18,
  color: color_text_dark_sub,
);

const TextStyle textstyle_profile_name = TextStyle(
  fontFamily: 'Quicksand',
  fontSize: 30,
  fontWeight: FontWeight.bold,
  color: color_text_dark_sub,
);

const TextStyle textstyle_dev = TextStyle(
  fontFamily: 'RobotoLight',
  fontSize: 12,
  color: color_text_dark_sub,
);

const TextStyle textstyle_list_title = TextStyle(
  fontFamily: 'RobotoLight',
  fontSize: 14,
  fontWeight: FontWeight.bold,
  color: color_text_dark,
);

const TextStyle textstyle_notification_body = TextStyle(
  fontFamily: 'RobotoLight',
  fontSize: 14,
  color: color_text_dark,
);

const TextStyle textstyle_list_title_warning = TextStyle(
  fontFamily: 'RobotoLight',
  fontSize: 14,
  fontWeight: FontWeight.bold,
  color: color_text_error,
);


debug(Object obj) {
  DateTime date = DateTime.now();
  DateFormat format = DateFormat('yyyy-mm-dd hh:mm:ss');
  print('[Wish Together] [${format.format(date)}] $obj');
}
