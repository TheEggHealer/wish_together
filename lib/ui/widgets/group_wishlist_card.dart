import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/screens/wishlists/create_item_screen.dart';
import 'package:wishtogether/screens/wishlists/item_screen.dart';
import 'package:wishtogether/screens/wishlists/solo_wishlist_screen.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/services/global_memory.dart';
import 'package:wishtogether/ui/widgets/custom_buttons.dart';
import 'package:wishtogether/ui/widgets/group_wishlist_item.dart';
import 'package:wishtogether/models/notification_model.dart';

import 'package:wishtogether/constants.dart';
import 'package:wishtogether/ui/widgets/notification_counter.dart';

class GroupWishlistCard extends StatefulWidget {

  UserPreferences prefs;
  WishlistModel model;
  UserData currentUser;

  GroupWishlistCard({this.prefs, this.model, this.currentUser});

  @override
  _GroupWishlistCardState createState() => _GroupWishlistCardState();
}

class _GroupWishlistCardState extends State<GroupWishlistCard> {

  UserData wisher = UserData.empty();
  ScrollController _scrollController = ScrollController();

  void loadWisher() async {
    wisher = await GlobalMemory.getUserData(widget.model.wisherUID);
    setState(() {});
  }

  List<Widget> getItems() {
    bool isWisher = wisher?.uid == widget.currentUser.uid;
    return widget.model.items.where((item) => !isWisher ? true : !item.hideFromWisher).map<Widget>((e) {
      String heroTag = Uuid().v1();
      bool hideInfo = widget.currentUser.uid == wisher.uid;

      int numberOfNotif = widget.currentUser.notifications.where((notif) {
        if((notif.prefix == NotificationModel.PRE_ITEM_CHANGE || notif.prefix == NotificationModel.PRE_CLAIMED_ITEM_CHANGE)) {
          List<String> parts = notif.content.split('*');
          String wishlistId = parts[1];
          String itemId = parts[2];
          return wishlistId == widget.model.id && itemId == e.id;
        }
        return false;
      }).length;

      return Stack(
        children: [
          GroupWishlistItem(
            model: e,
            prefs: widget.prefs,
            heroTag: heroTag,
            hideInfo: hideInfo,
            onTap: () {
              debug('Why is this happening???');
              DatabaseService dbs = DatabaseService();
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => StreamProvider<WishlistModel>.value(
                  value: dbs.wishlistStream(widget.model.id),
                  child: ItemScreen(itemId: e.id, heroTag: heroTag, currentUser: widget.currentUser),
                ),
              ));
            },
            onLongTap: () {
              if(!hideInfo) {
                HapticFeedback.lightImpact();
                e.toggleUserClaim(widget.currentUser);
              }
            },
          ),
          if(numberOfNotif > 0) Positioned(
            top: 0,
            right: 0,
            child: NotificationCounter(
              prefs: widget.prefs,
              border: true,
              number: numberOfNotif,
            ),
          )
        ],
      );
    }).toList();
  }

  Widget addItemButton() {
    return Container(
      width: 120, //Item card size
      height: 80,
      child: Center(
        child: circleButton(
          icon: Icon(Icons.add, size: 30, color: widget.prefs.color_background),
          fillColor: widget.prefs.color_accept,
          splashColor: widget.prefs.color_splash,
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateItemScreen(widget.model)));
          },
        ),
      ),
    );
  }

  void openWishlist() {
    DatabaseService dbs = DatabaseService();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
        StreamProvider<WishlistModel>.value(
          value: dbs.wishlistStream(widget.model.id),
          child: SoloWishlistScreen(widget.currentUser),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    loadWisher();
    List<Widget> items = getItems();
    items.add(addItemButton());

    String title = wisher.uid == widget.currentUser.uid ? 'Your wishlist' : '${widget.model.name}\'s wishlist';
    Color cardColor = wisher.userColor;

    double offset = 24;
    if(_scrollController.hasClients) {
      offset = _scrollController.offset < 0 ? 24 - _scrollController.offset : 24;

    }

    double width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
            child: Card(
              elevation: 5,
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                splashColor: widget.prefs.color_splash,
                focusColor: widget.prefs.color_splash,
                highlightColor: widget.prefs.color_splash,
                hoverColor: widget.prefs.color_splash,
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                onTap: () {
                  openWishlist();
                },
                child: Container(
                  padding: EdgeInsets.only(left: 6, right: 6, bottom: 6, top: 26),
                  constraints: BoxConstraints(
                    minWidth: width - 24, //22 from the total horizontal padding. I don't know where the +2 comes from :( But it works! :)
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: widget.prefs.color_shadow,
                    ),
                    child: Row(
                      children: items,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: offset,
          top: 14,
          child: Text(
            title,
            style: widget.prefs.text_style_wishlist_card(cardColor),
          ),
        ),
      ]
    );
  }
}
