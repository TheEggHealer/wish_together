import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/dialog/add_friend_dialog.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/services/global_memory.dart';
import 'package:wishtogether/ui/widgets/custom_buttons.dart';
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
    if(currentUser == null) currentUser = UserData.empty();
    else if(friendsChanged()) loadFriends();

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
              style: textstyle_header,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: FloatingActionButton(
                  onPressed: () async {
                    //TODO Add warning window when removing friend!
                    if(user.friends.contains(currentUser.uid)) {
                      user.friends.remove(currentUser.uid);
                      await user.uploadData();
                    }
                    if(currentUser.friends.contains(user.uid)) {
                      currentUser.friends.remove(user.uid);
                      await currentUser.uploadData();
                    }
                  },
                  child: Icon(Icons.close),
                  mini: true,
                  backgroundColor: color_text_error,
                  splashColor: color_splash_light,
                  focusColor: color_splash_light,
                  hoverColor: color_splash_light,
                  foregroundColor: Colors.white,
                ),
              ),
            )
          ],
        ));
      }
    }

    return Scaffold(
      backgroundColor: color_background,
      appBar: AppBar(
        backgroundColor: color_primary,
        elevation: 10,
        title: Row(
          children: [
            Text(
              'Profile'
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Center(
                 child: UserDot.fromUserData(
                  userData: currentUser,
                  size: SIZE.PROFILE,
                )
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  currentUser.name,
                  style: textstyle_profile_name,
                ),
              ),
              SizedBox(height: 15),
              Divider(
                color: color_divider_dark,
                endIndent: 0,
                indent: 0,
              ),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    borderlessButton(
                        text: 'Change name',
                        splashColor: color_splash_dark,
                        onTap: () {},
                        textColor: color_text_dark
                    ),
                    VerticalDivider(
                      color: color_divider_dark,
                      width: 0,
                    ),
                    borderlessButton(
                        text: 'Change color',
                        splashColor: color_splash_dark,
                        onTap: () {},
                        textColor: color_text_dark
                    ),
                    VerticalDivider(
                      color: color_divider_dark,
                      width: 0,
                    ),
                    borderlessButton(
                        text: 'Change picture',
                        splashColor: color_splash_dark,
                        onTap: () {},
                        textColor: color_text_dark
                    ),
                  ],
                ),
              ),
              Divider(
                color: color_divider_dark,
                endIndent: 0,
                indent: 0,
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Friends',
                    style: textstyle_header,
                  ),
                  claimButton(
                    onTap: () async {
                      showDialog(context: context, builder: (context) => AddFriendDialog(currentUser));
                    },
                    text: 'Add friend',
                    textColor: color_text_light,
                    splashColor: color_splash_light,
                    fillColor: color_claim_green,
                  )
                ],
              ),
              SizedBox(height: 20),
              if(friends.isNotEmpty) Column(
                children: friends,
              )
            ],
          ),
        ),
      )
    );
  }
}
