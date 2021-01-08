import 'package:intl/intl.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/user_data.dart';

class CommentModel {

  String raw;
  String content;
  String authorUID;
  String date;

  CommentModel({this.raw}) {
    _deconstructData();
  }

  CommentModel.from(String content, UserData user) {
    String date = DateFormat('HH:mm, MMMM d, yyyy').format(DateTime.now());
    this.raw = '${user.uid}*\\$date*\\$content';
  }

  void _deconstructData() {
    debug('Deconstructing comment from: $raw');
    List<String> data = raw.split('*\\');
    authorUID = data[0];
    date = data[1];
    content = data[2];
  }

  get author async {
    return await UserData.from(authorUID);
  }


}