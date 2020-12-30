import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/database/database_service.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_model.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/ui/custom_icons.dart';
import 'package:wishtogether/ui/widgets/item_card.dart';
import 'package:wishtogether/ui/widgets/user_dot.dart';

class SoloWishlistScreen extends StatefulWidget {

  @override
  _SoloWishlistScreenState createState() => _SoloWishlistScreenState();
}

class _SoloWishlistScreenState extends State<SoloWishlistScreen> {

  WishlistModel model;
  List<UserData> users = [];

  _SoloWishlistScreenState();

  void loadUsers() async {
    users = [];
    for(UserModel user in model.invitedUsers) {
      DatabaseService dbs = DatabaseService(uid: user.uid);
      UserData userData = UserData(raw: await dbs.getRaw(dbs.userData), uid: user.uid);
      users.add(userData);
      debug('ADDED USER: ${userData.name}');
    }

    setState(() {});

    debug('Users are loaded');
  }

  bool usersChanged() {
    List<String> uids = users.map((e) => e.uid).toList();
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
      if(usersChanged()) loadUsers();
    }

    List<Widget> userDots = users.map<Widget>((e) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: UserDot(
          userData: e,
          size: SIZE.MEDIUM,
        ),
      );
    }).toList();

    List<ItemCard> itemList = model.items.map((e) => ItemCard(model: e)).toList();
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

    //List<Widget> userDots = [];

    return Scaffold(
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
      body: Container(
        color: color_background,
        width: double.infinity,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
          ]..addAll(itemList),
        ),
      ),
    );
  }

  void inviteUser() {
     debug('Invite user');
  }
}
