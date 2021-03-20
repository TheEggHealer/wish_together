import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/services/global_memory.dart';
import 'package:wishtogether/models/item_model.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/screens/wishlists/item_screen.dart';
import 'package:wishtogether/ui/custom_icons.dart';
import 'package:wishtogether/ui/widgets/notification_counter.dart';
import 'package:wishtogether/ui/widgets/user_dot.dart';
import 'package:wishtogether/models/notification_model.dart';

class ItemCard extends StatefulWidget {

  final ItemModel model;
  final WishlistModel wishlist;
  final UserData currentUser;

  ItemCard({@required this.model, @required this.wishlist, @required this.currentUser});

  @override
  _ItemCardState createState() => _ItemCardState();

}

class _ItemCardState extends State<ItemCard> with TickerProviderStateMixin {

  List<UserData> claimedUsers = [];
  String heroTag;

  @override
  void initState() {
    super.initState();
    heroTag = Uuid().v1();
  }


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

  @override
  Widget build(BuildContext context) {
    DatabaseService dbs = DatabaseService();
    UserPreferences prefs = UserPreferences.from(widget.currentUser);

    bool hideInfo = widget.model.shouldBeHiddenFrom(widget.currentUser);
    double width = MediaQuery.of(context).size.width;

    if(claimedUsersChanged()) loadClaimedUsers();

    List<Widget> userDots = claimedUsers.map((e) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: UserDot.fromUserData(
        userData: e,
        size: SIZE.SMALL,
        showPicture: false,
      ),
    )).toList();

    if(userDots.isEmpty) userDots.add(Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: UserDot.placeHolder(
        size: SIZE.SMALL
      ),
    ));

    List<Widget> content = [
      Expanded(
        flex: 8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              overflow: TextOverflow.fade,
              softWrap: false,
              maxLines: 1,
              text: TextSpan(
                children: [
                  if(widget.model.hideFromWisher) WidgetSpan(
                    child: Icon(
                      CustomIcons.hide,
                      color: prefs.color_icon,
                      size: 20,
                    )
                  ),
                  if(widget.model.hideFromWisher) TextSpan(
                      text:' • ',
                      style: prefs.text_style_item_sub_header
                  ),
                  if(widget.model.photoURL.isNotEmpty) WidgetSpan(
                    child: Icon(
                      CustomIcons.camera,
                      color: prefs.color_icon,
                      size: 20,
                    )
                  ),
                  if(widget.model.photoURL.isNotEmpty) TextSpan(
                    text:' • ',
                    style: prefs.text_style_item_sub_header
                  ),
                  TextSpan(
                    text: widget.model.itemName,
                    style: prefs.text_style_item_header
                  ),
                  if(widget.model.cost > 0) TextSpan(
                    text: ' • ${widget.model.cost}',
                    style: prefs.text_style_item_sub_header,
                  )
                ]
              ),
            ),
            //SizedBox(height: 10,),
            if(widget.model.description.isNotEmpty) Text(
              widget.model.description,
              style: prefs.text_style_bread,
            ),
          ],
        ),
      ),
    ];
    if(!hideInfo) {
      content.add(
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: userDots,
              ),
            ),
          )
      );
    }

    return Hero(
      tag: heroTag,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: prefs.color_card,
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => StreamProvider<WishlistModel>.value(
                value: dbs.wishlistStream(widget.wishlist.id),
                child: ItemScreen(itemId: widget.model.id, heroTag: heroTag, currentUser: widget.currentUser),
              ),
            ));
          },
          onLongPress: () {
            if(!hideInfo) {
              HapticFeedback.lightImpact();
              widget.model.toggleUserClaim(widget.currentUser);
            }
          },
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: AnimatedSize(
            duration: Duration(milliseconds: 400),
            curve: Curves.ease,
            alignment: Alignment.topCenter,
            vsync: this,
            child: Container(
              width: width,
              padding: EdgeInsets.only(top: 4, right: 8, left: 8, bottom: 8),
              constraints: BoxConstraints(
                minHeight: 60,
              ),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: content,
                ),
              ),
            ),
          ),
        ),
      ),
    );

  }
}
