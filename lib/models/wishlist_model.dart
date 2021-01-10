import 'package:wishtogether/constants.dart';
import 'package:wishtogether/database/database_service.dart';
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
  String wisherUID = '';
  String wisherName = '';
  int color = 0;
  String name = '';
  String dateCreated = '';

  WishlistModel({this.raw, this.id}) {
    _deconstructData();
  }

  void _deconstructData() {
    parent = raw['parent'];
    type = raw['type'];
    wisherUID = raw['wisher_uid'];
    wisherName = raw['wisher_name'];
    color = raw['color'];
    name = raw['name'];
    dateCreated = raw['date'];
    invitedUsers = raw['invited_users'].map<UserModel>((e) => UserModel(uid: e)).toList();
    items = (raw['items'].map<ItemModel>((e) => ItemModel(raw: e, wishlist: this, wisherUID: wisherUID))).toList();
  }

  get listCount {
    return type == 'solo' ? 1 : -1;
  }

  get userCount {
    return invitedUsers.length;
  }

  void uploadList() async {
    DatabaseService dbs = DatabaseService();

    List<Map<String, dynamic>> data = items.map((item) => {
      'claimed_users': item.claimedUsers,
      'comments': item.commentsAsData,
      'hidden_comments': item.hiddenCommentsAsData,
      'cost': item.cost,
      'item_name': item.itemName,
    }).toList();

    await dbs.uploadData(dbs.wishlist, id, {
      'items': data
    });
  }

}