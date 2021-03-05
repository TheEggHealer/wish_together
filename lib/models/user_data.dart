import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:wishtogether/models/notification_model.dart';
import 'package:wishtogether/services/auth_service.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/constants.dart';

class UserData {

  DatabaseService dbs;

  Map<String, dynamic> raw = {};
  Map<String, bool> settings = {};
  List<NotificationModel> notifications;
  List<String> friends = [];
  String uid = 'no_user';
  String email = '';
  String name = '...';
  bool firstTime = false;
  List<String> wishlistIds = [];
  Color userColor = Color(0xff000000);
  ImageProvider profilePicture;
  String profilePictureURL = '';

  //Time the user was last downloaded from Firebase, if this is more than fetchInterval time ago, download again next time it's requested.
  DateTime timeFetched;
  Duration fetchInterval = Duration(minutes: 1);

  UserData({this.raw, this.uid}) {
    timeFetched = DateTime.now();
    if(raw != null) {
      dbs = DatabaseService(uid: uid);
      _deconstructData();
    }
  }

  static from(String uid) async {
    DatabaseService dbs = DatabaseService(uid: uid);
    return UserData(uid: uid, raw: await dbs.getRaw(dbs.userData));
  }

  static empty() {
    return UserData(uid: 'no_user');
  }

  void _deconstructData() {
    debug('Trying to construct userData from $uid');
    firstTime = raw['first_time'];
    wishlistIds = List<String>.from(raw['wishlists']);
    name = raw['name'];
    userColor = Color(raw['user_color']);
    profilePictureURL = raw['profile_picture'];
    profilePicture = NetworkImage(profilePictureURL);
    settings = Map<String, bool>.from(raw['settings']);
    notifications = raw['notifications'].map<NotificationModel>((raw) => NotificationModel(raw: raw)).toList();
    friends = List<String>.from(raw['friends'] ?? []);
    debug('Name = $name');
  }

  bool fetchAgain() {
    DateTime now = DateTime.now();
    if(now.difference(timeFetched).compareTo(fetchInterval) > 0) return true;
    return false;
  }

  Future<void> fetch() async {
    DatabaseService dbs = DatabaseService(uid: uid);
    this.raw = await dbs.getRaw(dbs.userData);
    _deconstructData();
    debug('UserData fetched for $uid');
  }

  Future<void> uploadData() async {
    DatabaseService dbs = DatabaseService(uid: uid);

    Map<String, dynamic> data = {
      'first_time': firstTime,
      'name': name,
      'profile_picture': profilePictureURL,
      'settings': settings,
      'user_color': userColor.value,
      'wishlists': wishlistIds,
      'notifications': notifications.map((e) => e.makeRaw()).toList(),
      'friends': friends,
    };

    await dbs.uploadData(dbs.userData, uid, data);
  }

  int get nbrOfUnseenNotifications {
    return notifications.where((notification) => !notification.seen).length;
  }


}