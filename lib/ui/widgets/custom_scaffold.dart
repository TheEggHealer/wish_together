import 'package:flutter/material.dart';
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

  CustomScaffold({@required this.prefs, this.title, this.body, this.action, this.drawer, this.fab, this.backButton = false});

  @override
  _CustomScaffoldState createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          color: widget.prefs.color_background,
          padding: EdgeInsets.all(12),
          constraints: BoxConstraints(
            minHeight: height,
          ),
          child: Column(
            children: [
              SizedBox(height: 40),
              Row(
                children: [
                  if(widget.drawer != null) IconButton(
                    icon: Icon(
                      CustomIcons.drawer, //TODO ICON change to drawer icon and add splash
                      color: widget.prefs.color_primary,
                      size: 30,
                    ),
                    onPressed: () => _scaffoldKey.currentState.openDrawer(),
                  ),
                  if(widget.backButton) IconButton(
                    icon: Icon(
                      CustomIcons.back,
                      color: widget.prefs.color_primary,
                      size: 30,
                    ),
                    onPressed: () => Navigator.pop(context),
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
              SizedBox(height: 10),
              widget.body,
              if(widget.fab != null) SizedBox(height: 30), //Correcting for fab button
            ],
          ),
        ),
      ),
      drawer: widget.drawer,
      floatingActionButton: widget.fab,
    );
  }
}
