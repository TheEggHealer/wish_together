import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:provider/provider.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/dialog/color_picker_dialog.dart';
import 'package:wishtogether/dialog/invite_to_wishlist_dialog.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/screens/drawer/help_screen.dart';
import 'package:wishtogether/services/ad_service.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/services/global_memory.dart';
import 'package:wishtogether/services/invitation_service.dart';
import 'package:wishtogether/ui/custom_icons.dart';
import 'package:wishtogether/ui/widgets/color_chooser_square.dart';
import 'package:wishtogether/ui/widgets/custom_buttons.dart';
import 'package:wishtogether/ui/widgets/custom_scaffold.dart';
import 'package:wishtogether/ui/widgets/custom_textfields.dart';
import 'package:wishtogether/ui/widgets/user_dot.dart';

class CreateWishlistScreen extends StatefulWidget {
  @override
  _CreateWishlistScreenState createState() => _CreateWishlistScreenState();
}

class _CreateWishlistScreenState extends State<CreateWishlistScreen> {

  UserData currentUser;
  TextEditingController titleController = TextEditingController();
  Color color = Colors.green[300];
  bool soloWishlist = true;
  List<bool> typeSelected = [true, false];
  List<String> invitedUsers = [];
  List<UserData> loadedFriends = [];
  bool loading = false;

  final _formKey = GlobalKey<FormState>();

  void loadFriends() async {
    List<UserData> result = [];
    for(String uid in invitedUsers) {
      result.add(await GlobalMemory.getUserData(uid));
    }
    loadedFriends = result;
    debug('Loaded friends!');
    setState(() {});
  }

  Widget friends(UserPreferences prefs) {

    List<Widget> friendRows = loadedFriends.map((e) {

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            UserDot.fromUserData(userData: e, size: SIZE.MEDIUM,),
            SizedBox(width: 10,),
            Expanded(
              child: Text(
                e.name,
                style: prefs.text_style_sub_sub_header,
              ),
            ),
            circleButton(
              icon: Icon(Icons.close, size: 20, color: prefs.color_background,),
              fillColor: prefs.color_deny,
              splashColor: prefs.color_splash,
              onTap: () {
                invitedUsers.remove(e.uid);
                loadedFriends.remove(e);
                setState(() {});
              }
            ),
          ],
        ),
      );
    }).toList();

    return Column(
      children: friendRows,
    );
  }

  void setSelected(int index) {
    soloWishlist = index == 0;
    typeSelected = [soloWishlist, !soloWishlist];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    currentUser = Provider.of<UserData>(context);
    UserPreferences prefs = UserPreferences.from(currentUser);

    return CustomScaffold(
      prefs: prefs,
      backButton: true,
      title: 'Create wishlist',
      body: Container(
        padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• Title',
                style: prefs.text_style_sub_header,
              ),
              SizedBox(height: 5),
              customTextField(
                validator: (val) => val.isEmpty ? 'Wishlist needs a title' : null,
                prefs: prefs,
                multiline: false,
                controller: titleController,
              ),
              SizedBox(height: 20),
              Text(
                '• Color',
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '• Type',
                    style: prefs.text_style_sub_header,
                  ),
                  SizedBox(width: 10,),
                  Material(
                    child: IconButton(
                      icon: Icon(CustomIcons.help),
                      color: prefs.color_icon,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => StreamProvider<UserData>.value(
                          value: DatabaseService(uid: currentUser.uid).userDocument,
                          child: HelpScreen(initScreen: 1,),
                        )));
                      },
                      splashColor: prefs.color_splash,
                      focusColor: prefs.color_splash,
                      hoverColor: prefs.color_splash,
                      highlightColor: prefs.color_splash,
                      splashRadius: 20,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              SizedBox(
                height: 28,
                child: ToggleButtons(
                  borderColor: prefs.color_comment,
                  fillColor: prefs.color_background,
                  selectedBorderColor: prefs.color_accept,
                  selectedColor: prefs.color_accept,
                  color: prefs.color_accept,
                  highlightColor: prefs.color_splash,
                  hoverColor: prefs.color_splash,
                  focusColor: prefs.color_splash,
                  splashColor: prefs.color_splash,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  isSelected: typeSelected,
                  borderWidth: 2,
                  onPressed: setSelected,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Center(
                        child: Text(
                          'Solo',
                          style: prefs.text_style_bread,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: Center(
                        child: Text(
                          'Group',
                          style: prefs.text_style_bread,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                '• Invite friends',
                style: prefs.text_style_sub_header,
              ),
              SizedBox(height: 5),
              customButton(
                text: 'Invite',
                fillColor: prefs.color_accept,
                textColor: prefs.color_background,
                splashColor: prefs.color_splash,
                onTap: () => showDialog(context: context, builder: (context) => InviteToWishlistDialog(prefs, currentUser, setInvited, invitedUsers)),
              ),
              SizedBox(height: 20),
              if(loadedFriends.isNotEmpty) friends(prefs),
              if(AdService.hasAds) SizedBox(height: AdService.adHeight,),
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
            if(currentUser != null && _formKey.currentState.validate()) {
              await onDone();
              Navigator.pop(context);
            } else debug('Current user is null');
            //Navigator.push(context, MaterialPageRoute(builder: (context) => CreateWishlistScreen()));
          },
        ),
      ),
    );
  }

  void setInvited(List<String> invited) {
    invited.forEach((element) {
      if(!invitedUsers.contains(element) && element != currentUser.uid) invitedUsers.add(element);
    });
    loadFriends();
  }

  Future<void> onDone() async {
    setState(() {loading = true;});
    WishlistModel wishlist = typeSelected[0] ? await createSoloModel(title: titleController.text, wisher: currentUser.uid, isSubList: false)
                                             : await createGroupModel();

    currentUser.wishlistIds.add(wishlist.id);
    InvitationService invitation = InvitationService();

    for(String uid in invitedUsers) {
      debug('Sending invitation to: $uid');
      typeSelected[0] ? await invitation.sendWishlistInvitation(currentUser.uid, wishlist.id, uid)
                      : await invitation.sendGroupWishlistInvitation(currentUser.uid, wishlist.id, uid);
    }

    await wishlist.uploadList();
    await currentUser.uploadData();
  }

  Future<WishlistModel> createGroupModel() async {
    List<String> users = List.from(invitedUsers)..add(currentUser.uid);

    WishlistModel groupList = WishlistModel.create(
      color: color.value,
      name: titleController.text,
      type: 'group',
      parent: 'null',
      creatorUID: currentUser.uid,
      dateCreated: DateFormat('yyyy-MM-dd').format(await NTP.now()),
      invitedUsers: users,
      isSubList: false,
      wishlistStream: [],
    );

    return groupList;
  }

  Future<WishlistModel> createSoloModel({String title, String wisher, bool isSubList}) async {
    WishlistModel model = WishlistModel.create(
      color: color.value,
      name: title,
      type: 'solo',
      parent: 'null',
      wisherUID: wisher,
      creatorUID: currentUser.uid,
      dateCreated: DateFormat('yyyy-MM-dd').format(await NTP.now()),
      invitedUsers: [currentUser.uid]..addAll(invitedUsers),
      isSubList: isSubList,
    );
    return model;
  }

}
