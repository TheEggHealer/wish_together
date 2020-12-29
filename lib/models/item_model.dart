import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/comment_model.dart';
import 'package:wishtogether/models/user_model.dart';

class ItemModel {

  Map<String, dynamic> raw;
  String itemName;
  List<CommentModel> comments;
  List<CommentModel> hiddenComments;
  int cost;
  List<UserModel> claimedUsers;

  ItemModel({this.raw}) {
    _deconstructData();
  }

  void _deconstructData() {
    debug('Deconstructing item from $raw');
    itemName = raw['item_name'];
    comments = (raw['comments'].map<CommentModel>((e) => CommentModel(raw: e))).toList();
    hiddenComments = (raw['hidden_comments'].map<CommentModel>((e) => CommentModel(raw: e))).toList();
    cost = raw['cost'];
  }

}