import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/services/ad_service.dart';
import 'package:wishtogether/services/auth_service.dart';
import 'package:wishtogether/ui/widgets/custom_buttons.dart';
import 'package:wishtogether/ui/widgets/custom_scaffold.dart';
import 'package:wishtogether/ui/widgets/custom_textfields.dart';

class ChangeEmailScreen extends StatefulWidget {

  UserPreferences prefs;

  ChangeEmailScreen(this.prefs);

  @override
  _ChangeEmailScreenState createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {

  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      prefs: widget.prefs,
      backButton: true,
      title: 'New email',
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
                multiline: false,
                validator: (val) =>  val.length < 6 ? 'Incorrect password.' : null,
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
                obscureText: true,
              ),
              SizedBox(height: 30),
              Text(
                '• New email',
                style: widget.prefs.text_style_sub_header,
              ),
              SizedBox(height: 5),
              customTextField(
                prefs: widget.prefs,
                multiline: false,
                validator: (val) =>  !(val.isNotEmpty && val.contains('@') && val.split('@')[1].contains('.')) ? 'Enter a valid email.' : null,
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
                email: true,
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
              var result = await auth.updateEmail(email, password);
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
