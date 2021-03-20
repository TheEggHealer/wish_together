import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/ui/custom_icons.dart';

class CustomScaffold extends StatefulWidget {

  final UserPreferences prefs;
  final String title;
  final Widget body;
  final Drawer drawer;
  final Widget fab;
  final Widget action;
  final bool backButton;
  final bool padding;
  final Function backButtonCallback;

  CustomScaffold({@required this.prefs, this.title, this.body, this.action, this.drawer, this.fab, this.backButton = false, this.padding = true, this.backButtonCallback});

  @override
  _CustomScaffoldState createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    EdgeInsets padding = widget.padding ? EdgeInsets.all(6) : EdgeInsets.zero;

    return Scaffold(
      key: _scaffoldKey,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: widget.prefs.darkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        child: SingleChildScrollView(
          child: Container(
            color: widget.prefs.color_background,
            padding: padding,
            constraints: BoxConstraints(
              minHeight: height,
            ),
            child: Column(
              children: [
                SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.only(top: 12, left: 12, right: 12),
                  child: Row(
                    children: [
                      if(widget.drawer != null) Material(
                        child: IconButton(
                          icon: Icon(
                            CustomIcons.drawer,
                            color: widget.prefs.color_primary,
                            size: 30,
                          ),
                          splashRadius: 24,
                          splashColor: widget.prefs.color_splash,
                          focusColor: widget.prefs.color_splash,
                          hoverColor: widget.prefs.color_splash,
                          highlightColor: widget.prefs.color_splash,
                          onPressed: () => _scaffoldKey.currentState.openDrawer(),
                        ),
                      ),
                      if(widget.backButton) Material(
                        child: IconButton(
                          icon: Icon(
                            CustomIcons.back,
                            color: widget.prefs.color_primary,
                            size: 30,
                          ),
                          splashRadius: 24,
                          splashColor: widget.prefs.color_splash,
                          focusColor: widget.prefs.color_splash,
                          hoverColor: widget.prefs.color_splash,
                          highlightColor: widget.prefs.color_splash,
                          onPressed: widget.backButtonCallback ?? () => Navigator.pop(context),
                        ),
                      ),
                      if(widget.drawer != null) SizedBox(width: 5),
                      if(widget.backButton) SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: widget.prefs.text_style_header,
                        ),
                      ),
                      if(widget.action != null) widget.action,
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: padding,
                  child: widget.body,
                ),
                if(widget.fab != null) SizedBox(height: 30), //Correcting for fab button
              ],
            ),
          ),
        ),
      ),
      drawer: widget.drawer,
      floatingActionButton: widget.fab,
    );
  }
}
