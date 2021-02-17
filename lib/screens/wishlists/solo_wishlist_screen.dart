import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/screens/wishlists/create_item_screen.dart';
import 'package:wishtogether/screens/wishlists/create_wishlist_screen.dart';
import 'package:wishtogether/services/ad_service.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/services/functions_service.dart';
import 'package:wishtogether/services/global_memory.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_model.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/services/invitation_service.dart';
import 'package:wishtogether/ui/custom_icons.dart';
import 'package:wishtogether/ui/widgets/item_card.dart';
import 'package:wishtogether/ui/widgets/loading.dart';
import 'package:wishtogether/ui/widgets/user_dot.dart';

class SoloWishlistScreen extends StatefulWidget {

  final UserData currentUser;

  SoloWishlistScreen(this.currentUser);

  @override
  _SoloWishlistScreenState createState() => _SoloWishlistScreenState();
}

class _SoloWishlistScreenState extends State<SoloWishlistScreen> {

  WishlistModel model;
  UserData wisher;
  List<UserData> loadedUsers = [];

  _SoloWishlistScreenState();


  Future<void> loadUsers() async {
    loadedUsers = [];
    for(UserModel user in model.invitedUsers) {
      String uid = user.uid;
      loadedUsers.add(await GlobalMemory.getUserData(uid));
    }
    wisher = await GlobalMemory.getUserData(model.wisherUID);

    //TODO: Load wisher userdata here!

    setState(() {});
  }

  bool invitedUsersChanged() {
    List<String> uids = loadedUsers.map((e) => e.uid).toList();

    if(uids.length != model.invitedUsers.length) return true;

    model.invitedUsers.forEach((element) {
      if(!uids.contains(element)) return true;
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {

    WishlistModel m = Provider.of<WishlistModel>(context);
    if(m != null) {
      model = m;
      if(invitedUsersChanged()) loadUsers();
    }

    if(model == null) {
      return Loading();
    }

    List<Widget> userDots = loadedUsers.map<Widget>((e) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: UserDot.fromUserData(
          userData: e,
          size: SIZE.MEDIUM,
        ),
      );
    }).toList();

    List<ItemCard> itemList = model.items.map((e) => ItemCard(model: e, wishlist: model, currentUser: widget.currentUser,)).toList();
    debug('Refreshing current wishlist!');

    userDots.add(
      Center(
        child: Material(
          color: Colors.transparent,
          child: IconButton(
            onPressed: () {
              inviteUser();
            },
            icon: Icon(CustomIcons.add),
            padding: EdgeInsets.all(8),
            iconSize: 40,
            color: color_text_dark,
            splashColor: color_splash_dark,
            hoverColor: color_splash_dark,
            highlightColor: color_splash_dark,
            focusColor: color_splash_dark,
            splashRadius: 20,
          ),
        ),
      ),
    );

    String wishlistTitle = wisher == null ? '' : (wisher.uid == widget.currentUser.uid ? 'Your wishlist' : '${wisher.name}\'s wishlist');

    return Scaffold(
      backgroundColor: color_background,
      appBar: AppBar(
        backgroundColor: color_primary,
        elevation: 10,
        title: Row(
          children: [
            Text(
              model.name,
              style: textstyle_appbar,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: color_background,
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  wisher == null ? UserDot.placeHolder(size: SIZE.LARGE) : UserDot.fromUserData(
                    userData: wisher,
                    size: SIZE.LARGE,
                  ),
                  SizedBox(width: 20),
                  Center(
                    child: Text(
                      wishlistTitle,
                      style: textstyle_header
                    )
                  )
                ],
              ),
              Divider(
                color: color_divider_dark,
              ),
              Text(
                'Invited Users',
                style: textstyle_header,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: userDots.isNotEmpty ? userDots : [SpinKitThreeBounce(
                    color: color_loading_spinner,
                    size: 20,
                  )],
                ),
              ),
              Divider(
                color: color_divider_dark,
              )
            ]..addAll(itemList)..add(
              SizedBox(
                height: 10 + AdService.adHeight,
              )
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: AdService.adHeight),
        child: FloatingActionButton(
          backgroundColor: color_primary,
          splashColor: color_splash_light,
          hoverColor: color_splash_light,
          focusColor: color_splash_light,
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateItemScreen(model)));
          },
        ),
      ),
    );
  }

  void inviteUser() async {
    //DatabaseService dbs = DatabaseService();
    //await dbs.changeMailToUIDAssociation('t@t.com', 'new@mail.com');
    FunctionService fs = FunctionService();
    await fs.call();
  }
}
