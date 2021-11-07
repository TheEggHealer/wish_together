import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/screens/authenticate/new_user_screen.dart';
import 'package:wishtogether/services/ad_service.dart';
import 'package:wishtogether/services/auth_service.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_model.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/screens/screen_wrapper.dart';
import 'package:wishtogether/screens/splash_screen.dart';
import 'package:wishtogether/ui/constant_colors.dart';

import 'models/user_preferences.dart';
import 'models/user_preferences.dart';

void main() {
  runApp(WishTogether());
}

class WishTogether extends StatelessWidget {

  Future<FirebaseApp> initialize() async {
    FirebaseApp app = await Firebase.initializeApp();
    //await FirebaseAdMob.instance.initialize(appId: AdService.appId);

    if(AdService.hasAds) createAds();

    return app;
  }

  Future createAds() async {
    //AdService.buildTestAd()..load()..show();
  }

  @override
  Widget build(BuildContext context) {
    //final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    return FutureBuilder(
      future: initialize(),
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          //Something went wrong
          debug(snapshot.error);
          return Container(color: color_dark_background);
        } else if(snapshot.connectionState == ConnectionState.done) {
          //Connection is done, display either login screen or home screen
          return Container(
            color: color_dark_background,
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
      catchError: (context, error) {
        debug('Something went wrong... Perhaps you weren\'t allowed. Returning empty UserData!');
        return UserData.empty();
      },
      builder: (context, widget) {

        UserData userData = Provider.of<UserData>(context);
        if(userData != null) {
          //Check if user has set up his account
          return wishlistsWrapper(userData, dbs, context);
        } else {
          return Container(
            color: color_dark_background,
          );
        }

      }
    );
  }

  Widget wishlistsWrapper(UserData userData, DatabaseService dbs, BuildContext context) {
    UserPreferences prefs = UserPreferences.from(userData);
    return StreamProvider<List<WishlistModel>>.value(
      value: dbs.wishlistDocs(userData == null ? [] : userData.wishlistIds),
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus.unfocus();
          }
        },
        child: MaterialApp(
          home: ScreenWrapper(),
          theme: ThemeData(
            accentColor: color_text_light,
            canvasColor: prefs.color_background,
          ),
        ),
      ),
    );
  }

}
