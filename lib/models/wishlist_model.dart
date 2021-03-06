import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/models/item_model.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_model.dart';
import 'package:wishtogether/services/image_service.dart';

class WishlistModel {

  Map<String, dynamic> raw;

  //General
  String id = '';
  List<String> invitedUsers = [];
  String type = '';
  String creatorUID = '';
  int color = 0;
  String name = '';
  String dateCreated = '';

  //Solo
  List<ItemModel> items = [];
  String parent = '';
  String wisherUID = '';
  String wisherName = '';
  bool isSubList = false;

  //Group
  List<String> wishlistStream = [];

  WishlistModel({this.raw, this.id}) {
    _deconstructData();
  }

  WishlistModel.create({this.color, this.name, this.invitedUsers, this.type, this.dateCreated, this.wisherUID, this.creatorUID, this.parent, this.isSubList, this.wishlistStream}) {
    this.id = Uuid().v1();
  }

  void _deconstructData() {
    color = raw['color'];
    name = raw['name'];
    dateCreated = raw['date'];
    invitedUsers = List<String>.from(raw['invited_users']);
    type = raw['type'];
    creatorUID = raw['creator'];

    switch(type) {
      case 'solo': _deconstructSolo(); break;
      case 'group': _deconstructGroup(); break;
      default: debug('Type not defined: $type'); break;
    }
  }

  void _deconstructSolo() {
    parent = raw['parent'];
    wisherUID = raw['wisher_uid'];
    wisherName = raw['wisher_name'];
    items = (raw['items'].map<ItemModel>((e) => ItemModel(raw: e, wishlist: this, wisherUID: wisherUID))).toList();
    isSubList = raw['is_sub_list'];
  }

  void _deconstructGroup() {
    wishlistStream = List<String>.from(raw['wishlist_stream']);
  }

  int itemCount(isWisher) {
    return type == 'solo' ? items.where((item) => !isWisher ? true : !item.hideFromWisher).length : 0;
  }

  get userCount {
    return invitedUsers.length;
  }

  Future<void> uploadList() async {
    DatabaseService dbs = DatabaseService();

    List<Map<String, dynamic>> data = items.map((item) => {
      'id': item.id,
      'claimed_users': item.claimedUsers,
      'comments': item.commentsAsData,
      'hidden_comments': item.hiddenCommentsAsData,
      'cost': item.cost,
      'item_name': item.itemName,
      'added_by_uid': item.addedByUID,
      'description': item.description,
      'photo_url': item.photoURL,
      'hide_from_wisher': item.hideFromWisher,
    }).toList();

    await dbs.uploadData(dbs.wishlist, id, {
      'color': color,
      'creator': creatorUID,
      'date': dateCreated,
      'invited_users': invitedUsers,
      'items': data,
      'name': name,
      'parent': parent,
      'type': type,
      'wisher_name': wisherName,
      'wisher_uid': wisherUID,
      'is_sub_list': isSubList,
      'wishlist_stream': wishlistStream
    });
  }

  Future<void> deleteWishlist() async {
    DatabaseService dbs = DatabaseService();
    ImageService imageService = ImageService();

    if(type == 'solo') {
      //Delete images
      for(int i = 0; i < items.length; i++) {
        await imageService.deleteImage(items[i].photoURL);
      }

      await dbs.deleteDocument(dbs.wishlist, id);
    } else {
      for(int i = 0; i < wishlistStream.length; i++) {
        WishlistModel model = await dbs.getWishlist(wishlistStream[i]);
        await model.deleteWishlist();
      }
      await dbs.deleteDocument(dbs.wishlist, id);
    }

  }

}