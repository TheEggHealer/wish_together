import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/services/ad_service.dart';
import 'package:wishtogether/services/auth_service.dart';
import 'package:wishtogether/ui/widgets/custom_buttons.dart';
import 'package:wishtogether/ui/widgets/custom_scaffold.dart';
import 'package:wishtogether/ui/widgets/custom_textfields.dart';

class ChangePasswordScreen extends StatefulWidget {

  UserPreferences prefs;

  ChangePasswordScreen(this.prefs);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  String oldPassword = '';
  String newPassword = '';
  String newPasswordRepeat = '';
  String error = '';
  bool loading = false;

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      prefs: widget.prefs,
      backButton: true,
      title: 'New password',
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              Text(
                '• Current password',
                style: widget.prefs.text_style_sub_header,
              ),
              SizedBox(height: 5),
              customTextField(
                prefs: widget.prefs,
                validator: (val) =>  val.length < 6 ? 'Incorrect password.' : null,
                onChanged: (val) {
                  setState(() {
                    oldPassword = val;
                  });
                },
                obscureText: true,
              ),
              SizedBox(height: 30),
              Text(
                '• New password',
                style: widget.prefs.text_style_sub_header,
              ),
              SizedBox(height: 5),
              customTextField(
                prefs: widget.prefs,
                validator: (val) =>  val.length < 6 ? 'Password must be at least 6 characters long.' : null,
                onChanged: (val) {
                  setState(() {
                    newPassword = val;
                  });
                },
                obscureText: true,
              ),
              SizedBox(height: 30),
              Text(
                '• Repeat password',
                style: widget.prefs.text_style_sub_header,
              ),
              SizedBox(height: 5),
              customTextField(
                prefs: widget.prefs,
                validator: (val) =>  val != newPassword ? 'Passwords do not match.' : null,
                onChanged: (val) {
                  setState(() {
                    newPasswordRepeat = val;
                  });
                },
                obscureText: true,
              ),
              SizedBox(height: 15),
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
            ],
          ),
        )
      ),
      fab: Padding(
        padding: EdgeInsets.only(bottom: AdService.adHeight),
        child: FloatingActionButton(
          backgroundColor: widget.prefs.color_primary,
          splashColor: widget.prefs.color_splash,
          hoverColor: widget.prefs.color_splash,
          focusColor: widget.prefs.color_splash,
          child: Icon(
            Icons.check,
            color: widget.prefs.color_background,
            size: 40,
          ),
          onPressed: () async {
            if(_formKey.currentState.validate()) {
              setState(() {
                loading = true;
              });
              AuthService auth = AuthService();
              var result = await auth.updatePassword(oldPassword, newPassword);
              if(result is String) {
                setState(() {
                  error = result;
                  loading = false;
                });
              } else {
                Navigator.pop(context);
              }
            }
          },
        ),
      ),
    );
  }
}
