import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/dialog/custom_dialog.dart';
import 'package:wishtogether/models/notification_model.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/services/global_memory.dart';
import 'package:wishtogether/services/invitation_service.dart';
import 'package:wishtogether/services/notification_service.dart';
import 'package:wishtogether/ui/custom_icons.dart';
import 'package:wishtogether/ui/widgets/custom_buttons.dart';
import 'package:wishtogether/ui/widgets/custom_textfields.dart';

class AddFriendDialog extends StatefulWidget {

  UserPreferences prefs;
  UserData currentUser;

  AddFriendDialog(this.currentUser, this.prefs);

  @override
  _AddFriendDialogState createState() => _AddFriendDialogState();
}

class _AddFriendDialogState extends State<AddFriendDialog> {

  String _input = '';
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      prefs: widget.prefs,
      title: 'Send friend request',
      icon: CustomIcons.invite,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            customTextField(
              prefs: widget.prefs,
              multiline: false,
              validator: (val) => isValid(val) ? null : 'Not a valid email or friend code',
              onChanged: (val) {
                this._input = val;
              },
              helperText: 'Email or friend code',
            ),
            SizedBox(height: 10),
            if(loading) SpinKitChasingDots(
              size: 20,
              color: widget.prefs.color_spinner,
            ) else SizedBox(height: 20),
            Text(
              errorMessage,
              style: widget.prefs.text_style_error,
            )
          ],
        ),
      ),
      acceptButton: 'Send',
      denyButton: 'Cancel',
      onAccept: () async {
        if(_formKey.currentState.validate()) {
          setState(() {
            loading = true;
          });
          bool result = await sendFriendRequest();

          if(!result) {
            setState(() {
              loading = false;
              errorMessage = 'Could not find user.';
            });
          }
          else {
            errorMessage = '';
            Navigator.pop(context);
          }
        }
      },
      onDeny: () {
        Navigator.pop(context);
      },
    );
  }

  Future<bool> sendFriendRequest() async {
    InvitationService invitation = InvitationService();
    DatabaseService dbs = DatabaseService();
    return await invitation.sendFriendRequest(widget.currentUser.uid, await dbs.uidFromIdentifier(_input.toUpperCase()));
  }

  bool isValid(String input) {
    DatabaseService dbs = DatabaseService();
    return dbs.getIdentifierType(input.toUpperCase()) != 0;
  }

}
