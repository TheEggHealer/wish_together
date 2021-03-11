import 'package:flutter/material.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/dialog/custom_dialog.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/services/global_memory.dart';
import 'package:wishtogether/services/invitation_service.dart';
import 'package:wishtogether/ui/custom_icons.dart';
import 'package:wishtogether/ui/widgets/custom_buttons.dart';
import 'package:wishtogether/ui/widgets/custom_textfields.dart';
import 'package:wishtogether/ui/widgets/user_dot.dart';

class InviteToWishlistDialog extends StatefulWidget {

  UserPreferences prefs;
  UserData currentUser;
  WishlistModel wishlist;
  Function callback;
  List<String> alreadyInvited = [];

  InviteToWishlistDialog(this.prefs, this.currentUser, this.callback, this.alreadyInvited);

  @override
  _InviteToWishlistDialogState createState() => _InviteToWishlistDialogState();
}

class _InviteToWishlistDialogState extends State<InviteToWishlistDialog> {

  String _input = '';
  List<UserData> loadedFriends = [];
  List<bool> checkboxes = [];


  void loadFriends() async {
    List<UserData> result = [];
    for(String uid in widget.currentUser.friends) {
      result.add(await GlobalMemory.getUserData(uid));
    }
    loadedFriends = result;
    checkboxes = result.map((e) => widget.alreadyInvited.contains(e.uid)).toList();
    debug('Loaded friends!');
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    loadFriends();
  }

  Widget friends() {

    List<Widget> friendRows = loadedFriends.map((e) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          UserDot.fromUserData(userData: e, size: SIZE.MEDIUM,),
          SizedBox(width: 10,),
          Text(
            e.name,
            style: widget.prefs.text_style_sub_sub_header,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Checkbox(
                onChanged: (v) {
                  setState(() {
                    checkboxes[loadedFriends.indexOf(e)] = v; //TODO index another way (?) and fix checkbox design
                  });
                },
                value: checkboxes[loadedFriends.indexOf(e)],
              )
            ),
          )
        ],
      );
    }).toList();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(
                color: widget.prefs.color_divider,
                endIndent: 10,
                indent: 20,
              ),
            ),
            Center(
              child: Text(
                'Choose friends',
                style: widget.prefs.text_style_sub_sub_header,
              ),
            ),
            Expanded(
              child: Divider(
                color: widget.prefs.color_divider,
                indent: 10,
                endIndent: 20,
              ),
            ),
          ],
        ),
      ]..addAll(friendRows),
    );
  }

  @override
  Widget build(BuildContext context) {

    bool hasFriends = widget.currentUser.friends.isNotEmpty;

    return CustomDialog(
      prefs: widget.prefs,
      title: 'Invite to wishlist',
      icon: CustomIcons.profile,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customTextField(
            prefs: widget.prefs,
            onChanged: (val) {
              this._input = val;
            },
            multiline: false,
            helperText: 'Email or friend code',
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              customButton(
                text: 'Invite',
                fillColor: widget.prefs.color_accept,
                onTap: () async {
                  String uid = await DatabaseService().uidFromEmail(_input);
                  widget.callback([uid]);
                  debug('Invite');
                },
                textColor: widget.prefs.color_background,
              ),
            ],
          ),
          SizedBox(height: 10),
          if(hasFriends) friends(),
        ],
      ),
    );
  }
}
