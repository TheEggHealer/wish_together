import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_model.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/services/global_memory.dart';
import 'package:wishtogether/ui/custom_icons.dart';

class NotificationModel {

  static const String PRE_FRIEND_REQUEST = 'fr';
  static const String PRE_WISHLIST_INVITE = 'wi';
  static const String PRE_ITEM_CHANGE = 'ic';
  static const String PRE_WISHLIST_CHANGE = 'wc';

  String raw;
  String prefix;
  DateTime date;
  String rawDate;
  String content;
  bool seen;

  String dateString;

  NotificationModel({this.raw}) {
    _deconstructData();
  }

  void _deconstructData() {
    List<String> data = raw.split(':');
    prefix = data[0];
    rawDate = data[1];
    date = DateFormat('HH.mm-dd/MM/yy').parse(rawDate);

    int daysSince = DateTime.now().difference(date).inDays;
    dateString = daysSince == 0 ? DateFormat('HH:mm').format(date) : daysSince == 1 ? 'Yesterday' : DateFormat('dd MMM').format(date);

    content = data[2];

    seen = data[3] == '1';
  }

  Future<void> onAccept(UserData currentUser) async {
    switch(prefix) {
      case PRE_FRIEND_REQUEST:
        UserData user = await GlobalMemory.getUserData(content, forceFetch: true);
        if(!currentUser.friends.contains(content)) {
          currentUser.friends.add(content);
        }
        if(!user.friends.contains(currentUser.uid)) {
          user.friends.add(currentUser.uid);
          await user.uploadData();
        }

        currentUser.notifications.remove(this);
        await currentUser.uploadData();
        break;
      case PRE_WISHLIST_INVITE:
        List<String> parts = content.split('*');
        WishlistModel wishlist = await DatabaseService().getWishlist(parts[0]);
        if(!wishlist.invitedUsers.contains(currentUser.uid)) {
          wishlist.invitedUsers.add(currentUser.uid);
          await wishlist.uploadList();
        }
        if(!currentUser.wishlistIds.contains(wishlist.id)) {
          currentUser.wishlistIds.add(wishlist.id);
        }

        currentUser.notifications.remove(this);
        await currentUser.uploadData();
        break;
      default: content = '';
    }
  }

  Future<void> onDeny(UserData currentUser) async {
    currentUser.notifications.remove(this);
    await currentUser.uploadData();
  }

  IconData get icon {
    switch(prefix) {
      case PRE_FRIEND_REQUEST: return CustomIcons.profile;
      case PRE_WISHLIST_INVITE: return CustomIcons.settings;
      default: return CustomIcons.help;
    }
  }

  String get title {
    switch(prefix) {
      case PRE_FRIEND_REQUEST: return 'Friend request';
      case PRE_WISHLIST_INVITE: return 'Wishlist invite';
      default: return 'No title'; break;
    }
  }

  bool get hasAcceptOption {
    switch(prefix) {
      case PRE_FRIEND_REQUEST: return true;
      case PRE_WISHLIST_INVITE: return true;
      default: return false; break;
    }
  }

  Future<String> get body async {
    switch(prefix) {
      case PRE_FRIEND_REQUEST:
        UserData user = await GlobalMemory.getUserData(content);
        return '${user.name} wants to be your friend!';
      case PRE_WISHLIST_INVITE:
        List<String> parts = content.split('*');
        UserData inviter = await GlobalMemory.getUserData(parts[1]);
        return '${inviter.name} has invited you to a wishlist!';
      default: content = '';
    }
  }

  String makeRaw() {
    return '$prefix:$rawDate:$content:${seen ? 1 : 0}';
  }

}