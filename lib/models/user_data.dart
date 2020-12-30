import 'package:flutter/cupertino.dart';
import 'package:wishtogether/database/database_service.dart';
import 'package:wishtogether/constants.dart';

class UserData {

  DatabaseService dbs;

  Map<String, dynamic> raw;
  String uid;
  String name;
  bool firstTime = false;
  List<String> wishlistIds = [];
  Color userColor = Color(0xffa7f379);

  UserData({this.raw, this.uid}) {
    if(raw != null) {
      dbs = DatabaseService(uid: uid);
      _deconstructData();
    }
  }

  static from(String uid) async {
    DatabaseService dbs = DatabaseService(uid: uid);
    return UserData(uid: uid, raw: await dbs.getRaw(dbs.userData));
  }

  void _deconstructData() {
    debug('Trying to construct userData from $uid');
    firstTime = raw['first_time'];
    wishlistIds = List<String>.from(raw['wishlists']);
    name = raw['name'];
    debug('Name = $name');
  }

}