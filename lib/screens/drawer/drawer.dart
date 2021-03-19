import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/screens/drawer/help_screen.dart';
import 'package:wishtogether/screens/drawer/profile_screen.dart';
import 'package:wishtogether/screens/drawer/settings_screen.dart';
import 'package:wishtogether/services/auth_service.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/ui/custom_icons.dart';
import 'package:wishtogether/ui/widgets/notification_bell.dart';
import 'package:wishtogether/ui/widgets/user_dot.dart';
import 'package:wishtogether/ui/widgets/version_widget.dart';

class HomeDrawer {

  static Widget drawer(BuildContext context, AuthService auth, UserData userData, Function onLeave) {
    UserPreferences prefs = UserPreferences.from(userData);

    return Drawer(
      child: Container(
        color: prefs.color_background,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Container(
                padding: EdgeInsets.only(bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    UserDot.fromUserData(userData: userData, size: SIZE.LARGE),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            userData.name,
                            style: prefs.text_style_drawer_header
                        ),
                        NotificationBell(userData: userData,),
                      ],
                    )
                  ],
                ),
              ),
              decoration: BoxDecoration(
                  color: prefs.color_drawer_top
              ),
            ),
            ListTile(
              hoverColor: prefs.color_splash,
              focusColor: prefs.color_splash,
              title: Row(
                children: [
                  Icon(
                    CustomIcons.profile,
                    color: prefs.color_icon,
                  ),
                  SizedBox(width: 10),
                  Text('Profile', style: prefs.text_style_drawer_list),
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<UserData>.value(
                  value: DatabaseService(uid: userData.uid).userDocument,
                  child: ProfileScreen(),
                )));
              }
            ),
            ListTile(
              hoverColor: prefs.color_splash,
              focusColor: prefs.color_splash,
              title: Row(
                children: [
                  Icon(
                    CustomIcons.settings,
                    color: prefs.color_icon,
                  ),
                  SizedBox(width: 10),
                  Text('Settings', style: prefs.text_style_drawer_list),
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<UserData>.value(
                  value: DatabaseService(uid: userData.uid).userDocument,
                  child: SettingsScreen(),
                )));
              }
            ),
            ListTile(
              hoverColor: prefs.color_splash,
              focusColor: prefs.color_splash,
              title: Row(
                children: [
                  Icon(
                    CustomIcons.help,
                    color: prefs.color_icon,
                  ),
                  SizedBox(width: 10),
                  Text('Help', style: prefs.text_style_drawer_list),
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<UserData>.value(
                  value: DatabaseService(uid: userData.uid).userDocument,
                  child: HelpScreen(initScreen: 1,),
                )));
              }
            ),
            ListTile(
              hoverColor: prefs.color_splash,
              focusColor: prefs.color_splash,
              title: Row(
                children: [
                  Icon(
                    CustomIcons.logout,
                    color: prefs.color_icon,
                  ),
                  SizedBox(width: 10),
                  Text('Logout', style: prefs.text_style_drawer_list),
                ],
              ),
              onTap: onLeave,
            ),
            SizedBox(height: 60),
            Center(
              child: Column(
                children: [
                  Icon(
                    CustomIcons.wish_together,
                    color: prefs.color_drawer_logo,
                    size: 100,
                  ),
                  Text(
                      'Wish Together',
                      style: prefs.text_style_bread
                  ),
                  SizedBox(height: 10),
                  VersionWidget(prefs: prefs,),
                  SizedBox(height: 5),
                  Text(
                      '© Copyright Jonathan Runeke 2021',
                      style: prefs.text_style_tiny
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
