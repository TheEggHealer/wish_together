import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/services/ad_service.dart';
import 'package:wishtogether/services/auth_service.dart';
import 'package:wishtogether/ui/custom_icons.dart';
import 'package:wishtogether/ui/widgets/custom_buttons.dart';
import 'package:wishtogether/ui/widgets/custom_textfields.dart';
import 'package:wishtogether/ui/widgets/startup_scaffold.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {

  String email, password, confirm;
  String error = '';

  bool loading = false;

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500)
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    UserPreferences prefs = UserPreferences(darkMode: false);

    return StartupScaffold(
      appBar: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 70,),
          Stack(
              children: [
                Center(
                  child: Icon(
                    CustomIcons.wish_together,
                    color: prefs.color_background,
                    size: 80,
                  ),
                ),
                SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(-1, 0),
                    end: Offset(0, 0),
                  ).animate(CurvedAnimation(
                    parent: _controller,
                    curve: Curves.ease,
                  )),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: Icon(CustomIcons.back, color: prefs.color_background,),
                      iconSize: 30,
                    ),
                  ),

                )
              ]
          ),
          Center(
            child: Text(
              'Wish Together',
              style: prefs.text_style_wish_together,
            ),
          ),
        ],
      ),
      body: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 0.2),
          end: Offset(0, 0),
        ).animate(CurvedAnimation(
            parent: _controller,
            curve: Curves.ease
        )),
        child: FadeTransition(
          opacity: Tween<double>(
            begin: 0,
            end: 1,
          ).animate(CurvedAnimation(
            parent: _controller,
            curve: Curves.ease,
          )),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 80),
                  Text(
                    '• Email',
                    style: prefs.text_style_sub_header,
                  ),
                  SizedBox(height: 5),
                  customTextField(
                    email: true,
                    validator: (val) =>  !(val.isNotEmpty && val.contains('@') && val.split('@')[1].contains('.')) ? 'Enter a valid email.' : null,
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                    prefs: prefs,
                  ),
                  SizedBox(height: 10),
                  Text(
                    '• Password',
                    style: prefs.text_style_sub_header,
                  ),
                  SizedBox(height: 5),
                  customTextField(
                    obscureText: true,
                    validator: (val) =>  val.length < 6 ? 'Password must be atleast 6 characters long.' : null,
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                    prefs: prefs,
                  ),
                  SizedBox(height: 10),
                  Text(
                    '• Repeat password',
                    style: prefs.text_style_sub_header,
                  ),
                  SizedBox(height: 5),
                  customTextField(
                    obscureText: true,
                    validator: (val) => password != val ? 'Passwords don\'t match.' : null,
                    onChanged: (val) {
                      setState(() {
                        confirm = val;
                      });
                    },
                    prefs: prefs,
                  ),
                  SizedBox(height: 10,),
                  SpinKitThreeBounce(
                    color: loading ? prefs.color_spinner : Colors.transparent,
                    size: 20,
                  ),
                  Center(
                    child: Text(
                      error,
                      style: prefs.text_style_error,
                    ),
                  ),
                  SizedBox(height: 10,),
                  signInButton(
                    text: 'Register',
                    borderColor: prefs.color_primary,
                    splashColor: prefs.color_splash,
                    textColor: prefs.color_bread,
                    onTap: () async {
                      if(_formKey.currentState.validate()) {
                        setState(() => loading = true);
                        dynamic result = await _auth.registerEmailPassword(email, password);
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
                  SizedBox(height: 40),
                  if(AdService.hasAds) SizedBox(height: AdService.adHeight),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
