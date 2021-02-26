import 'package:flutter/material.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/dialog/custom_dialog.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/services/global_memory.dart';
import 'package:wishtogether/ui/custom_icons.dart';
import 'package:wishtogether/ui/widgets/custom_buttons.dart';
import 'package:wishtogether/ui/widgets/custom_textfields.dart';
import 'package:wishtogether/ui/widgets/user_dot.dart';

class InviteToWishlistDialog extends StatefulWidget {

  UserData currentUser;

  InviteToWishlistDialog(this.currentUser);

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
    checkboxes = result.map((e) => false).toList();
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
      bool val = false;

      return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          UserDot.fromUserData(userData: e, size: SIZE.MEDIUM,),
          SizedBox(width: 10,),
          Text(
            e.name,
            style: textstyle_header,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Checkbox(
                onChanged: (v) {
                  setState(() {
                    checkboxes[loadedFriends.indexOf(e)] = v; //TODO index another way
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
                color: color_divider_dark,
                endIndent: 10,
                indent: 20,
              ),
            ),
            Center(
              child: Text(
                'Choose friends',
                style: textstyle_subheader,
              ),
            ),
            Expanded(
              child: Divider(
                color: color_divider_dark,
                indent: 10,
                endIndent: 20,
              ),
            ),
          ],
        ),
      ]..addAll(friendRows)..addAll(friendRows),
    );
  }

  @override
  Widget build(BuildContext context) {

    bool hasFriends = widget.currentUser.friends.isNotEmpty;

    return CustomDialog(
      title: 'Invite to wishlist',
      icon: CustomIcons.profile,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textFieldComment(
            onChanged: (val) {
              this._input = val;
            },
            textColor: color_text_dark,
            activeColor: color_primary,
            borderColor: color_text_dark_sub,
            errorColor: color_text_error,
            helperText: 'Email or friend code',
            textStyle: textstyle_subheader,
            borderRadius: 30
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              claimButton(
                text: 'Invite',
                fillColor: color_claim_green,
                onTap: () {
                  debug('Invite');
                },
                splashColor: color_splash_light,
                textColor: color_text_light,
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
