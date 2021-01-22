import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/database/auth_service.dart';
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
    return Scaffold(
      body: SingleChildScrollView(
        child: StartupScaffold(
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
                        color: Colors.white,
                        size: 70,
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
                          icon: Icon(CustomIcons.back, color: color_text_light,),
                          iconSize: 30,
                        ),
                      ),

                    )
                  ]
              ),
              Center(
                child: Text(
                  'Wish Together',
                  style: textstyle_title,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 80),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        'Register',
                        style: textstyle_header,
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: textField(
                            validator: (val) => !(val.isNotEmpty && val.contains('@') && val.split('@')[1].contains('.')) ? 'Enter a valid email.' : null,
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            },
                            email: true,
                            textColor: color_text_dark,
                            activeColor: color_primary,
                            borderColor: color_text_dark_sub,
                            errorColor: color_text_error,
                            helperText: 'Email',
                            icon: Icon(Icons.mail, color: color_text_dark_sub),
                            textStyle: textstyle_subheader,
                            borderRadius: 30
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: textField(
                            validator: (val) =>  val.length < 6 ? 'Password must be atleast 6 characters long.' : null,
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
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: textField(
                            validator: (val) => password != val ? 'Passwords don\'t match.' : null,
                            onChanged: (val) {
                              setState(() {
                                confirm = val;
                              });
                            },
                            obscureText: true,
                            textColor: color_text_dark,
                            activeColor: color_primary,
                            borderColor: color_text_dark_sub,
                            errorColor: color_text_error,
                            helperText: 'Repeat Password',
                            icon: Icon(Icons.lock, color: color_text_dark_sub),
                            textStyle: textstyle_subheader,
                            borderRadius: 30
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
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
                    //SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: button(
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
                          text: 'Register',
                          textColor: color_text_dark,
                          borderColor: color_primary,
                          borderRadius: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
