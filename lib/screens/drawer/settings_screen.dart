import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/services/auth_service.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/screens/authenticate/change_email_screen.dart';
import 'package:wishtogether/screens/authenticate/change_password_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with WidgetsBindingObserver {

  bool loadedUserInfo = false;
  AuthService auth = AuthService();
  String userEmail = '';

  UserData user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void uploadChanges() {
    DatabaseService dbs = DatabaseService();
    dbs.uploadData(dbs.userData, user.uid, {'settings': user.settings});
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    uploadChanges();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.paused) uploadChanges();
  }

  Widget item({String title, Widget otherSide, Function onTap, bool warning = false, bool enabled = true}) {
    return ListTile(
      enabled: enabled,
      tileColor: enabled ? Colors.transparent : color_card_disabled,
      onTap: onTap,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: !warning ? textstyle_list_title : textstyle_list_title_warning,
          ),
          if(otherSide != null) otherSide,
        ],
      ),
    );
  }

  Widget toggle({bool value, Function onChanged}) {
    return Switch(
      value: value,
      onChanged: onChanged,
      focusColor: color_splash_light,
      hoverColor: color_splash_light,
      activeColor: color_primary,
      activeTrackColor: color_splash_dark,
      inactiveThumbColor: color_text_dark,
      inactiveTrackColor: color_splash_dark,
    );
  }

  Widget categoryOther() {
    DatabaseService dbs = DatabaseService();

    return Card(
      elevation: 10,
      color: color_card_background,
      child: Column(
        children: [
          item(
            title: 'Warn before chatting with wisher',
            otherSide: toggle(
              value: user.settings['warn_before_chatting_with_wisher'] ?? false,
              onChanged: (value) {
                user.settings['warn_before_chatting_with_wisher'] = value;
                setState(() {});
              },
            ),
            onTap: () {},
          )
        ],
      ),
    );
  }

  Widget categoryNotifications() {
    DatabaseService dbs = DatabaseService();

    return Card(
      elevation: 10,
      color: color_card_background,
      child: Column(
        children: [
          item(
            title: 'Friend request',
            otherSide: toggle(
              value: user.settings['notif_friend_request'] ?? false,
              onChanged: (value) {
                user.settings['notif_friend_request'] = value;
                setState(() {});
              },
            ),
            onTap: () {},
          ),
          item(
            title: 'Wishlist invitation',
            otherSide: toggle(
              value: user.settings['notif_wishlist_invitation'] ?? false,
              onChanged: (value) {
                user.settings['notif_wishlist_invitation'] = value;
                setState(() {});
              },
            ),
            onTap: () {},
          ),
          item(
            title: 'Changes to items you have claimed',
            otherSide: toggle(
              value: user.settings['notif_changes_to_items_you_have_claimed'] ?? false,
              onChanged: (value) {
                user.settings['notif_changes_to_items_you_have_claimed'] = value;
                setState(() {});
              },
            ),
            onTap: () {},
          ),
          item(
            title: 'Changes to items you wish for',
            otherSide: toggle(
              value: user.settings['notif_changes_to_items_you_wish_for'] ?? false,
              onChanged: (value) {
                user.settings['notif_changes_to_items_you_wish_for'] = value;
                setState(() {});
              },
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget categoryAccount(BuildContext context) {
    bool googleSignIn = auth.isSignedInWithGoogle;

    return Card(
      elevation: 10,
      color: color_card_background,
      child: Column(
        children: [
          item(
            title: 'Email',
            enabled: !googleSignIn,
            otherSide: Text(
              auth.getEmail(),
              style: textstyle_card_dark_sub,
            ),
            onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeEmailScreen()));
              setState(() {});
            },
          ),
          if(!googleSignIn) item(
            title: 'Password',
            onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordScreen()));
              setState(() {});
            },
          ),
          item(
            title: 'Logout',
            onTap: () async {
              await auth.signOut();
              Navigator.pop(context);
            },
          ),
          item(
            warning: true,
            title: 'Delete account',
            onTap: () {},
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    user = Provider.of<UserData>(context) ?? UserData.empty();

    return Scaffold(
      backgroundColor: color_background,
      appBar: AppBar(
        backgroundColor: color_primary,
        elevation: 10,
        title: Row(
          children: [
            Text(
              'Settings'
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            categoryOther(),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Notifications',
                style: textstyle_header,
              ),
            ),
            SizedBox(height: 5),
            categoryNotifications(),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Account',
                style: textstyle_header,
              ),
            ),
            SizedBox(height: 5),
            categoryAccount(context),
          ],
        ),
      ),
    );
  }

}
