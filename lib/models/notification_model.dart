import 'package:intl/intl.dart';
import 'package:wishtogether/constants.dart';

class NotificationModel {

  static final String PRE_FRIEND_REQUEST = 'fr';
  static final String PRE_WISHLIST_INVITE = 'wi';
  static final String PRE_ITEM_CHANGE = 'ic';
  static final String PRE_WISHLIST_CHANGE = 'wc';

  String raw;
  String prefix;
  DateTime date;
  String content;
  bool seen;

  String dateString;

  NotificationModel({this.raw}) {
    _deconstructData();
  }

  void _deconstructData() {
    List<String> data = raw.split(':');
    prefix = data[0];
    date = DateFormat('HH.mm-dd/MM/yy').parse(data[1]);

    int daysSince = DateTime.now().difference(date).inDays;
    dateString = daysSince == 0 ? DateFormat('HH:mm').format(date) : daysSince == 1 ? 'Yesterday' : DateFormat('dd MMM').format(date);

    content = data[2];

    seen = data[3] == '1';
  }

}