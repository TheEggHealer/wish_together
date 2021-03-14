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

import 'package:wishtogether/constants.dart';

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
    return widget.model.items.map<Widget>((e) {
      String heroTag = Uuid().v1();
      bool hideInfo = widget.currentUser.uid == wisher.uid;

      return GroupWishlistItem(
        model: e,
        prefs: widget.prefs,
        heroTag: heroTag,
        hideInfo: hideInfo,
        onTap: () {
          DatabaseService dbs = DatabaseService();
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => StreamProvider<WishlistModel>.value(
              value: dbs.wishlistStream(widget.model.id),
              child: ItemScreen(itemIndex: widget.model.items.indexOf(e), heroTag: heroTag, currentUser: widget.currentUser),
            ),
          ));
        },
        onLongTap: () {
          if(!hideInfo) {
            HapticFeedback.lightImpact();
            e.toggleUserClaim(widget.currentUser);
          }
        },
      );
    }).toList();
  }

  Widget addItemButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: circleButton(
        icon: Icon(Icons.add, size: 30, color: widget.prefs.color_background),
        fillColor: widget.prefs.color_accept,
        splashColor: widget.prefs.color_splash,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateItemScreen(widget.model)));
        },
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
