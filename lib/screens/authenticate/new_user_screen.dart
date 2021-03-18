import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/dialog/color_picker_dialog.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/services/ad_service.dart';
import 'package:wishtogether/services/auth_service.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/services/image_service.dart';
import 'package:wishtogether/services/invitation_service.dart';
import 'package:wishtogether/ui/widgets/color_chooser_square.dart';
import 'package:wishtogether/ui/widgets/custom_buttons.dart';
import 'package:wishtogether/ui/widgets/custom_scaffold.dart';
import 'package:wishtogether/ui/widgets/custom_textfields.dart';
import 'package:wishtogether/ui/widgets/empty_list.dart';

class NewUserScreen extends StatefulWidget {
  @override
  _NewUserScreenState createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {

  AuthService _auth = AuthService();
  TextEditingController nameController = TextEditingController();
  Color color = Colors.green[300];
  File image;
  bool loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  String validateName(String input) {
    if(input.isEmpty) return 'Name cannot be empty.';
    else if(input.length > 18) return 'Maximum 18 letters.';
    return null;
  }

  Future onDone(UserData currentUser) async {
    setState(() {loading = true;});

    DatabaseService dbs = DatabaseService();
    ImageService imageService = ImageService();
    String imageURL = '';
    if(image != null) imageURL = await imageService.uploadImage(image);

    currentUser.firstTime = false;
    currentUser.name = nameController.text;
    currentUser.userColor = color;
    currentUser.profilePictureURL = imageURL;
    currentUser.settings = {
      'dark_mode': false,
      'notif_changes_to_items_you_have_claimed': true,
      'notif_changes_to_items_you_wish_for': true,
      'notif_friend_request': true,
      'notif_wishlist_invitation': true,
      'warn_before_chatting_with_wisher': true,
    };

    String friendCode = await InvitationService().createUniqueFriendCode();
    await dbs.mapFriendCode(friendCode, currentUser.uid);
    currentUser.friendCode = friendCode;

    await currentUser.uploadData();
  }

  @override
  Widget build(BuildContext context) {
    UserPreferences prefs = UserPreferences(darkMode: false);
    UserData currentUser = Provider.of<UserData>(context);

    Size size = MediaQuery.of(context).size;

    return CustomScaffold(
      prefs: prefs,
      title: 'New User',
      backButton: true,
      backButtonCallback: () async {
        debug('signing out');
        await _auth.signOut();
      },
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• Name',
                style: prefs.text_style_sub_header,
              ),
              SizedBox(height: 5),
              customTextField(
                validator: validateName,
                prefs: prefs,
                multiline: false,
                controller: nameController,
              ),
              SizedBox(height: 20),
              Text(
                '• User Color',
                style: prefs.text_style_sub_header,
              ),
              SizedBox(height: 5),
              ColorChooserSquare(
                prefs: prefs,
                color: color,
                size: 90,
                radius: 16,
                onTap: () {
                  showDialog(context: context, builder: (context) => ColorPickerDialog(
                    prefs: prefs,
                    currentColor: color,
                    onDone: (color) {
                      setState(() {
                        this.color = color;
                      });
                    },
                  ));
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    '• Photo',
                    style: prefs.text_style_sub_header,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '(Optional)',
                      style: prefs.text_style_bread,
                    ),
                  ),
                  customButton(
                    text: image == null ? 'Choose' : 'Remove',
                    onTap: () async {
                      if(image == null) {
                        image = await ImageService().imageFromGallery();
                        setState(() {});
                      } else {
                        image = null;
                        setState(() {});
                      }
                      //showDialog(context: context, builder: (context) => ChoosePhotoDialog(prefs: prefs, callback: (image) {}));
                    },
                    fillColor: image == null ? prefs.color_accept : prefs.color_deny,
                    splashColor: prefs.color_splash,
                    textColor: prefs.color_background,
                  ),
                ],
              ),
              SizedBox(height: 20),
              if(image != null) Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: size.width / 2,
                    maxHeight: size.height / 2,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      image,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              if(AdService.hasAds) SizedBox(height: AdService.adHeight),
            ],
          ),
        ),
      ),
      fab: Padding(
        padding: EdgeInsets.only(bottom: AdService.adHeight),
        child: FloatingActionButton(
          backgroundColor: prefs.color_primary,
          splashColor: prefs.color_splash,
          hoverColor: prefs.color_splash,
          focusColor: prefs.color_splash,
          child: !loading ? Icon(
            Icons.check,
            color: prefs.color_background,
            size: 40,
          ) : SpinKitThreeBounce(
            color: prefs.color_background,
            size: 20,
          ),
          onPressed: () async {
            if(_formKey.currentState.validate()) {
              await onDone(currentUser);
            }
          },
        ),
      ),
    );
  }
}
