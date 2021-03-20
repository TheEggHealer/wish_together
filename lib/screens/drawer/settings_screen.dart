import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/dialog/confirm_user_delete_dialog.dart';
import 'package:wishtogether/dialog/confirmation_dialog.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/services/ad_service.dart';
import 'package:wishtogether/services/auth_service.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/screens/authenticate/change_email_screen.dart';
import 'package:wishtogether/screens/authenticate/change_password_screen.dart';
import 'package:wishtogether/ui/custom_icons.dart';
import 'package:wishtogether/ui/widgets/custom_scaffold.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with WidgetsBindingObserver {

  bool loadedUserInfo = false;
  AuthService auth = AuthService();
  String userEmail = '';

  UserData user;
  bool userDeleted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void uploadChanges() {
    if(!userDeleted) {
      DatabaseService dbs = DatabaseService();
      dbs.uploadData(dbs.userData, user.uid, {'settings': user.settings});
    }
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

  Widget item({String title, Widget otherSide, Function onTap, bool warning = false, bool enabled = true, UserPreferences prefs}) {
    return ListTile(
      enabled: enabled,
      tileColor: Colors.transparent,
      onTap: onTap,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: !warning ? prefs.text_style_settings : prefs.text_style_settings_warning,
          ),
          if(otherSide != null) otherSide,
        ],
      ),
    );
  }

  Widget toggle({bool value, Function onChanged, UserPreferences prefs}) {
    return Switch(
      value: value,
      onChanged: (val) {
        HapticFeedback.lightImpact();
        onChanged(val);
      },
      focusColor: prefs.color_splash,
      hoverColor: prefs.color_splash,
      activeColor: prefs.color_primary,
      activeTrackColor: prefs.color_switch_track,
      inactiveThumbColor: prefs.color_bread,
      inactiveTrackColor: prefs.color_switch_track,
    );
  }

  Widget categoryOther(UserPreferences prefs) {
    DatabaseService dbs = DatabaseService();

    return Card(
      elevation: 5,
      color: prefs.color_card,
      child: Column(
        children: [
          item(
            prefs: prefs,
            title: 'Dark mode',
            otherSide: toggle(
              prefs: prefs,
              value: user.settings['dark_mode'] ?? false,
              onChanged: (value) {
                user.settings['dark_mode'] = value;
                setState(() {});
              },
            ),
            onTap: () {},
          ),
          item(
            prefs: prefs,
            title: 'Warn before chatting with wisher',
            otherSide: toggle(
              prefs: prefs,
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

  Widget categoryNotifications(UserPreferences prefs) {
    DatabaseService dbs = DatabaseService();

    return Card(
      elevation: 5,
      color: prefs.color_card,
      child: Column(
        children: [
          item(
            prefs: prefs,
            title: 'Friend request',
            otherSide: toggle(
              prefs: prefs,
              value: user.settings['notif_friend_request'] ?? false,
              onChanged: (value) {
                user.settings['notif_friend_request'] = value;
                setState(() {});
              },
            ),
            onTap: () {},
          ),
          item(
            prefs: prefs,
            title: 'Wishlist invitation',
            otherSide: toggle(
              prefs: prefs,
              value: user.settings['notif_wishlist_invitation'] ?? false,
              onChanged: (value) {
                user.settings['notif_wishlist_invitation'] = value;
                setState(() {});
              },
            ),
            onTap: () {},
          ),
          item(
            prefs: prefs,
            title: 'Changes to items you have claimed',
            otherSide: toggle(
              prefs: prefs,
              value: user.settings['notif_changes_to_items_you_have_claimed'] ?? false,
              onChanged: (value) {
                user.settings['notif_changes_to_items_you_have_claimed'] = value;
                setState(() {});
              },
            ),
            onTap: () {},
          ),
          item(
            prefs: prefs,
            title: 'Changes to items you wish for',
            otherSide: toggle(
              prefs: prefs,
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

  Widget categoryAccount(BuildContext context, UserPreferences prefs) {
    bool googleSignIn = auth.isSignedInWithGoogle;

    return Card(
      elevation: 5,
      color: prefs.color_card,
      child: Column(
        children: [
          item(
            prefs: prefs,
            title: 'Email',
            enabled: !googleSignIn,
            otherSide: Text(
              auth.getEmail(),
              style: prefs.text_style_settings,
            ),
            onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeEmailScreen(prefs)));
              setState(() {});
            },
          ),
          if(!googleSignIn) item(
            prefs: prefs,
            title: 'Password',
            onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordScreen(prefs)));
              setState(() {});
            },
          ),
          item(
            prefs: prefs,
            title: 'Logout',
            onTap: () async {
              await auth.signOut();
              Navigator.pop(context);
            },
          ),
          item(
            prefs: prefs,
            warning: true,
            title: 'Delete account',
            onTap: () async {
              String password = '';

              showDialog(context: context, builder: (context) => ConfirmUserDeleteDialog(
                prefs: prefs,
                currentUser: user,
                callback: () {
                  userDeleted = true;
                  Navigator.pop(context);
                },
              ));
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    user = Provider.of<UserData>(context) ?? UserData.empty();
    UserPreferences prefs = UserPreferences.from(user);

    return CustomScaffold(
      prefs: prefs,
      backButton: true,
      title: 'Settings',
      body: Column( //TODO Add padding for ad compatibility
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'General',
              style: prefs.text_style_sub_header,
            ),
          ),
          SizedBox(height: 5),
          categoryOther(prefs),
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'Notifications',
              style: prefs.text_style_sub_header,
            ),
          ),
          SizedBox(height: 5),
          categoryNotifications(prefs),
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'Account',
              style: prefs.text_style_sub_header,
            ),
          ),
          SizedBox(height: 5),
          categoryAccount(context, prefs),
          if(AdService.hasAds) SizedBox(height: AdService.adHeight),
        ],
      ),
    );
  }

}
