import 'dart:math';

import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/notification_model.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/services/global_memory.dart';
import 'package:wishtogether/services/notification_service.dart';

import 'database_service.dart';
import 'database_service.dart';

class InvitationService {

  final String friendCodeCharacters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

  Future testInvitation(String mail) async {
    DatabaseService dbs = DatabaseService();
    String uid = await dbs.uidFromEmail(mail);
    debug('Mail: $mail, uid: $uid');
  }

  Future<bool> sendWishlistInvitation(String currentUserUID, String wishlistId, String receiverUID) async {
    UserData receiver = await getReceiver(receiverUID);
    await uploadNotificationToFirebase(receiver, 'wi:${await getDate()}:$wishlistId*$currentUserUID:0');

    /* Send notification to receivers devices */
    if(receiver.settings['notif_wishlist_invitation']) {
      NotificationService ns = NotificationService();
      await ns.sendWishlistInviteNotificationTo(receiver.uid);
    }
    return true;
  }

  Future<bool> sendGroupWishlistInvitation(String currentUserUID, String wishlistId, String receiverUID) async {
    UserData receiver = await getReceiver(receiverUID);
    await uploadNotificationToFirebase(receiver, 'gwi:${await getDate()}:$wishlistId*$currentUserUID:1');

    /* Send notification to receivers devices */
    if(receiver.settings['notif_wishlist_invitation']) {
      NotificationService ns = NotificationService();
      await ns.sendWishlistInviteNotificationTo(receiver.uid);
    }
    return true;
  }

  Future<bool> sendFriendRequest(String currentUserUID, String receiverUID) async {
    UserData receiver = await getReceiver(receiverUID);
    await uploadNotificationToFirebase(receiver, 'fr:${await getDate()}:$currentUserUID:1');

    /* Send notification to receivers devices */
    if(receiver.settings['notif_friend_request']) {
      NotificationService ns = NotificationService();
      await ns.sendFriendRequestNotificationTo(receiver.uid);
    }
    return true;
  }

  Future uploadNotificationToFirebase(UserData receiver, String content) async {
    NotificationModel notification = NotificationModel(raw: content);
    receiver.notifications.add(notification);
    await receiver.uploadData();
  }

  Future<UserData> getReceiver(String identifier) async { //TODO This will only take in uids, since i've moved the email/friendCode check to DatabaseService.
    DatabaseService dbs = DatabaseService();
    String receiverUID = _isEmail(identifier) ? await dbs.uidFromEmail(identifier) : identifier; //TODO Fix for friend code
    UserData receiver = await GlobalMemory.getUserData(receiverUID, forceFetch: true);
    return receiver;
  }

  Future<String> getDate() async {
    return DateFormat('HH.mm-dd/MM/yy').format(await NTP.now());
  }

  bool _isEmail(String identifier) {
    return identifier.contains('@') && identifier.contains('.');
  }

  bool _isFriendCode(String identifier) {
    return identifier.length == 6 && !identifier.contains('@');
  }

  Future<String> createUniqueFriendCode() async {
    DatabaseService dbs = DatabaseService();
    String friendCode = newFriendCode();
    bool exists = (await dbs.uidFromFriendCode(friendCode)).isNotEmpty;
    int tries = 0; //TODO Maybe send a message to me if this number ever gets high (> 2) for anyone. Indicates that something is wrong or that friend codes are running out.

    while(exists) {
      friendCode = newFriendCode();
      exists = (await dbs.uidFromFriendCode(friendCode)).isNotEmpty;
      tries++;
    }

    return friendCode;
  }

  String newFriendCode() {
    Random random = Random();
    String friendCode = '      '; //6 spaces
    for(int i = 0; i < friendCode.length; i++) {
      int charIndex = random.nextInt(friendCodeCharacters.length);
      String char = friendCodeCharacters.substring(charIndex, charIndex + 1);
      friendCode = friendCode.replaceFirst(' ', char);
    }
    return friendCode;
  }

}