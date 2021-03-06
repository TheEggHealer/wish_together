import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_model.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/services/global_memory.dart';
import 'package:wishtogether/ui/custom_icons.dart';

import '../services/database_service.dart';

class NotificationModel {

  static const String PRE_FRIEND_REQUEST = 'fr';
  static const String PRE_WISHLIST_INVITE = 'wi';
  static const String PRE_GROUP_WISHLIST_INVITE = 'gwi';
  static const String PRE_ITEM_CHANGE = 'ic';
  static const String PRE_CLAIMED_ITEM_CHANGE = 'cic';
  static const String PRE_WISHLIST_CHANGE = 'wc';

  String raw;
  String prefix;
  DateTime date;
  String rawDate;
  String content;
  bool inNotificationList;

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

    inNotificationList = data[3] == '1';
  }

  Future<void> onAccept(UserData currentUser) async {
    switch(prefix) {
      case PRE_FRIEND_REQUEST:
        UserData user = await GlobalMemory.getUserData(content, forceFetch: true);

        if(user == null) {
          currentUser.notifications.remove(this);
          await currentUser.uploadData();
          break;
        }

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

        if(wishlist == null) {
          currentUser.notifications.remove(this);
          await currentUser.uploadData();
          break;
        }

        if(!wishlist.invitedUsers.contains(currentUser.uid)) {
          wishlist.invitedUsers.add(currentUser.uid);
          await wishlist.uploadList();
        }
        if(!currentUser.wishlistIds.contains(wishlist.id)) {
          currentUser.wishlistIds.add(wishlist.id);
        }

        currentUser.notifications.remove(this);
        await currentUser.uploadData();
        await GlobalMemory.getUserData(currentUser.uid, forceFetch: true);
        break;
      case PRE_GROUP_WISHLIST_INVITE:
        DatabaseService dbs = DatabaseService();
        List<String> parts = content.split('*');
        WishlistModel groupWishlist = await dbs.getWishlist(parts[0]);

        if(groupWishlist == null) {
          currentUser.notifications.remove(this);
          await currentUser.uploadData();
          break;
        }

        if(!currentUser.wishlistIds.contains(groupWishlist.id)) {
          //Invite currentUser to all other lists in group
          for(int i = 0; i < groupWishlist.wishlistStream.length; i++) {
            WishlistModel m = await dbs.getWishlist(groupWishlist.wishlistStream[i]);
            m.invitedUsers = groupWishlist.invitedUsers;
            await m.uploadList();
          }

          currentUser.notifications.remove(this);
          currentUser.wishlistIds.add(groupWishlist.id);
          await currentUser.uploadData();
          await GlobalMemory.getUserData(currentUser.uid, forceFetch: true);
        }
        break;
      default: content = '';
    }
  }

  Future<void> onDeny(UserData currentUser) async {
    switch(prefix) {
      case PRE_WISHLIST_INVITE:
      case PRE_GROUP_WISHLIST_INVITE:
        List<String> parts = content.split('*');
        WishlistModel wishlist = await DatabaseService().getWishlist(parts[0]);

        if(wishlist == null) {
          currentUser.notifications.remove(this);
          await currentUser.uploadData();
          break;
        }

        if(wishlist.invitedUsers.contains(currentUser.uid)) wishlist.invitedUsers.remove(currentUser.uid);
        currentUser.notifications.remove(this);
        await currentUser.uploadData();
        await wishlist.uploadList();
        break;
      default:
        currentUser.notifications.remove(this);
        await currentUser.uploadData();
        break;
    }
  }

  IconData get icon {
    switch(prefix) {
      case PRE_FRIEND_REQUEST: return CustomIcons.profile;
      case PRE_WISHLIST_INVITE: return CustomIcons.invite;
      case PRE_GROUP_WISHLIST_INVITE: return CustomIcons.invite;
      default: return CustomIcons.help;
    }
  }

  String get title {
    switch(prefix) {
      case PRE_FRIEND_REQUEST: return 'Friend request';
      case PRE_WISHLIST_INVITE: return 'Wishlist invite';
      case PRE_GROUP_WISHLIST_INVITE: return 'Group wishlist invite';
      default: return 'No title'; break;
    }
  }

  bool get hasAcceptOption {
    switch(prefix) {
      case PRE_FRIEND_REQUEST: return true;
      case PRE_WISHLIST_INVITE: return true;
      case PRE_GROUP_WISHLIST_INVITE: return true;
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
      case PRE_GROUP_WISHLIST_INVITE:
        List<String> parts = content.split('*');
        UserData inviter = await GlobalMemory.getUserData(parts[1]);
        return '${inviter.name} has invited you to join a group wishlist!';
      default: content = '';
    }
  }

  String makeRaw() {
    return '$prefix:$rawDate:$content:${inNotificationList ? 1 : 0}';
  }

}