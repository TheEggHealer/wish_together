import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wishtogether/dialog/custom_dialog.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/services/auth_service.dart';
import 'package:wishtogether/ui/custom_icons.dart';
import 'package:wishtogether/ui/widgets/custom_textfields.dart';

class ConfirmUserDeleteDialog extends StatefulWidget {

  UserData currentUser;
  UserPreferences prefs;
  Function callback;

  ConfirmUserDeleteDialog({this.prefs, this.currentUser, this.callback});

  @override
  _ConfirmUserDeleteDialogState createState() => _ConfirmUserDeleteDialogState();
}

class _ConfirmUserDeleteDialogState extends State<ConfirmUserDeleteDialog> {

  final _formKey = GlobalKey<FormState>();
  String input = '';
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      prefs: widget.prefs,
      icon: CustomIcons.warning,
      title: 'Delete account',
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              'Deleting this account cannot be reversed. All your wishlists will '
                  'be removed, and you will leave wishlists that you are part of. '
                  'All your data will be permanently removed. Enter your password '
                  'to confirm.',
              style: widget.prefs.text_style_bread,
            ),
            SizedBox(height: 10),
            customTextField(
              prefs: widget.prefs,
              obscureText: true,
              helperText: 'Password',
              validator: (val) => val.length < 6 ? 'Incorrect password.' : null,
              onChanged: (val) => setState(() {this.input = val;}),
            ),
            SizedBox(height: 5),
            SpinKitThreeBounce(
              color: loading ? widget.prefs.color_spinner : Colors.transparent,
              size: 20,
            ),
            Center(
              child: Text(
                error,
                style: widget.prefs.text_style_error,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      acceptButton: 'Confirm',
      denyButton: 'Cancel',
      onAccept: () async {
        if(_formKey.currentState.validate()) {
          setState(() {
            loading = true;
          });
          AuthService auth = AuthService();
          var result = await auth.deleteLoggedInUser(widget.currentUser, input);
          if(result is String) {
            setState(() {
              error = result;
              loading = false;
            });
          } else {
            await auth.signOut();
            Navigator.pop(context);
            widget.callback();
          }
        }
      },
      onDeny: () {

        Navigator.pop(context);
      },
    );
  }
}
