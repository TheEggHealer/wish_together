import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/services/global_memory.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/wishlist_model.dart';

class CommentModel {

  String raw;
  String content;
  String authorUID;
  DateTime date;

  CommentModel({this.raw}) {
    _deconstructData();
  }

  static Future<CommentModel> from(String content, UserData user) async {
    String date = DateFormat('HH:mm, MMMM d, yyyy').format(await NTP.now());
    String raw = '${user.uid}*\\$date*\\$content';
    CommentModel model = CommentModel(raw: raw);
    return model;
  }

  void _deconstructData() {
    //debug('Deconstructing comment from: $raw');
    List<String> data = raw.split('*\\');
    authorUID = data[0];
    date = DateFormat('HH:mm, MMMM d, yyyy').parse(data[1]);
    content = data[2];
  }

  String get timeString {
    return DateFormat('HH:mm').format(date);
  }

  String get dateString {
    return DateFormat('MMM d').format(date);
  }

  Future<UserData> author(WishlistModel wishlist) async {
    return await GlobalMemory.getUserData(authorUID);
  }


}