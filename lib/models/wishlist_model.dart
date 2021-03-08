import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/models/item_model.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_model.dart';

class WishlistModel {

  Map<String, dynamic> raw;

  String id = '';
  List<ItemModel> items = [];
  List<String> invitedUsers = [];
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

  WishlistModel.create({this.color, this.name, this.invitedUsers, this.type, this.dateCreated, this.wisherUID, this.parent}) {
    this.id = Uuid().v1();
  }

  void _deconstructData() {
    debug('wishlist');
    parent = raw['parent'];
    type = raw['type'];
    wisherUID = raw['wisher_uid'];
    wisherName = raw['wisher_name'];
    color = raw['color'];
    name = raw['name'];
    dateCreated = raw['date'];
    invitedUsers = List<String>.from(raw['invited_users']);
    items = (raw['items'].map<ItemModel>((e) => ItemModel(raw: e, wishlist: this, wisherUID: wisherUID))).toList();
  }

  get listCount {
    return type == 'solo' ? 1 : -1;
  }

  get userCount {
    return invitedUsers.length;
  }

  Future<void> uploadList() async {
    DatabaseService dbs = DatabaseService();

    List<Map<String, dynamic>> data = items.map((item) => {
      'claimed_users': item.claimedUsers,
      'comments': item.commentsAsData,
      'hidden_comments': item.hiddenCommentsAsData,
      'cost': item.cost,
      'item_name': item.itemName,
      'added_by_uid': item.addedByUID,
      'has_description': item.hasDescription,
    }).toList();

    await dbs.uploadData(dbs.wishlist, id, {
      'color': color,
      'creator': wisherUID,
      'date': dateCreated,
      'invited_users': invitedUsers,
      'items': data,
      'name': name,
      'parent': parent,
      'type': type,
      'wisher_name': wisherName,
      'wisher_uid': wisherUID,
    });
  }

  Future<void> deleteWishlist() async {
    DatabaseService dbs = DatabaseService();
    await dbs.deleteDocument(dbs.wishlist, id);
  }

}