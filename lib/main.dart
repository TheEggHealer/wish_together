import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/database/auth_service.dart';
import 'package:wishtogether/database/database_service.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_model.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/screens/screen_wrapper.dart';
import 'package:wishtogether/screens/splash_screen.dart';

void main() {
  runApp(WishTogether());
}

class WishTogether extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          //Something went wrong
          return Container(color: Colors.red);
        } else if(snapshot.connectionState == ConnectionState.done) {
          //Connection is done, display either login screen or home screen
          return StreamProvider<UserModel>.value(
            value: AuthService().user,
            builder: (context, widget) {

              UserModel user = Provider.of<UserModel>(context);

              return userDataWrapper(user);
            },
          );
        }
        return SplashScreen();
      },
    );
  }

  Widget userDataWrapper(UserModel user) {
    DatabaseService dbs = DatabaseService(uid: user == null ? 'null' : user.uid);

    return StreamProvider<UserData>.value(
      value: dbs.userDocument,
      builder: (context, widget) {

        UserData userData = Provider.of<UserData>(context);

        return wishlistsWrapper(userData, dbs);

      }
    );
  }

  Widget wishlistsWrapper(UserData userData, DatabaseService dbs) {

    return StreamProvider<List<WishlistModel>>.value(
      value: dbs.wishlistDocs(userData == null ? [] : userData.wishlistIds),
      child: MaterialApp(
        home: ScreenWrapper(),
        theme: ThemeData(
          accentColor: color_text_light,
        ),
      ),
    );
  }

}
