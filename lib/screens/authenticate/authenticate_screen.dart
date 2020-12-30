import 'package:flutter/material.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/database/auth_service.dart';
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

    return Scaffold(
      body: StartupScaffold(
        appBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 70,),
            Icon(
              CustomIcons.wish_together,
              color: Colors.white,
              size: 70,
            ),
            Text(
              'Wish Together',
              style: textstyle_title,
            ),
          ],
        ),
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
      ),
    );
  }
}
