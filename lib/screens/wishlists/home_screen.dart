import 'package:drag_and_drop_gridview/devdrag.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/database/auth_service.dart';
import 'package:wishtogether/database/database_service.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/ui/widgets/wishlist_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  UserData userData;
  List<WishlistModel> wishlists = [];

  int pos;

  List<String> tmpList;
  int variableSet = 0;
  double width;
  double height;

  @override
  void initState() {
    //tmpList
    super.initState();
  }

  void onLeave(DatabaseService dbs) async {
    await dbs.uploadData(dbs.userData, {'wishlists' : wishlists.map((e) => e.id).toList()});
  }

  Widget builder(BuildContext context, int index) {
    return WishlistCard(model: wishlists[index]);
  }

  void setupLists(List<WishlistModel> models, UserData userData) {
    if(models != null) {
      List<WishlistModel> sorted = [];
      userData.wishlistIds.forEach((element) {
        sorted.add(models.firstWhere((model) => model.id == element));
      });
      wishlists = sorted;
    }
    else models = [];
  }

  @override
  Widget build(BuildContext context) {

    AuthService auth = AuthService();
    UserData userData = Provider.of<UserData>(context);
    DatabaseService dbs = DatabaseService(uid: userData.uid);

    if(wishlists == null || wishlists.isEmpty) {
      wishlists = Provider.of<List<WishlistModel>>(context);
    }
    setupLists(wishlists, userData);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: color_primary,
        elevation: 10,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.logout, color: Colors.white,),
              onPressed: () async {
                onLeave(dbs);
                auth.signOut();
              },
            ),
            Text(
              'Wish Together',
              style: textstyle_appbar,
            ),
          ],
        ),
      ),
      body: Container(
        color: color_background,
        width: double.infinity,
        height: double.infinity,
        child: DragAndDropGridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3.2/2.3,
          ),
          padding: EdgeInsets.all(20),
          itemBuilder: builder,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: color_primary,
        splashColor: color_splash,
        hoverColor: color_splash,
        focusColor: color_splash,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
        onPressed: () {
          //TODO Create wishlist
        },
      ),
    );
  }
}
