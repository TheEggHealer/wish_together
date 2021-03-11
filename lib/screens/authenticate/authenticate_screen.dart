import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/services/auth_service.dart';
import 'package:wishtogether/screens/authenticate/register_screen.dart';
import 'package:wishtogether/screens/authenticate/sign_in_screen.dart';
import 'package:wishtogether/ui/custom_icons.dart';
import 'package:wishtogether/ui/widgets/custom_buttons.dart';
import 'package:wishtogether/ui/widgets/startup_scaffold.dart';

class StartupScreen extends StatefulWidget {
  @override
  _StartupScreenState createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> with SingleTickerProviderStateMixin {

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
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

    AuthService _auth = AuthService();
    UserPreferences prefs = UserPreferences(darkMode: false);

    return StartupScaffold(
      appBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 70,),
          Icon(
            CustomIcons.wish_together,
            color: prefs.color_background,
            size: 80,
          ),
          Text(
            'Wish Together',
            style: prefs.text_style_wish_together,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100),
            Text(
              'Welcome,',
              style: prefs.text_style_sub_header,
            ),
            Text(
              'Sign in to continue',
              style: prefs.text_style_sub_sub_header
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: signInButton(
                text: 'Sign in with Google',
                textColor: prefs.color_bread,
                borderColor: prefs.color_primary,
                splashColor: prefs.color_splash,
                image: Image(image: AssetImage('assets/google_logo.png'), width: 22, height: 22),
                onTap: () async {
                  dynamic result = await _auth.signInGoogle();
                  if(result == null) {
                    print('error signing in');
                  } else {
                    print('signed in');
                    print(result.uid);
                  }
                },
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: signInButton(
                text: 'Sign in with email',
                textColor: prefs.color_bread,
                borderColor: prefs.color_primary,
                splashColor: prefs.color_splash,
                image: Icon(CustomIcons.invite, size: 24, color: prefs.color_primary),
                onTap: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
                },
              ),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: color_divider_dark,
                    endIndent: 10,
                    indent: 10,
                  ),
                ),
                Center(
                  child: Text(
                    'Or',
                    style: prefs.text_style_sub_sub_header,
                  ),
                ),
                Expanded(

                  child: Divider(
                    color: color_divider_dark,
                    indent: 10,
                    endIndent: 10,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: signInButton(
                text: 'Register with email',
                textColor: prefs.color_bread,
                borderColor: prefs.color_primary,
                splashColor: prefs.color_splash,
                onTap: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                },
              ),
            ),
          ],
        ),
      ),

      /*
      body: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 0.1),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Spacer(flex: 20),
              Expanded(
                flex: 10,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Welcome,',
                        style: textstyle_header,
                      ),
                      Text(
                        'Sign in to continue',
                        style: textstyle_subheader,
                      ),
                    ],
                  ),
                ),
              ),
              if(Platform.isIOS) Spacer(flex: 1),
              if(Platform.isIOS) Flexible(
                  flex: 10,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: SignInWithAppleButton(
                    borderRadius: BorderRadius.circular(30),
                    style: SignInWithAppleButtonStyle.black,
                    onPressed: () async {
                      dynamic result = await _auth.signInApple();
                    }
                  )
                )
              ),
              Spacer(flex: 1),
              Flexible(
                flex: 10,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: button(
                      onTap: () async {
                        dynamic result = await _auth.signInGoogle();
                        if(result == null) {
                          print('error signing in');
                        } else {
                          print('signed in');
                          print(result.uid);
                        }
                      },
                      image: Image(image: AssetImage('assets/google_logo.png'), width: 30, height: 30),
                      text: 'Sign in with Google',
                      textColor: color_text_dark,
                      borderColor: color_primary,
                      borderRadius: 30,
                    ),
                  ),
                ),
              ),
              Spacer(flex: 1),
              Flexible(
                flex: 10,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: button(
                      onTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
                      },
                      text: 'Sign in',
                      textColor: color_text_dark,
                      borderColor: color_primary,
                      borderRadius: 30,
                    ),
                  ),
                ),
              ),
              Spacer(flex: 1),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: color_divider_dark,
                      endIndent: 10,
                      indent: 20,
                    ),
                  ),
                  Center(
                    child: Text(
                      'Or',
                      style: textstyle_subheader,
                    ),
                  ),
                  Expanded(

                    child: Divider(
                      color: color_divider_dark,
                      indent: 10,
                      endIndent: 20,
                    ),
                  ),
                ],
              ),
              Spacer(flex: 1),
              Flexible(
                flex: 10,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: button(
                      onTap: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                      },
                      text: 'Register',
                      textColor: color_text_dark,
                      borderColor: color_primary,
                      borderRadius: 30,
                    ),
                  ),
                ),
              ),
              Spacer(flex: 10),
            ],
          ),
        ),
      ),
        */
    );
  }
}
