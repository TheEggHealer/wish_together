import 'package:flutter/material.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/ui/clippers/startup_clipper.dart';

class StartupScaffold extends StatefulWidget {
  @override
  _StartupScaffoldState createState() => _StartupScaffoldState();

  final Widget appBar;
  final Widget body;

  const StartupScaffold({Key key, this.appBar, this.body});

}

class _StartupScaffoldState extends State<StartupScaffold> {
  @override
  Widget build(BuildContext context) {

    StartupClipper clipper = StartupClipper();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double clipHeight = height * C_startup_scaffold_height;
    double padding = clipHeight - clipHeight * C_startup_scaffold_diff;

    UserPreferences prefs = UserPreferences(darkMode: false);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: width,
          constraints: BoxConstraints(
            minHeight: height,
          ),
          child: Stack(
            children: [
              Container(
                constraints: BoxConstraints(
                  minWidth: width,
                  minHeight: height,
                ),
                color: prefs.color_background,
                padding: EdgeInsets.only(top: padding),
                child: widget.body,
              ),
              ClipPath(
                clipper: clipper,
                child: Container(
                  width: double.infinity,
                  height: height * C_startup_scaffold_height,
                  decoration: BoxDecoration(
                    gradient: startup_scaffold_gradient,
                  ),
                  child: widget.appBar
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

