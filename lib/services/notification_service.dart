import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/services/database_service.dart';

class NotificationService {

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String _token = '';

  Future printToken() async {
    debug('Token: ${await messaging.getToken()}');
  }

  Future<String> getToken() async {
    if(_token.isNotEmpty) return _token;
    else {
      _token = await messaging.getToken();
      return _token;
    }
  }

  Future sendNotificationTo(String uid) async {
    DatabaseService dbs = DatabaseService();
    List<String> tokens = await dbs.getTokensFor(uid);

    if(tokens.isNotEmpty) {
      FirebaseFunctions.instance.httpsCallable('sendNotification').call({
        'tokens': tokens,
        'title': 'New friend request!',
        'body': 'Someone wants to add you as a friend.'
      });
    }
  }

  Future<void> sendFriendRequestNotificationTo(String uid) async {
    DatabaseService dbs = DatabaseService();
    List<String> tokens = await dbs.getTokensFor(uid);

    if(tokens.isNotEmpty) {
      FirebaseFunctions.instance.httpsCallable('sendNotification').call({
        'tokens': tokens,
        'title': 'New friend request!',
        'body': 'Someone wants to add you as a friend.'
      });
    }
  }

  Future<void> sendWishlistInviteNotificationTo(String uid) async {
    DatabaseService dbs = DatabaseService();
    List<String> tokens = await dbs.getTokensFor(uid);

    if(tokens.isNotEmpty) {
      FirebaseFunctions.instance.httpsCallable('sendNotification').call({
        'tokens': tokens,
        'title': 'New wishlist invitation!',
        'body': 'You have been invited to join a wishlist.'
      });
    }
  }

}