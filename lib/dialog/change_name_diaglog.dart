import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_preferences.dart';

import 'package:wishtogether/ui/custom_icons.dart';
import 'package:wishtogether/ui/widgets/custom_textfields.dart';
import '../services/global_memory.dart';
import 'custom_dialog.dart';

class ChangeNameDialog extends StatefulWidget {

  UserPreferences prefs;
  UserData currentUser;

  ChangeNameDialog({this.prefs, this.currentUser});

  @override
  _ChangeNameDialogState createState() => _ChangeNameDialogState();
}

class _ChangeNameDialogState extends State<ChangeNameDialog> {

  String _input = '';
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      prefs: widget.prefs,
      title: 'Change name',
      icon: CustomIcons.profile,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            customTextField(
              prefs: widget.prefs,
              multiline: false,
              validator: (val) => validate(val),
              onChanged: (val) {
                this._input = val;
              },
              helperText: 'New name',
            ),
            SizedBox(height: 10),
            if(loading) SpinKitChasingDots(
              size: 20,
              color: widget.prefs.color_spinner,
            ) else SizedBox(height: 20),
          ]
        ),
      ),
      acceptButton: 'Done',
      denyButton: 'Cancel',
      onAccept: () async {
        if(_formKey.currentState.validate()) {
          setState(() {loading = true;});
          widget.currentUser.name = _input;
          await widget.currentUser.uploadData();
          await GlobalMemory.getUserData(widget.currentUser.uid, forceFetch: true);
          Navigator.pop(context);
        }
      },
      onDeny: () {
        Navigator.pop(context);
      },
    );
  }

  String validate(String input) {
    if(input.isEmpty) return 'Name cannot be empty.';
    else if(input.length > 18) return 'Maximum 18 letters.';
    return null;
  }

}
