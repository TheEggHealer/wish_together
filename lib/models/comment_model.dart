import 'package:wishtogether/constants.dart';

class CommentModel {

  String raw;

  CommentModel({this.raw}) {
    _deconstructData();
  }

  void _deconstructData() {
    debug('Deconstructing comment from: $raw');
  }

}