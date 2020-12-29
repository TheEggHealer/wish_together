import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/item_model.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_model.dart';

class WishlistModel {

  Map<String, dynamic> raw;

  String id = '';
  List<ItemModel> items = [];
  List<UserModel> invitedUsers = [];
  String parent = '';
  String type = '';
  UserData wisher;
  String wisherUID = '';
  int color = 0;
  String name = '';
  String dateCreated = '';

  WishlistModel({this.raw, this.id}) {
    _deconstructData();
  }

  void _deconstructData() async {
    items = (raw['items'].map<ItemModel>((e) => ItemModel(raw: e))).toList();
    parent = raw['parent'];
    type = raw['type'];
    wisherUID = raw['wisher_uid'];
    wisher = await UserData.from(wisherUID);
    debug(wisher);
    color = raw['color'];
    name = raw['name'];
    dateCreated = raw['date'];
    invitedUsers = raw['invited_users'].map<UserModel>((e) => UserModel(uid: e)).toList();
  }

  get listCount {
    return type == 'solo' ? 1 : -1;
  }

  get userCount {
    return invitedUsers.length;
  }

}