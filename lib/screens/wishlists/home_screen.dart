import 'package:drag_and_drop_gridview/devdrag.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/group_wishlist_model.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/screens/drawer/drawer.dart';
import 'package:wishtogether/screens/drawer/notifications_screen.dart';
import 'package:wishtogether/screens/wishlists/create_wishlist_screen.dart';
import 'package:wishtogether/screens/wishlists/group_wishlist_screen.dart';
import 'package:wishtogether/services/ad_service.dart';
import 'package:wishtogether/services/auth_service.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/screens/drawer/profile_screen.dart';
import 'package:wishtogether/screens/drawer/settings_screen.dart';
import 'package:wishtogether/screens/wishlists/solo_wishlist_screen.dart';
import 'package:wishtogether/ui/custom_icons.dart';
import 'package:wishtogether/ui/widgets/custom_scaffold.dart';
import 'package:wishtogether/ui/widgets/loading.dart';
import 'package:wishtogether/ui/widgets/user_dot.dart';
import 'package:wishtogether/ui/widgets/wishlist_card.dart';

import '../../services/invitation_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  UserData userData;
  UserPreferences prefs;
  List<WishlistModel> wishlists = [];

  int pos;

  List<String> tmpList;
  int variableSet = 0;
  double width;
  double height;

  BannerAd banner;

  @override
  void initState() {
    //tmpList
    super.initState();

    if(AdService.hasAds) {
      banner = AdService.buildTestAd()
        ..load()
        ..show();
    }
  }

  void onLeave(DatabaseService dbs) async {
    await dbs.uploadData(dbs.userData, dbs.uid, {'wishlists' : wishlists.map((e) => e.id).toList()});
    banner.dispose();
  }

  Widget cardBuilder(BuildContext context, int index) {
    return WishlistCard(
      prefs: prefs,
      model: wishlists[index],
      onClick: () {
        DatabaseService dbs = DatabaseService();
        String type = wishlists[index].type;

        Stream stream = type == 'solo' ? dbs.wishlistStream(wishlists[index].id)
                                       : dbs.wishlistDocs(wishlists[index].wishlistStream);

        Widget child = type == 'solo' ? SoloWishlistScreen(userData)
                                      : GroupWishlistScreen(userData);

        Navigator.push(context, MaterialPageRoute(builder: (context) =>
          type == 'solo' ? StreamProvider<WishlistModel>.value(value: stream, child: child,)
                         : StreamProvider<List<WishlistModel>>.value(value: stream, child: child,),
        ));
      }
    );
  }

  void setupLists(List<WishlistModel> models, UserData userData) {
    if(models != null) {
      List<WishlistModel> sorted = [];
      List<String> wishlistsToRemove = [];
      userData.wishlistIds.forEach((id) {
        sorted.add(
          models.firstWhere((model) => model.id == id, orElse: () {
            debug('Wishlist doesn\'t exist, should be removed: $id');
            wishlistsToRemove.add(id);
            return null;
          })
        );
      });

      if(wishlistsToRemove.isNotEmpty) deleteNonExistingLists(wishlistsToRemove, userData);

      wishlists = sorted.where((model) => model != null).toList();
    }
    else models = [];
  }

  Future<void> deleteNonExistingLists(List<String> ids, UserData user) async {
    List<String> toRemove = [];
    DatabaseService dbs = DatabaseService();
    for(int i = 0; i < ids.length; i++) {
      if(!(await dbs.checkDocumentExists(dbs.wishlist, ids[i]))) {
        toRemove.add(ids[i]);
      }
    }

    if(toRemove.isNotEmpty) {
      toRemove.forEach((id) {
        user.wishlistIds.remove(id);
      });

      user.uploadData();
    }
  }

  @override
  Widget build(BuildContext context) {

    AuthService auth = AuthService();
    userData = Provider.of<UserData>(context);
    prefs = UserPreferences.from(userData);
    if(userData == null) return Loading();

    DatabaseService dbs = DatabaseService(uid: userData.uid);

    List<WishlistModel> freshList = Provider.of<List<WishlistModel>>(context);
    if(wishlists == null || wishlists.isEmpty || wishlists != freshList) {
      debug('Refreshing wishlists!');
      wishlists = freshList;
    }
    setupLists(wishlists, userData);
    return CustomScaffold(
      prefs: prefs,
      title: 'Wish Together',
      body: Container( //TODO Maybe add padding, at least to bottom to compromise for fab and ads
        child: DragAndDropGridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3.2/2.3,
          ),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          itemBuilder: cardBuilder,
          itemCount: wishlists != null ? wishlists.length : 0,
          onWillAccept: (oldI, newI) => true,
          onReorder: (oldI, newI) {
            //String tmp = userData.wishlistIds[oldI];
            //userData.wishlistIds[oldI] = userData.wishlistIds[newI];
            //userData.wishlistIds[newI] = tmp;
            //dbs.uploadData(dbs.userData, {'wishlists' : userData.wishlistIds});

            var tmp = wishlists[oldI];
            wishlists[oldI] = wishlists[newI];
            wishlists[newI] = tmp;
          },
        ),
      ),
      fab: Padding(
        padding: EdgeInsets.only(bottom: AdService.adHeight),
        child: FloatingActionButton(
          backgroundColor: prefs.color_primary,
          splashColor: prefs.color_splash,
          hoverColor: prefs.color_splash,
          focusColor: prefs.color_splash,
          child: Icon(
            Icons.add,
            color: prefs.color_background,
            size: 40,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateWishlistScreen()));
          },
        ),
      ),
      drawer: HomeDrawer.drawer(context, auth, userData, () {
        onLeave(DatabaseService(uid: userData.uid));
        auth.signOut();
      }),
    );
  }
}
