
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:path/path.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/user_preferences.dart';

class VersionWidget extends StatefulWidget {

  UserPreferences prefs;

  VersionWidget({this.prefs});

  @override
  _VersionWidgetState createState() => _VersionWidgetState();
}

class _VersionWidgetState extends State<VersionWidget> {

  String versionNumber;
  String buildDate;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    PackageInfo info = await PackageInfo.fromPlatform();

    versionNumber = '${info.version} (${info.buildNumber})';
    buildDate = '2021-03-18'; //TODO Update for releases

    debug('Loaded info!!!!!!!!!!!!!!!!!!!!!!!!!! ${info.version}');

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
            'Build number: $versionNumber', //TODO load from yaml
            style: widget.prefs.text_style_tiny
        ),
        Text(
            'Build date: $buildDate', //TODO load from yaml
            style: widget.prefs.text_style_tiny
        ),
      ],
    );
  }
}