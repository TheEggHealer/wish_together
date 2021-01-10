import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/database/database_service.dart';
import 'package:wishtogether/database/global_memory.dart';
import 'package:wishtogether/models/item_model.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/screens/wishlists/item_screen.dart';
import 'package:wishtogether/ui/widgets/user_dot.dart';

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
      if(GlobalMemory.currentlyLoadedUsers.containsKey(uid)) {
        updatedList.add(GlobalMemory.currentlyLoadedUsers[uid]);
        debug('Got user from currentlyLoadedUsers map');
      } else {
        UserData user = await UserData.from(uid);
        updatedList.add(user);
        GlobalMemory.currentlyLoadedUsers.putIfAbsent(uid, () => user);
        debug('User was not in currentlyLoadedUsers map, had to add it');
      }
    }
    claimedUsers = updatedList;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    DatabaseService dbs = DatabaseService();

    bool hideInfo = widget.model.shouldBeHiddenFrom(widget.currentUser);
    double width = MediaQuery.of(context).size.width;

    if(claimedUsersChanged()) loadClaimedUsers();

    List<Widget> userDots = claimedUsers.map((e) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: UserDot.fromUserData(
        userData: e,
        size: SIZE.SMALL,
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
                  TextSpan(
                    text: widget.model.itemName,
                    style: textstyle_card_header_dark
                  ),
                  TextSpan(
                    text: ' • ${widget.model.cost}',
                    style: textstyle_card_dark_sub
                  )
                ]
              ),
            ),
            //SizedBox(height: 10,),
            if(widget.model.comments != null && widget.model.comments.length > 0) Text(
              widget.model.comments[0].content,
              style: textstyle_card_dark_sub,
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  VerticalDivider(
                    color: color_divider_dark,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: userDots,
                  ),
                ],
              ),
            ),
          )
      );
    }

    return Hero(
      tag: heroTag,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: Colors.white,
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => StreamProvider<WishlistModel>.value(
                value: dbs.wishlistStream(widget.wishlist.id),
                child: ItemScreen(itemIndex: widget.wishlist.items.indexOf(widget.model), heroTag: heroTag, currentUser: widget.currentUser),
              ),
            ));
          },
          onLongPress: () {
            widget.model.toggleUserClaim(widget.currentUser);
          },
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          child: AnimatedSize(
            duration: Duration(milliseconds: 400),
            curve: Curves.ease,
            alignment: Alignment.topCenter,
            vsync: this,
            child: Container(
              width: width,
              padding: EdgeInsets.all(8.0),
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
