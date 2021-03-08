import 'package:drag_and_drop_gridview/devdrag.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/screens/drawer/notifications_screen.dart';
import 'package:wishtogether/screens/wishlists/create_wishlist_screen.dart';
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

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  UserData userData;
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
      model: wishlists[index],
      onClick: () {
        DatabaseService dbs = DatabaseService();
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
          StreamProvider<WishlistModel>.value(
            value: dbs.wishlistStream(wishlists[index].id),
            child: SoloWishlistScreen(userData)
          )
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

  Widget notificationBell() {
    return Material(
      color: Colors.transparent,
      child: Stack(
          children: [
            IconButton(
              icon: Icon(
                CustomIcons.bell,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<UserData>.value(
                  value: DatabaseService(uid: userData.uid).userDocument,
                  child: NotificationScreen(),
                )));
              },
              splashRadius: 20,
              splashColor: color_splash_light,
              hoverColor: color_splash_light,
              highlightColor: color_splash_light,
              focusColor: color_splash_light,
            ),
            if(userData.nbrOfUnseenNotifications > 0) Positioned(
              right: 5,
              top: 5,
              child: Container(
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: color_text_error,
                ),
                constraints: BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Center(
                  child: Text(
                      '${userData.nbrOfUnseenNotifications}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      )
                  ),
                ),
              ),
            )
          ]
      ),
    );
  }

  Widget drawer(BuildContext context, AuthService auth) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Container(
              padding: EdgeInsets.only(bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  UserDot.fromUserData(userData: userData, size: SIZE.LARGE),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        userData.name,
                        style: textstyle_drawer_header
                      ),
                      notificationBell(),
                    ],
                  )
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: color_primary
            ),
          ),
          ListTile(
              title: Row(
                children: [
                  Icon(
                    CustomIcons.profile,
                    color: Colors.black,
                  ),
                  SizedBox(width: 10),
                  Text('Profile', style: textstyle_list_title),
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<UserData>.value(
                  value: DatabaseService(uid: userData.uid).userDocument,
                  child: ProfileScreen(),
                )));
              }
          ),
          ListTile(
              title: Row(
                children: [
                  Icon(
                    CustomIcons.settings,
                    color: Colors.black,
                  ),
                  SizedBox(width: 10),
                  Text('Settings', style: textstyle_list_title),
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<UserData>.value(
                  value: DatabaseService(uid: userData.uid).userDocument,
                  child: SettingsScreen(),
                )));              }
          ),
          ListTile(
              title: Row(
                children: [
                  Icon(
                    CustomIcons.help,
                    color: Colors.black,
                  ),
                  SizedBox(width: 10),
                  Text('Help', style: textstyle_list_title),
                ],
              ),
              onTap: () {
                debug('Go to profile');
              }
          ),
          ListTile(
            title: Row(
              children: [
                Icon(
                  CustomIcons.logout,
                  color: Colors.black,
                ),
                SizedBox(width: 10),
                Text('Logout', style: textstyle_list_title),
              ],
            ),
            onTap: () {
              onLeave(DatabaseService(uid: userData.uid));
              auth.signOut();
            },
          ),
          SizedBox(height: 60),
          Center(
            child: Column(
              children: [
                Icon(
                  CustomIcons.wish_together,
                  color: color_splash_dark,
                  size: 100,
                ),
                Text(
                    'Wish Together',
                    style: textstyle_subheader
                ),
                SizedBox(height: 10),
                Text(
                    'Build number: 1.0.3+1',
                    style: textstyle_dev
                ),
                Text(
                    'Build date: 11-01-2021',
                    style: textstyle_dev
                ),
                SizedBox(height: 5),
                Text(
                    '© Copyright Jonathan Runeke 2021',
                    style: textstyle_dev
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    AuthService auth = AuthService();
    userData = Provider.of<UserData>(context);
    UserPreferences prefs = UserPreferences.from(userData);
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
      body: Container(
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
      drawer: drawer(context, auth),
    );
  }
}
