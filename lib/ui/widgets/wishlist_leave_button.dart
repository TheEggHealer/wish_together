import 'package:flutter/material.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/dialog/confirmation_dialog.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/ui/custom_icons.dart';

class WishlistLeaveButton extends StatelessWidget {

  final UserPreferences prefs;
  final UserData currentUser;
  final WishlistModel wishlist;
  final Function callback;

  WishlistLeaveButton({this.prefs, this.currentUser, this.wishlist, this.callback});

  @override
  Widget build(BuildContext context) {
    bool owner = currentUser.uid == wishlist.wisherUID;
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
                await wishlist.deleteWishlist();
                callback();
              }
            },
          ));
        },
        splashRadius: 20,
        splashColor: prefs.color_splash,
        hoverColor: prefs.color_splash,
        highlightColor: prefs.color_splash,
        focusColor: prefs.color_splash,
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
                currentUser.wishlistIds.remove(wishlist.id);
                wishlist.invitedUsers.remove(currentUser.uid);
                debug('Model invited users: ${wishlist.invitedUsers}');
                await currentUser.uploadData();
                await wishlist.uploadList();
                callback();
              }
            },
          ));
        },
        splashRadius: 20,
        splashColor: prefs.color_splash,
        hoverColor: prefs.color_splash,
        highlightColor: prefs.color_splash,
        focusColor: prefs.color_splash,
      );
    }
  }
}
