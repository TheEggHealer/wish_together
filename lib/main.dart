import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/services/ad_service.dart';
import 'package:wishtogether/services/auth_service.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_model.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/screens/screen_wrapper.dart';
import 'package:wishtogether/screens/splash_screen.dart';

void main() {
  runApp(WishTogether());
}

class WishTogether extends StatelessWidget {

  Future<FirebaseApp> initialize() async {
    await FirebaseAdMob.instance.initialize(appId: AdService.appId);
    return await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    return FutureBuilder(
      future: initialize(),
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          //Something went wrong
          debug(snapshot.error);
          return Container(color: Colors.red);
        } else if(snapshot.connectionState == ConnectionState.done) {
          //Connection is done, display either login screen or home screen
          return Container(
            color: color_background,
            padding: EdgeInsets.only(bottom: 60),
            child: StreamProvider<UserModel>.value(
              value: AuthService().user,
              builder: (context, widget) {
                UserModel user = Provider.of<UserModel>(context);

                return userDataWrapper(user, context);
              },
            )
          );
        }
        return SplashScreen();
      },
    );
  }

  Widget userDataWrapper(UserModel user, BuildContext context) {
    DatabaseService dbs = DatabaseService(uid: user == null ? 'null' : user.uid);

    return StreamProvider<UserData>.value(
      value: dbs.userDocument,
      builder: (context, widget) {

        UserData userData = Provider.of<UserData>(context);

        return wishlistsWrapper(userData, dbs, context);

      }
    );
  }

  Widget wishlistsWrapper(UserData userData, DatabaseService dbs, BuildContext context) {

    return StreamProvider<List<WishlistModel>>.value(
      value: dbs.wishlistDocs(userData == null ? [] : userData.wishlistIds),
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if(!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            currentFocus.focusedChild.unfocus();
          }
        },
        child: MaterialApp(
          home: ScreenWrapper(),
          theme: ThemeData(
            accentColor: color_text_light,
          ),
        ),
      ),
    );
  }

}
