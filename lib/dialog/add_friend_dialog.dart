import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/notification_model.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/services/global_memory.dart';
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Send friend request'),
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              'Enter email or friend code',
              style: textstyle_header,
            ),
            textField(
              onChanged: (val) {
                this._input = val;
              },
              validator: (val) =>  val.length < 6 ? 'Wrong input' : null, //TODO Fix message
              textColor: color_text_dark,
              activeColor: color_primary,
              borderColor: color_text_dark_sub,
              errorColor: color_text_error,
              helperText: 'Email or friend code',
              icon: Icon(CustomIcons.profile, color: color_text_dark_sub),
              textStyle: textstyle_subheader,
              borderRadius: 30
            )
          ],
        ),
      ),
      actions: [
        claimButton(
          text: 'Cancel',
          fillColor: color_text_error,
          onTap: () {
            Navigator.pop(context);
          },
          splashColor: color_splash_light,
          textColor: color_text_light,
        ),
        claimButton(
          text: 'Send',
          fillColor: color_claim_green,
          onTap: () async {
            if(_formKey.currentState.validate()) {
              await sendFriendRequest();
              Navigator.pop(context);
            }
          },
          splashColor: color_splash_light,
          textColor: color_text_light,
        ),
      ],
    );
  }

  Future<void> sendFriendRequest() async {
    /* Upload invite to reciever's database */
    DatabaseService dbs = DatabaseService();
    String date = DateFormat('HH.mm-dd/MM/yy').format(await NTP.now());
    String recieverUID = isEmail(_input) ? await dbs.uidFromEmail(_input) : ''; //TODO Fix for friend code
    UserData reciever = await GlobalMemory.getUserData(recieverUID);
    NotificationModel notification = NotificationModel(raw: 'fr:$date:${widget.currentUser.uid}:0');
    reciever.notifications.add(notification);
    await reciever.uploadData();

    /* Send notification to reveiver's devices */
    NotificationService ns = NotificationService();
    await ns.sendFriendRequestNotificationTo(recieverUID);
  }

  bool isEmail(String input) {
    if(input.contains('@')) return true;
    return false;
  }

}
