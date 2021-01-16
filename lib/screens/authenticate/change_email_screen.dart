import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/database/auth_service.dart';
import 'package:wishtogether/ui/widgets/custom_buttons.dart';
import 'package:wishtogether/ui/widgets/custom_textfields.dart';

class ChangeEmailScreen extends StatefulWidget {
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
                    'Enter your password',
                    style: textstyle_header,
                  ),
                  SizedBox(height: 5),
                  textField(
                      validator: (val) =>  val.length < 6 ? 'Incorrect password.' : null,
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                      obscureText: true,
                      textColor: color_text_dark,
                      activeColor: color_primary,
                      borderColor: color_text_dark_sub,
                      errorColor: color_text_error,
                      helperText: 'Password',
                      icon: Icon(Icons.lock, color: color_text_dark_sub),
                      textStyle: textstyle_subheader,
                      borderRadius: 30
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Enter new email',
                    style: textstyle_header,
                  ),
                  SizedBox(height: 5),
                  textField(
                      validator: (val) =>  !(val.isNotEmpty && val.contains('@') && val.split('@')[1].contains('.')) ? 'Enter a valid email.' : null,
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                      textColor: color_text_dark,
                      activeColor: color_primary,
                      borderColor: color_text_dark_sub,
                      errorColor: color_text_error,
                      helperText: 'New email',
                      icon: Icon(Icons.mail, color: color_text_dark_sub),
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
                          text: 'Change email',
                          textColor: color_text_light,
                          splashColor: color_splash_light,
                          fillColor: color_claim_green,
                          onTap: () async {
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
