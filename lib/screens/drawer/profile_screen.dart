import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/ui/widgets/custom_buttons.dart';
import 'package:wishtogether/ui/widgets/user_dot.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {

    UserData currentUser = Provider.of<UserData>(context);
    if(currentUser == null) currentUser = UserData.empty();

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
                    onTap: () {},
                    text: 'Add friend',
                    textColor: color_text_light,
                    splashColor: color_splash_light,
                    fillColor: color_claim_green,
                  )
                ],
              )
            ],
          ),
        ),
      )
    );
  }
}
