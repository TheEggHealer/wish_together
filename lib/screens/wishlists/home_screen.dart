import 'package:drag_and_drop_gridview/devdrag.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/screens/drawer/drawer.dart';
import 'package:wishtogether/screens/wishlists/create_wishlist_screen.dart';
import 'package:wishtogether/screens/wishlists/group_wishlist_screen.dart';
import 'package:wishtogether/services/ad_service.dart';
import 'package:wishtogether/services/auth_service.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/screens/wishlists/solo_wishlist_screen.dart';
import 'package:wishtogether/ui/custom_icons.dart';
import 'package:wishtogether/ui/widgets/custom_scaffold.dart';
import 'package:wishtogether/ui/widgets/empty_list.dart';
import 'package:wishtogether/ui/widgets/loading.dart';
import 'package:wishtogether/ui/widgets/wishlist_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


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
  }

  void onLeave(DatabaseService dbs) async {
    await dbs.uploadData(dbs.userData, dbs.uid, {'wishlists' : wishlists.map((e) => e.id).toList()});
    banner.dispose();
  }

  Widget groupWishlistStream(BuildContext context, DatabaseService dbs) {

    WishlistModel model = Provider.of<WishlistModel>(context);
    return StreamProvider<List<WishlistModel>>.value(
      value: dbs.wishlistDocs(model != null ? model.wishlistStream : []),
      catchError: (context3, e) {if(Navigator.canPop(context)) Navigator.pop(context);},
      child: GroupWishlistScreen(userData, model),
    );

  }

  Widget cardBuilder(BuildContext context, int index) {
    return WishlistCard(
      prefs: prefs,
      model: wishlists[index],
      currentUser: userData,
      onClick: () {

        DatabaseService dbs = DatabaseService();
        String type = wishlists[index].type;
        String id = wishlists[index].id;

        if(type == 'solo') {
          Navigator.push(context, MaterialPageRoute(builder: (context2) => StreamProvider<WishlistModel>.value(
            value: dbs.wishlistStream(id),
            catchError: (context3, e) {if(Navigator.canPop(context)) Navigator.pop(context);}, //TODO Not fully tested, if wishlist closes randomly, check this first!
            child: SoloWishlistScreen(userData),
          )));
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context2) => StreamProvider<WishlistModel>.value(
            value: dbs.wishlistStream(id),
            catchError: (context3, e) {if(Navigator.canPop(context)) Navigator.pop(context);},
            builder: (context3, child) => groupWishlistStream(context3, dbs),
          )));
        }
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
    if(userData == null) {
      debug('Userdata is nulllllllllllllllllll');
      return Loading();
    }

    List<WishlistModel> freshList = Provider.of<List<WishlistModel>>(context);
    if(wishlists == null || wishlists.isEmpty || wishlists != freshList) {
      debug('Refreshing wishlists!');
      wishlists = freshList;
    }
    setupLists(wishlists, userData);

    Widget dragDropView = DragAndDropGridView(
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
    );

    Widget emptyList = EmptyList(
      prefs: prefs,
      header: 'No wishlists',
      verticalPadding: 80,
      instructions: 'To create a wishlist, tap the add button in the bottom right corner!',
      richInstructions: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'To create one, tap the add ',
              style: prefs.text_style_soft,
            ),
            WidgetSpan(
              child: Icon(
                Icons.add_circle,
                color: prefs.color_primary,
                size: 16,
              ),
            ),
            TextSpan(
              text: ' button in the bottom right corner!',
              style: prefs.text_style_soft,
            ),
          ]
        ),
      ),
    );

    return CustomScaffold(
      prefs: prefs,
      title: 'Wish Together',
      body: Container(
        child: wishlists?.isEmpty ?? true ? emptyList : dragDropView,
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
