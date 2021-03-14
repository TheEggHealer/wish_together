import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/dialog/invite_to_wishlist_dialog.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/services/global_memory.dart';
import 'package:wishtogether/services/invitation_service.dart';
import 'package:wishtogether/ui/widgets/custom_buttons.dart';
import 'package:wishtogether/ui/widgets/custom_scaffold.dart';
import 'package:wishtogether/ui/widgets/group_wishlist_card.dart';
import 'package:wishtogether/ui/widgets/loading.dart';
import 'package:wishtogether/ui/widgets/user_dot.dart';
import 'package:wishtogether/ui/widgets/wishlist_leave_button.dart';

class GroupWishlistScreen extends StatefulWidget {

  final UserData currentUser;

  GroupWishlistScreen(this.currentUser);

  @override
  _GroupWishlistScreenState createState() => _GroupWishlistScreenState();
}

class _GroupWishlistScreenState extends State<GroupWishlistScreen> {

  WishlistModel model;
  List<UserData> loadedUsers = [];
  List<WishlistModel> loadedWishlists = [];

  Future<void> load() async {
    DatabaseService dbs = DatabaseService();
    loadedUsers = [];
    for(String uid in model.invitedUsers) {
      loadedUsers.add(await GlobalMemory.getUserData(uid));
    }

    setState(() {});
  }

  bool invitedUsersChanged() {
    List<String> uids = loadedUsers.map((e) => e.uid).toList();

    if(uids.length != model.invitedUsers.length) return true;

    model.invitedUsers.forEach((element) {
      if(!uids.contains(element)) return true;
    });
    return false;
  }

  List<Widget> getUserDots(UserPreferences prefs) {
    return loadedUsers.map<Widget>((e) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: UserDot.fromUserData(
          userData: e,
          size: SIZE.MEDIUM,
          owner: e.uid == model.wisherUID,
          pending: !loadedWishlists.any((element) => element.wisherUID == e.uid),
          prefs: prefs,
          doShowName: true,
        ),
      );
    }).toList();
  }

  List<Widget> getWishlists(UserPreferences prefs) {
    return loadedWishlists.map<Widget>((e) {
      return GroupWishlistCard(
        prefs: prefs,
        model: e,
        currentUser: widget.currentUser,
      );
    }).toList();
  }

  void placeCurrentFirst() {
    WishlistModel currentModel = loadedWishlists.firstWhere((element) => element.wisherUID == widget.currentUser.uid);
    loadedWishlists.remove(currentModel);
    loadedWishlists.insert(0, currentModel);
  }

  @override
  Widget build(BuildContext context) {
    UserPreferences prefs = UserPreferences.from(widget.currentUser);

    List<WishlistModel> ms = Provider.of<List<WishlistModel>>(context);
    if(ms != null) {
      ms.forEach((element) {debug(element.type);});
      model = ms.firstWhere((element) => element.type == 'group');
      loadedWishlists = ms.where((element) => element.type == 'solo').toList();
      placeCurrentFirst();
      if(invitedUsersChanged()) load();
    }

    if(model == null) {
      return Loading();
    }

    List<Widget> w = loadedWishlists.map((element) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Size of ${element.name}: ${element.items.length}',
        style: prefs.text_style_bread,
      ),
    )).toList();

    List<Widget> userDots = getUserDots(prefs);
    List<Widget> wishlists = getWishlists(prefs);

    return CustomScaffold(
      prefs: prefs,
      title: model.name,
      backButton: true,
      padding: false,
      body: Container(
        padding: EdgeInsets.only(bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18), //6 + 12, from CustomScaffold padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Invited',
                          style: prefs.text_style_sub_header,
                        ),
                      ),
                      WishlistLeaveButton(
                        prefs: prefs,
                        wishlist: model,
                        currentUser: widget.currentUser,
                        callback: () {},
                      ),
                      SizedBox(width: 10),
                      customButton(
                        onTap: () async {
                          showDialog(context: context, builder: (context) => InviteToWishlistDialog(prefs, widget.currentUser, inviteUsers, loadedUsers.map((e) => e.uid).toList()));
                        },
                        textColor: prefs.color_background,
                        fillColor: prefs.color_accept,
                        splashColor: prefs.color_splash,
                        text: 'Invite',
                      )
                    ],
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: userDots.isNotEmpty ? userDots : [SpinKitThreeBounce(
                        color: color_loading_spinner,
                        size: 20,
                      )],
                    ),
                  ),
                  Divider(
                    color: prefs.color_divider,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: wishlists,
            )
          ],
        )
      ),
    );
  }

  void inviteUsers(List<String> uids) async {
    List<String> alreadyInvited = loadedUsers.map((e) => e.uid).toList();

    InvitationService invitationService = InvitationService();

    bool change = false;
    for(int i = 0; i < uids.length; i++) {
      if (!alreadyInvited.contains(uids[i])) {
        await invitationService.sendGroupWishlistInvitation(widget.currentUser.uid, model.id, uids[i]);
        model.invitedUsers.add(uids[i]);
        change = true;
      }
    }

    if(change) await model.uploadList();
  }

}
