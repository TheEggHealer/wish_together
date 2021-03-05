import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/dialog/custom_dialog.dart';
import 'package:wishtogether/models/notification_model.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/services/global_memory.dart';
import 'package:wishtogether/services/invitation_service.dart';
import 'package:wishtogether/services/notification_service.dart';
import 'package:wishtogether/ui/custom_icons.dart';
import 'package:wishtogether/ui/widgets/custom_buttons.dart';
import 'package:wishtogether/ui/widgets/custom_textfields.dart';

class AddFriendDialog extends StatefulWidget {

  UserData currentUser;

  AddFriendDialog(this.currentUser);

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
      title: 'Send friend request',
      icon: CustomIcons.wish_together,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            SizedBox(height: 10),
            if(loading) SpinKitChasingDots(
              size: 20,
              color: color_loading_spinner,
            ) else SizedBox(height: 20),
            Text(
              errorMessage,
              style: textstyle_list_title_warning,
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
    return await invitation.sendFriendRequestToEmail(widget.currentUser.uid, _input);
  }

  bool isEmail(String input) {
    if(input.contains('@')) return true;
    return false;
  }

}
