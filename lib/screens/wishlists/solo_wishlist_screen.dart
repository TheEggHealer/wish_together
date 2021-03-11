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
    for(String uid in model.invitedUsers) {
      loadedUsers.add(await GlobalMemory.getUserData(uid));
    }
    wisher = await GlobalMemory.getUserData(model.wisherUID);

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

  Widget leaveButton(UserPreferences prefs) {
    bool owner = widget.currentUser.uid == model.wisherUID;
    if(owner) {
      return IconButton( //TODO Add splash
        icon: Icon(
          CustomIcons.trash,
          color: prefs.color_icon,
        ),
        onPressed: () async {
          await showDialog(context: context, builder: (context) => ConfirmationDialog(
            prefs: prefs,
            title: 'Delete wishlist',
            confirmationText: 'This wishlist will be deleted and cannot be recovered. Are you sure?',
            icon: CustomIcons.trash,
            callback: (confirm) async {
              if(confirm) {
                Navigator.pop(context);
                await model.deleteWishlist();
              }
            },
          ));
        },
        splashRadius: 20,
        splashColor: color_splash_light,
        hoverColor: color_splash_light,
        highlightColor: color_splash_light,
        focusColor: color_splash_light,
      );
    } else {
      return IconButton(
        icon: Icon(
          CustomIcons.bell, //TODO ICON: Change to leave icon
          color: prefs.color_icon,
        ),
        onPressed: () async {
          showDialog(context: context, builder: (context) => ConfirmationDialog(
            prefs: prefs,
            title: 'Leave wishlist',
            confirmationText: 'After leaving this wishlist, you have to be invited again if you change your mind. Are you sure?',
            icon: CustomIcons.bell, //TODO ICON: Change to leave icon
            callback: (confirm) async {
              if(confirm) {
                Navigator.pop(context);
                widget.currentUser.wishlistIds.remove(model.id);
                model.invitedUsers.remove(widget.currentUser.uid);
                debug('Model invited users: ${model.invitedUsers}');
                await widget.currentUser.uploadData();
                await model.uploadList();
              }
            },
          ));
        },
        splashRadius: 20,
        splashColor: color_splash_light,
        hoverColor: color_splash_light,
        highlightColor: color_splash_light,
        focusColor: color_splash_light,
      );
    }
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
      return Loading();
    }

    List<Widget> userDots = loadedUsers.map<Widget>((e) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: UserDot.fromUserData(
          userData: e,
          size: SIZE.MEDIUM,
          owner: e.uid == model.wisherUID,
          doShowName: true,
        ),
      );
    }).toList();

    List<Widget> itemList = model.items.map((e) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: ItemCard(model: e, wishlist: model, currentUser: widget.currentUser,),
    )).toList();
    debug('Refreshing current wishlist!');

    String wishlistTitle = wisher == null ? '' : (wisher.uid == widget.currentUser.uid ? 'Your wishlist' : '${wisher.name}\'s wishlist');

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
                leaveButton(prefs),
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
                Text(
                  'Invited',
                  style: prefs.text_style_sub_header,
                ),
                customButton(
                  onTap: () => inviteUser(),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: userDots.isNotEmpty ? userDots : [SpinKitThreeBounce(
                  color: color_loading_spinner,
                  size: 20,
                )],
              ),
            ),
            Divider(
              color: prefs.color_divider,
            )
          ]..addAll(itemList)..add(
            SizedBox(
              height: 10 + AdService.adHeight,
            )
          ),
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

  void inviteUser() async {
    debug('Invite');
  }
}
