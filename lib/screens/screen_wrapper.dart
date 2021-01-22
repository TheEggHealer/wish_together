import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishtogether/services/auth_service.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_model.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/screens/authenticate/authenticate_screen.dart';
import 'package:wishtogether/screens/wishlists/home_screen.dart';
import 'package:wishtogether/constants.dart';

class ScreenWrapper extends StatelessWidget {

  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {

    UserModel user = Provider.of<UserModel>(context);
    UserData userData = Provider.of<UserData>(context);
    List<WishlistModel> wishlists = Provider.of<List<WishlistModel>>(context);

    debug('User state changed: ${user != null ? user.uid : "null"}');
    debug('UserData updated: ${userData != null ? userData.raw : "null"}');
    debug('Wishlists updated, number of wishlists: ${wishlists != null ? wishlists.length : "null"}');

    if(user == null) {
      //No user is signed in, show authenticate screen.
      return StartupScreen();
    } else {
      //User is signed in, show home screen.
      return HomeScreen();
    }
  }
}
