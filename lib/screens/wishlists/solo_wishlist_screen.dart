import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/dialog/confirmation_dialog.dart';
import 'package:wishtogether/models/user_preferences.dart';
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
import 'package:wishtogether/services/notification_service.dart';
import 'package:wishtogether/ui/custom_icons.dart';
import 'package:wishtogether/ui/widgets/custom_buttons.dart';
import 'package:wishtogether/ui/widgets/custom_scaffold.dart';
import 'package:wishtogether/ui/widgets/empty_list.dart';
import 'package:wishtogether/ui/widgets/item_card.dart';
import 'package:wishtogether/ui/widgets/loading.dart';
import 'package:wishtogether/ui/widgets/notification_counter.dart';
import 'package:wishtogether/ui/widgets/user_dot.dart';
import 'package:wishtogether/ui/widgets/wishlist_leave_button.dart';
import 'package:wishtogether/models/notification_model.dart';

import '../../dialog/invite_to_wishlist_dialog.dart';

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
    List<UserData> tmp = [];
    for(String uid in model.invitedUsers) {
      tmp.add(await GlobalMemory.getUserData(uid));
    }
    wisher = await GlobalMemory.getUserData(model.wisherUID);

    loadedUsers = tmp;
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

  List<Widget> getUserDots(UserPreferences prefs) {
    return loadedUsers.map<Widget>((e) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: UserDot.fromUserData(
          userData: e,
          size: SIZE.MEDIUM,
          owner: !model.isSubList && e.uid == model.creatorUID,
          pending: !model.isSubList && !e.wishlistIds.contains(model.id),
          doShowName: true,
          prefs: prefs,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    UserPreferences prefs = UserPreferences.from(widget.currentUser);

    WishlistModel m = Provider.of<WishlistModel>(context);
    if(m != null) {
      model = m;
      if(invitedUsersChanged()) loadUsers();
    }

    if(model == null) {
      return Loading(prefs: prefs);
    }

    List<Widget> userDots = getUserDots(prefs);

    bool isWisher = wisher?.uid == widget.currentUser.uid;
    List<Widget> itemList = model.items.where((item) => !isWisher ? true : !item.hideFromWisher).map((e) {
      int numberOfNotif = widget.currentUser.notifications.where((notif) {
        if((notif.prefix == NotificationModel.PRE_ITEM_CHANGE || notif.prefix == NotificationModel.PRE_CLAIMED_ITEM_CHANGE)) {
          List<String> parts = notif.content.split('*');
          String wishlistId = parts[1];
          String itemId = parts[2];
          return wishlistId == model.id && itemId == e.id;
        }
        return false;
      }).length;

      return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: ItemCard(model: e, wishlist: model, currentUser: widget.currentUser,),
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
        ],
      );
    }).toList();

    Widget emptyList = EmptyList(
      prefs: prefs,
      header: 'No items',
      verticalPadding: 40,
      richInstructions: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            children: [
              TextSpan(
                text: 'To add one, tap the add ',
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

    String wishlistTitle = wisher == null ? '' : (wisher.uid == widget.currentUser.uid ? 'Your wishlist' : '${wisher.name}\'s wishlist');
    bool creator = widget.currentUser.uid == model.creatorUID;

    return CustomScaffold(
      prefs: prefs,
      title: model.name,
      backButton: true,
      body: Container(
        padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                wisher == null ? UserDot.placeHolder(size: SIZE.LARGE) : UserDot.fromUserData(
                  userData: wisher,
                  size: SIZE.LARGE,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    wishlistTitle,
                    style: prefs.text_style_wisher
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(
              color: prefs.color_divider,
              height: 0,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Invited',
                    style: prefs.text_style_sub_header,
                  ),
                ),
                if(!model.isSubList) WishlistLeaveButton(
                  prefs: prefs,
                  currentUser: widget.currentUser,
                  wishlist: model,
                  callback: () {
                    Navigator.pop(context);
                  },
                ),
                if(creator && !model.isSubList) SizedBox(width: 10),
                if(creator && !model.isSubList) customButton(
                  onTap: () async {
                    showDialog(context: context, builder: (context) => InviteToWishlistDialog(prefs, widget.currentUser, inviteUsers, loadedUsers.map((e) => e.uid).toList()));
                  },
                  textColor: prefs.color_background,
                  fillColor: prefs.color_accept,
                  splashColor: prefs.color_splash,
                  text: 'Invite',
                )
              ],
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: userDots.isNotEmpty ? userDots : [SpinKitThreeBounce(
                  color: color_loading_spinner,
                  size: 20,
                )],
              ),
            ),
            Divider(
              color: prefs.color_divider,
            ),
            if(itemList.isNotEmpty) Column(
              children: itemList,
            ) else emptyList,
            SizedBox(
              height: 10 + AdService.adHeight,
            )
          ]
        ),
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateItemScreen(model)));
          },
        ),
      ),
    );
  }

  void inviteUsers(List<String> uids) async {
    List<String> alreadyInvited = loadedUsers.map((e) => e.uid).toList();

    InvitationService invitationService = InvitationService();

    bool change = false;
    for(int i = 0; i < uids.length; i++) {
      if (!alreadyInvited.contains(uids[i])) {
        await invitationService.sendWishlistInvitation(widget.currentUser.uid, model.id, uids[i]);
        model.invitedUsers.add(uids[i]);
        change = true;
      }
    }

    if(change) await model.uploadList();
  }
}
