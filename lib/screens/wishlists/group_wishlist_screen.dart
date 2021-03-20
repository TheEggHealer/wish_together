import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:provider/provider.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/dialog/confirmation_dialog.dart';
import 'package:wishtogether/dialog/invite_to_wishlist_dialog.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/services/ad_service.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/services/global_memory.dart';
import 'package:wishtogether/services/invitation_service.dart';
import 'package:wishtogether/ui/custom_icons.dart';
import 'package:wishtogether/ui/widgets/custom_buttons.dart';
import 'package:wishtogether/ui/widgets/custom_scaffold.dart';
import 'package:wishtogether/ui/widgets/group_wishlist_card.dart';
import 'package:wishtogether/ui/widgets/loading.dart';
import 'package:wishtogether/ui/widgets/user_dot.dart';
import 'package:wishtogether/ui/widgets/wishlist_leave_button.dart';

class GroupWishlistScreen extends StatefulWidget {

  final UserData currentUser;
  final WishlistModel model;

  GroupWishlistScreen(this.currentUser, this.model);

  @override
  _GroupWishlistScreenState createState() => _GroupWishlistScreenState();
}

class _GroupWishlistScreenState extends State<GroupWishlistScreen> {

  List<UserData> loadedUsers = [];
  List<WishlistModel> loadedWishlists = [];
  bool loading = false;

  Future<void> load() async {
    DatabaseService dbs = DatabaseService();
    loadedUsers = [];
    //loadedWishlists = [];

    for(String uid in widget.model.invitedUsers) {
      loadedUsers.add(await GlobalMemory.getUserData(uid));
    }

    //for(String id in model.wishlistStream) {
    //  debug('Loading wishlists manually!');
    //  loadedWishlists.add(await dbs.getWishlist(id));
    //}

    setState(() {});
  }

  bool changes() {
    List<String> uids = loadedUsers.map((e) => e.uid).toList();

    if(uids.length != widget.model.invitedUsers.length) return true;

    widget.model.invitedUsers.forEach((element) {
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
          owner: e.uid == widget.model.creatorUID,
          pending: !(e.wishlistIds.contains(widget.model.id)),
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
    WishlistModel currentModel = loadedWishlists.firstWhere((element) => element.wisherUID == widget.currentUser.uid, orElse: () => null);
    if(currentModel != null) {
      loadedWishlists.remove(currentModel);
      loadedWishlists.insert(0, currentModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    UserPreferences prefs = UserPreferences.from(widget.currentUser);

    if(widget.model == null) {
      return Loading(prefs: prefs);
    }

    List<WishlistModel> ms = Provider.of<List<WishlistModel>>(context) ?? [];
    loadedWishlists = ms;
    placeCurrentFirst();
    if(changes()) load();

    List<Widget> w = loadedWishlists.map((element) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Size of ${element.name}: ${element.items.length}',
        style: prefs.text_style_bread,
      ),
    )).toList();

    List<Widget> userDots = getUserDots(prefs);
    List<Widget> wishlists = getWishlists(prefs);

    bool creator = widget.currentUser.uid == widget.model.creatorUID;

    bool hasWishlist = loadedWishlists.any((element) => element.wisherUID == widget.currentUser.uid);

    return CustomScaffold(
      prefs: prefs,
      title: widget.model.name,
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
                        wishlist: widget.model,
                        currentUser: widget.currentUser,
                        callback: () {},
                      ),
                      if(creator) SizedBox(width: 10),
                      if(creator) customButton(
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
                      crossAxisAlignment: CrossAxisAlignment.end,
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
            if(!hasWishlist) Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 60.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'You can add your own list by tapping the add ',
                        style: prefs.text_style_soft,
                      ),
                      WidgetSpan(
                        child: Icon(
                          Icons.add_circle,
                          color: prefs.color_primary,
                          size: 16,
                        ),
                      ),
                      TextSpan(
                        text: ' button in the bottom right corner!',
                        style: prefs.text_style_soft,
                      ),
                    ]
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: wishlists,
            ),
            if(AdService.hasAds) SizedBox(height: AdService.adHeight),
          ],
        )
      ),
      fab: !hasWishlist ? Padding(
        padding: EdgeInsets.only(bottom: AdService.adHeight),
        child: FloatingActionButton(
          backgroundColor: prefs.color_primary,
          splashColor: prefs.color_splash,
          hoverColor: prefs.color_splash,
          focusColor: prefs.color_splash,
          child: !loading ? Icon(
            Icons.add,
            color: prefs.color_background,
            size: 40,
          ) : SpinKitThreeBounce(
            color: prefs.color_background,
            size: 20,
          ),
          onPressed: () async {
            showDialog(context: context, builder: (context) => ConfirmationDialog(
              icon: CustomIcons.help,
              title: 'Create wishlist',
              confirmationText: 'Do you want to add your own list to this group wishlist?',
              prefs: prefs,
              callback: (doCreate) async {
                if(doCreate) {
                  setState(() {loading = true;});
                  await createWishlist();
                }
              },
            ));
          },
        ),
      ) : null,
    );
  }

  Future createWishlist() async {
    WishlistModel model = WishlistModel.create(
      name: widget.currentUser.name,
      type: 'solo',
      parent: widget.model.id,
      wisherUID: widget.currentUser.uid,
      dateCreated: DateFormat('yyyy-MM-dd').format(await NTP.now()),
      invitedUsers: widget.model.invitedUsers,
      isSubList: true,
    );

    widget.model.wishlistStream.add(model.id);

    await model.uploadList();
    await widget.model.uploadList();
  }

  void inviteUsers(List<String> uids) async {
    List<String> alreadyInvited = loadedUsers.map((e) => e.uid).toList();

    InvitationService invitationService = InvitationService();

    bool change = false;
    for(int i = 0; i < uids.length; i++) {
      if (!alreadyInvited.contains(uids[i])) {
        await invitationService.sendGroupWishlistInvitation(widget.currentUser.uid, widget.model.id, uids[i]);
        widget.model.invitedUsers.add(uids[i]);
        change = true;
      }
    }

    if(change) await widget.model.uploadList();
  }

}
