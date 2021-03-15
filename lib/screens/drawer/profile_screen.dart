import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/dialog/add_friend_dialog.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/services/global_memory.dart';
import 'package:wishtogether/ui/custom_icons.dart';
import 'package:wishtogether/ui/widgets/custom_buttons.dart';
import 'package:wishtogether/ui/widgets/custom_scaffold.dart';
import 'package:wishtogether/ui/widgets/user_dot.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  UserData currentUser;
  List<UserData> loadedFriends = [];

  void loadFriends() async {
    loadedFriends = [];
    for(String uid in currentUser.friends) {
      loadedFriends.add(await GlobalMemory.getUserData(uid));
    }
    setState(() {});
  }

  bool friendsChanged() {
    List<String> uids = loadedFriends.map((e) => e.uid).toList();

    if(uids.length != currentUser.friends.length) return true;

    currentUser.friends.forEach((element) {
      if(!uids.contains(element)) return true;
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {

    currentUser = Provider.of<UserData>(context);
    UserPreferences prefs = UserPreferences.from(currentUser);
    if(currentUser == null) currentUser = UserData.empty();
    else if(friendsChanged()) loadFriends();

    double width = MediaQuery.of(context).size.width;
    double buttonWidth = width / 4;

    List<Widget> friends = [];

    if(loadedFriends.isNotEmpty) {
      for(UserData user in loadedFriends) {
        friends.add(Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            UserDot.fromUserData(userData: user, size: SIZE.MEDIUM,),
            SizedBox(width: 10,),
            Text(
              user.name,
              style: prefs.text_style_sub_sub_header,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: circleButton(
                  onTap: () async {
                    //TODO Add warning dialog when removing friend!
                    if(user.friends.contains(currentUser.uid)) {
                      user.friends.remove(currentUser.uid);
                      await user.uploadData();
                    }
                    if(currentUser.friends.contains(user.uid)) {
                      currentUser.friends.remove(user.uid);
                      await currentUser.uploadData();
                    }
                  },
                  icon: Icon(Icons.close, color: prefs.color_background, size: 18),
                  fillColor: prefs.color_deny,
                  splashColor: prefs.color_splash,
                ),
              ),
            )
          ],
        ));
      }
    }

    return CustomScaffold(
      prefs: prefs,
      backButton: true,
      title: 'Profile',
      body: Container(
        padding: EdgeInsets.all(16), //TODO check padding (Ad compatible?)
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
               child: UserDot.fromUserData(
                userData: currentUser,
                size: SIZE.PROFILE,
              )
            ),
            SizedBox(height: 5),
            Center(
              child: Text(
                currentUser.name,
                style: prefs.text_style_wisher,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Icon(
                        CustomIcons.camera,
                        color: prefs.color_icon,
                        size: 20,
                      ),
                      SizedBox(height: 5),
                      customButton(
                        width: buttonWidth,
                        onTap: () {},
                        text: 'Picture',
                        textColor: prefs.color_background,
                        fillColor: prefs.color_accept,
                        splashColor: prefs.color_splash
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Icon(
                        CustomIcons.profile,
                        color: prefs.color_icon,
                        size: 20,
                      ),
                      SizedBox(height: 5),
                      customButton(
                        width: buttonWidth,
                        onTap: () {},
                        text: 'Name',
                        textColor: prefs.color_background,
                        fillColor: prefs.color_accept,
                        splashColor: prefs.color_splash
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Icon(
                        CustomIcons.color_picker,
                        color: prefs.color_icon,
                        size: 20,
                      ),
                      SizedBox(height: 5),
                      customButton(
                        width: buttonWidth,
                        onTap: () {},
                        text: 'Color',
                        textColor: prefs.color_background,
                        fillColor: prefs.color_accept,
                        splashColor: prefs.color_splash
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Divider(
              color: prefs.color_divider,
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Friends',
                  style: prefs.text_style_sub_header,
                ),
                customButton(
                  onTap: () async {
                    showDialog(context: context, builder: (context) => AddFriendDialog(currentUser, prefs));
                  },
                  text: 'Add friend',
                  textColor: prefs.color_background,
                  splashColor: prefs.color_splash,
                  fillColor: prefs.color_accept,
                )
              ],
            ),
            SizedBox(height: 20),
            if(friends.isNotEmpty) Column(
              children: friends,
            )
          ],
        ),
      )
    );
  }
}
