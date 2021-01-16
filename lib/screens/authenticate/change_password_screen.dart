import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/database/auth_service.dart';
import 'package:wishtogether/ui/widgets/custom_buttons.dart';
import 'package:wishtogether/ui/widgets/custom_textfields.dart';

class ChangePasswordScreen extends StatefulWidget {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color_primary,
        elevation: 10,
        title: Row(
          children: [
            Text(
                'Change email'
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: MediaQuery.of(context).viewInsets,
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Enter current password',
                    style: textstyle_header,
                  ),
                  SizedBox(height: 5),
                  textField(
                    validator: (val) =>  val.length < 6 ? 'Incorrect password.' : null,
                    onChanged: (val) {
                      setState(() {
                        oldPassword = val;
                      });
                    },
                    obscureText: true,
                    textColor: color_text_dark,
                    activeColor: color_primary,
                    borderColor: color_text_dark_sub,
                    errorColor: color_text_error,
                    helperText: 'Current password',
                    icon: Icon(Icons.lock, color: color_text_dark_sub),
                    textStyle: textstyle_subheader,
                    borderRadius: 30
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Enter new password',
                    style: textstyle_header,
                  ),
                  SizedBox(height: 5),
                  textField(
                      validator: (val) =>  val.length < 6 ? 'Password must be at least 6 characters long.' : null,
                      onChanged: (val) {
                        setState(() {
                          newPassword = val;
                        });
                      },
                      obscureText: true,
                      textColor: color_text_dark,
                      activeColor: color_primary,
                      borderColor: color_text_dark_sub,
                      errorColor: color_text_error,
                      helperText: 'New password',
                      icon: Icon(Icons.lock, color: color_text_dark_sub),
                      textStyle: textstyle_subheader,
                      borderRadius: 30
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Repeat password',
                    style: textstyle_header,
                  ),
                  SizedBox(height: 5),
                  textField(
                      validator: (val) =>  val != newPassword ? 'Passwords do not match.' : null,
                      onChanged: (val) {
                        setState(() {
                          newPasswordRepeat = val;
                        });
                      },
                      obscureText: true,
                      textColor: color_text_dark,
                      activeColor: color_primary,
                      borderColor: color_text_dark_sub,
                      errorColor: color_text_error,
                      helperText: 'Repeat new password',
                      icon: Icon(Icons.lock, color: color_text_dark_sub),
                      textStyle: textstyle_subheader,
                      borderRadius: 30
                  ),
                  SizedBox(height: 15),
                  SpinKitThreeBounce(
                    color: loading ? color_loading_spinner : Colors.transparent,
                    size: 20,
                  ),
                  Center(
                    child: Text(
                      error,
                      style: TextStyle(
                        fontFamily: 'RobotoLight',
                        color: color_text_error,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: claimButton(
                          text: 'Cancel',
                          textColor: color_text_light,
                          splashColor: color_splash_light,
                          fillColor: color_text_error,
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: claimButton(
                          text: 'Change password',
                          textColor: color_text_light,
                          splashColor: color_splash_light,
                          fillColor: color_claim_green,
                          onTap: () async {
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
                      )
                    ],
                  )
                ],
              ),
            )
        ),
      ),
    );
  }
}
