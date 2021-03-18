import 'package:flutter/material.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/dialog/custom_dialog.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/services/global_memory.dart';
import 'package:wishtogether/ui/custom_icons.dart';
import 'package:wishtogether/ui/widgets/custom_buttons.dart';
import 'package:wishtogether/ui/widgets/custom_textfields.dart';
import 'package:wishtogether/ui/widgets/user_dot.dart';

class InviteToWishlistDialog extends StatefulWidget {

  UserPreferences prefs;
  UserData currentUser;
  WishlistModel wishlist;
  Function(List<String>) callback;
  List<String> alreadyInvited = [];

  InviteToWishlistDialog(this.prefs, this.currentUser, this.callback, this.alreadyInvited);

  @override
  _InviteToWishlistDialogState createState() => _InviteToWishlistDialogState();
}

class _InviteToWishlistDialogState extends State<InviteToWishlistDialog> {

  String errorMessage = '';
  List<UserData> loadedFriends = [];
  Map<String, bool> checkboxes = {};
  TextEditingController inputController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void loadFriends() async {
    List<UserData> result = [];
    for(String uid in widget.currentUser.friends) {
      result.add(await GlobalMemory.getUserData(uid));
    }
    loadedFriends = result;
    checkboxes = Map.fromIterable(result, key: (e) => e.uid, value: (e) => widget.alreadyInvited.contains(e.uid));
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
              child: Theme(
                data: ThemeData(unselectedWidgetColor: widget.prefs.color_icon),
                child: Checkbox(
                  value: checkboxes[e.uid],
                  onChanged: (v) => setState(() {checkboxes[e.uid] = v;}),
                  checkColor: widget.prefs.color_background,
                  activeColor: widget.prefs.color_accept,
                  hoverColor: widget.prefs.color_splash,
                  focusColor: widget.prefs.color_splash,
                ),
              ),
            ),
          )
        ],
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    bool hasFriends = widget.currentUser.friends.isNotEmpty;

    return CustomDialog(
      prefs: widget.prefs,
      title: 'Invite to wishlist',
      icon: CustomIcons.profile,
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customTextField(
              validator: (val) => isEmail(val) ? null : 'Not a valid email or friend code',
              prefs: widget.prefs,
              controller: inputController,
              multiline: false,
              helperText: 'Email or friend code',
            ),
            SizedBox(height: 5),
            Center(
              child: Text(
                errorMessage,
                style: widget.prefs.text_style_error,
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                customButton(
                  text: 'Invite',
                  fillColor: widget.prefs.color_accept,
                  onTap: () async {
                    setState(() {
                      errorMessage = '';
                    });
                    if(_formKey.currentState.validate()) {
                      String uid = await DatabaseService().uidFromIdentifier(inputController.text);
                      if (uid.isNotEmpty) {
                        widget.callback([uid]);
                        inputController.text = '';
                      } else {
                        debug('No user found');
                        setState(() {
                          errorMessage = 'No user found, try again';
                        });
                      }
                    }
                  },
                  textColor: widget.prefs.color_background,
                ),
              ],
            ),
            SizedBox(height: 10),
            if(hasFriends) friends(),
          ],
        ),
      ),
      onAccept: () {
        widget.callback(checkboxes.entries.map((e) => e.key).where((element) => checkboxes[element]).toList());
        Navigator.pop(context);
      },
      onDeny: () {
        Navigator.pop(context);
      },
      acceptButton: 'Done',
      denyButton: 'Cancel',
    );
  }

  bool isEmail(String input) {
    if(input.contains('@')) return true;
    return false;
  }

}
