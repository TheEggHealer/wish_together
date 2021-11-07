import 'package:flutter/material.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/services/global_memory.dart';
import 'package:wishtogether/ui/custom_icons.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/ui/widgets/notification_counter.dart';
import 'package:wishtogether/ui/widgets/user_dot.dart';

import '../../models/notification_model.dart';
import '../../models/notification_model.dart';

class WishlistCard extends StatefulWidget {

  WishlistModel model;
  UserData currentUser;
  Function onClick;
  UserPreferences prefs;

  WishlistCard({this.model, this.currentUser, this.onClick, this.prefs});
  
  WishlistCard.template(this.prefs) {
    model = WishlistModel.create(
      color: Color(0xFFD37474).value,
      wisherUID: 'no_usr',
      name: 'John\'s birthday',
      type: 'solo',
      invitedUsers: ['0', '1', '2'],
      dateCreated: '2021-03-27',
    );
    currentUser = UserData.empty();

  }

  @override
  State<StatefulWidget> createState() => WishlistCardState();

}

class WishlistCardState extends State<WishlistCard> {

  List<Widget> userDots = [];

  void initState() {
    super.initState();
    loadUserDots();
  }

  Future loadUserDots() async {

    for(int i = 0; i < widget.model.invitedUsers.length; i++) {
      String uid = widget.model.invitedUsers[i];
      userDots.add(
        Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: UserDot.fromUserData(
            userData: await GlobalMemory.getUserData(uid),
            size: SIZE.SMALL,
          ),
        )
      );
    }

    setState(() {});
  }

  Widget build(BuildContext context) {
    int numberOfNotif = widget.currentUser.notifications.where((notif) {
      if((notif.prefix == NotificationModel.PRE_ITEM_CHANGE || notif.prefix == NotificationModel.PRE_CLAIMED_ITEM_CHANGE)) {
        List<String> parts = notif.content.split('*');
        String groupId = parts[0];
        String wishlistId = parts[1];
        return wishlistId == widget.model.id || groupId == widget.model.id;
      }
      return false;
    }).length;

    Size size = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      color: widget.prefs.color_card,
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: size.width / 2.4,
            height: size.width / 3.2, //3.2
        child: Stack(
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 30,
                    color: Color(widget.model.color),
                    child: Center(
                      child: Text(
                        widget.model.name,
                        style: widget.prefs.text_style_wishlist_card(Color(widget.model.color)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      '${widget.model.type == 'solo' ? '1 wishlist' : '${widget.model.wishlistStream.length} wishlist(s)'}\n' +
                      '${widget.model.invitedUsers.length} user(s)',
                      style: widget.prefs.text_style_bread,

                    ),
                  ),
                  if(userDots.isNotEmpty) Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5,),
                    child: Row(
                      children: userDots,
                    ),
                  )
                ],  
              ),
            ),
            InkWell(
              splashColor: widget.prefs.color_splash,
                focusColor: widget.prefs.color_splash,
                highlightColor: widget.prefs.color_splash,
                hoverColor: widget.prefs.color_splash,
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                onTap: widget.onClick,

            )
          ],
        ),
      ),
    );
  }

  /**
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Color cardColor = Color(model.color);

    bool isWisher = currentUser.uid == model.wisherUID;

    int numberOfNotif = currentUser.notifications.where((notif) {
      if((notif.prefix == NotificationModel.PRE_ITEM_CHANGE || notif.prefix == NotificationModel.PRE_CLAIMED_ITEM_CHANGE)) {
        List<String> parts = notif.content.split('*');
        String groupId = parts[0];
        String wishlistId = parts[1];
        return wishlistId == model.id || groupId == model.id;
      }
      return false;
    }).length;

    return Center(
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        color: cardColor,
        child: Stack(
          children: [
            InkWell(
              splashColor: prefs.color_splash,
              focusColor: prefs.color_splash,
              highlightColor: prefs.color_splash,
              hoverColor: prefs.color_splash,
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              onTap: onClick,
              child: Container(
                  width: size.width / 2.4,
                  height: size.width / 3.2, //3.2
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: model.name,
                            style: prefs.text_style_wishlist_card(cardColor),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            model.dateCreated,
                            style: prefs.text_style_wishlist_tiny(cardColor),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if(model.type == 'solo') Row(
                                children: [
                                  Text(
                                    model.itemCount(isWisher).toString(),
                                    style: prefs.text_style_wishlist_card(cardColor),
                                  ),
                                  Icon(
                                    CustomIcons.list_items,
                                    color: prefs.color_wishlist_card(cardColor),
                                  ),
                                ],
                              ),
                              if(model.type == 'group') Icon(
                                CustomIcons.group,
                                color: prefs.color_wishlist_card(cardColor),
                                size: 30,
                              ),
                              Row(
                                children: [
                                  Text(
                                    model.userCount.toString(),
                                    style: prefs.text_style_wishlist_card(cardColor),
                                  ),
                                  Icon(
                                    CustomIcons.profile,
                                    color: prefs.color_wishlist_card(cardColor),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  )
              ),
            ),
            if(numberOfNotif > 0) Positioned(
              top: 0,
              right: 0,
              child: NotificationCounter(
                prefs: prefs,
                border: true,
                number: numberOfNotif,
              ),
            )
          ]
        ),
      ),
    );
  }
  */

}
