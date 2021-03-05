import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/notification_model.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/services/global_memory.dart';
import 'package:wishtogether/services/notification_service.dart';

class InvitationService {

  Future testInvitation(String mail) async {
    DatabaseService dbs = DatabaseService();
    String uid = await dbs.uidFromEmail(mail);
    debug('Mail: $mail, uid: $uid');
  }

  Future<bool> sendWishlistInvitation(String currentUserUID, String wishlistId, String identifier) async {
    UserData receiver = await getReceiver(identifier);
    debug('Got receiver');
    await uploadNotificationToFirebase(receiver, 'wi:${await getDate()}:$wishlistId*$currentUserUID:0');

    /* Send notification to receivers devices */
    if(receiver.settings['notif_wishlist_invitation']) {
      NotificationService ns = NotificationService();
      await ns.sendWishlistInviteNotificationTo(receiver.uid);
    }
    return true;
  }

  Future<bool> sendFriendRequestToEmail(String currentUserUID, String identifier) async {
    UserData receiver = await getReceiver(identifier);
    await uploadNotificationToFirebase(receiver, 'fr:${await getDate()}:$currentUserUID:0');

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

  Future<UserData> getReceiver(String identifier) async {
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

}