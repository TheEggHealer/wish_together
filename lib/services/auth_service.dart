import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/models/user_model.dart';

class AuthService with ChangeNotifier {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final Map<String, dynamic> freshUserData = {
    'first_time': true,
  };

  // auth change user stream
  Stream<UserModel> get user {
    return _auth.authStateChanges().map(_toUserModel);
  }

  // create User object based on firebase user
  UserModel _toUserModel(User user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _toUserModel(user);
    } catch(e) {

      //Failed to login
      print(e.toString());
      return null;
    }
  }

  // sign in google
  Future signInGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult = await _auth.signInWithCredential(credential);
    final User user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);

    DatabaseService dbs = DatabaseService(uid: user.uid);
    if(!(await dbs.checkExist(dbs.userData))) {
      dbs.forceData(dbs.userData, dbs.uid, freshUserData);
      dbs.mapMail(user.email, user.uid);
    }

    //Update notification token, so notifications gets sent to this device
    await dbs.addToken(user.uid);

    return _toUserModel(currentUser);
  }

  Future signInApple() async {
    //final credential = await SignInWithApple.getAppleIDCredential(
    //  scopes: [
    //    AppleIDAuthorizationScopes.email,
    //    AppleIDAuthorizationScopes.fullName
    //  ],
    //);

    //TODO Don't forget setting the notification token on sign in.

    debug('======== Finish Apple sign in. Requires a paid Apple developer subscription! ========');
  }

  Future loginEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;

      //Update notification token, so notifications gets sent to this device
      DatabaseService dbs = DatabaseService();
      await dbs.addToken(user.uid);

      return _toUserModel(user);
    } catch(e) {
      print(e.toString());
      switch(e.code) {
        case 'ERROR_USER_NOT_FOUND' : return 'Invalid combination of email and password.';
        case 'ERROR_WRONG_PASSWORD' : return 'Invalid combination of email and password.';
        default: return 'Login failed.';
      }
    }
  }

  // register email & pass
  Future registerEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;

      //Create new document in firestore database
      DatabaseService dbs = DatabaseService(uid: user.uid);
      dbs.forceData(dbs.userData, dbs.uid, freshUserData);

      dbs.addToken(user.uid);
      dbs.mapMail(user.email, user.uid);

      return _toUserModel(user);
    } catch(e) {
      print(e.toString());
      switch(e.code) {
        case 'ERROR_EMAIL_ALREADY_IN_USE' : return 'Email is already taken.';
        default: return 'Register failed. Error: ${e.code}';
      }
    }
  }

  // sign out
  Future signOut() async {
    try {
      DatabaseService dbs = DatabaseService();
      await dbs.removeToken(_auth.currentUser.uid);
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future changeEmail(String newEmail) async {

  }

  String getEmail() {
    return _auth.currentUser != null ? _auth.currentUser.email : '';
  }

  getProfilePic() {
    return _auth.currentUser != null ? _auth.currentUser.photoURL : '';
  }

  Future updateEmail(String email, String password) async {
    try {
      EmailAuthCredential credential = EmailAuthProvider.credential(
          email: _auth.currentUser.email, password: password);
      await _auth.currentUser.reauthenticateWithCredential(credential);
      await _auth.currentUser.updateEmail(email).then((value) =>
          debug('Email updated!')
      );
    } catch (e) {
      switch(e.code) {
        case 'email-already-in-use' : return 'Email is already taken.';
        default: return 'Email-change failed. Error: ${e.code}';
      }
    }
  }

  Future updatePassword(String oldPassword, String newPassword) async {
    try {
      EmailAuthCredential credential = EmailAuthProvider.credential(
          email: _auth.currentUser.email, password: oldPassword);
      await _auth.currentUser.reauthenticateWithCredential(credential);
      await _auth.currentUser.updatePassword(newPassword).then((value) =>
          debug('Password updated!')
      );
    } catch (e) {
      switch(e.code) {
        case 'wrong-password' : return 'Current password is incorrect.';
        default: return 'Email-change failed. Error: ${e.code}';
      }
    }
  }

  bool get isSignedInWithGoogle {
    User user = _auth.currentUser;
    if(user != null) {
      if (user.providerData[0].providerId == 'google.com') return true;
    }
    return false;
  }

  Future deleteLoggedInUser(UserData currentUser) async {
    DatabaseService dbs = DatabaseService();

    //Leave wishlists
    for(int i = 0; i < currentUser.wishlistIds.length; i++) {
      WishlistModel wishlist = await dbs.getWishlist(currentUser.wishlistIds[i]);

      if(wishlist.creatorUID == currentUser.uid) {
        await wishlist.deleteWishlist();
      } else {
        wishlist.invitedUsers.remove(currentUser.uid);

        //Remove any sublist
        if (wishlist.type == 'group') {
          for (int j = 0; j < wishlist.wishlistStream.length; j++) {
            WishlistModel sub = await dbs.getWishlist(
                wishlist.wishlistStream[j]);
            if (sub.wisherUID == currentUser.uid) {
              wishlist.wishlistStream.removeAt(j);
              await sub.deleteWishlist();
            } else {
              sub.invitedUsers.remove(currentUser.uid);
              await sub.uploadList();
            }
          }
        }

        await wishlist.uploadList();
      }
    }

    dbs.removeMappingsFor(currentUser, _auth.currentUser.email);

    await currentUser.deleteUser();
    await _auth.currentUser.delete();
  }



//  signOutGoogle() async {
//    try {
//      return await _googleSignIn.signOut();
//    } catch(e) {
//      print(e.toString());
//      return null;
//    }
//  }
}