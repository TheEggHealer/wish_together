import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wishtogether/models/item_model.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/screens/wishlists/solo_wishlist_screen.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/services/global_memory.dart';
import 'package:wishtogether/ui/custom_icons.dart';
import 'package:wishtogether/ui/widgets/user_dot.dart';

class GroupWishlistItem extends StatefulWidget {

  String heroTag;
  ItemModel model;
  UserPreferences prefs;
  Function onTap;
  Function onLongTap;
  bool hideInfo;

  GroupWishlistItem({this.model, this.prefs, this.onTap, this.onLongTap, this.hideInfo, this.heroTag});

  _GroupWishlistItemState createState() => _GroupWishlistItemState();

}

class _GroupWishlistItemState extends State<GroupWishlistItem> {

  List<UserData> claimedUsers = [];

  bool claimedUsersChanged() {
    List<String> uids = claimedUsers.map((e) => e.uid).toList();
    if(widget.model.claimedUsers.length != uids.length) return true;
    widget.model.claimedUsers.forEach((element) {
      if(!uids.contains(element)) return true;
    });
    return false;
  }

  void loadClaimedUsers() async {
    List<UserData> updatedList = [];
    for(String uid in widget.model.claimedUsers) {
      updatedList.add(await GlobalMemory.getUserData(uid));
    }
    claimedUsers = updatedList;

    setState(() {});
  }

  List<Widget> getUserDots() {
    return claimedUsers.map<Widget>((e) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      child: UserDot.fromUserData(
        userData: e,
        size: SIZE.SMALL,
        showPicture: false,
      ),
    )).toList();
  }

  @override
  Widget build(BuildContext context) {

    if(claimedUsersChanged()) loadClaimedUsers();

    List<Widget> userDots = widget.hideInfo ? [] : getUserDots();
    if(userDots.isEmpty) userDots.add(UserDot.placeHolder(size: SIZE.SMALL));

    return Hero(
      tag: widget.heroTag,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: widget.prefs.color_card,
        child: InkWell(
          splashColor: widget.prefs.color_splash,
          focusColor: widget.prefs.color_splash,
          highlightColor: widget.prefs.color_splash,
          hoverColor: widget.prefs.color_splash,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          onTap: widget.onTap,
          onLongPress: widget.onLongTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            constraints: BoxConstraints(
              minHeight: 80,
              minWidth: 120,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.model.itemName,
                  textAlign: TextAlign.center,
                  style: widget.prefs.text_style_sub_sub_header,
                ),
                Row(
                  children: [
                    if(widget.model.hideFromWisher) Icon(
                      CustomIcons.hide,
                      color: widget.prefs.color_icon,
                      size: 20,
                    ),
                    if(widget.model.hideFromWisher && widget.model.photoURL.isNotEmpty) SizedBox(width: 10),
                    if(widget.model.photoURL.isNotEmpty) Icon(
                      CustomIcons.camera,
                      color: widget.prefs.color_icon,
                      size: 20,
                    ),
                  ],
                ),
                Row(
                  children: userDots,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
