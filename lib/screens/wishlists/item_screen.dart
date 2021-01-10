import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/database/database_service.dart';
import 'package:wishtogether/database/global_memory.dart';
import 'package:wishtogether/models/item_model.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/ui/widgets/comment.dart';
import 'package:wishtogether/ui/widgets/custom_buttons.dart';
import 'package:wishtogether/ui/widgets/custom_textfields.dart';
import 'package:wishtogether/ui/widgets/loading.dart';
import 'package:wishtogether/ui/widgets/user_dot.dart';

class ItemScreen extends StatefulWidget {

  int itemIndex;
  UserData currentUser;
  String heroTag;

  ItemScreen({this.itemIndex, this.heroTag, this.currentUser});

  @override
  _ItemScreenState createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> with TickerProviderStateMixin {

  UserDot wisherUserDot = UserDot.placeHolder(size: SIZE.LARGE,);
  List<UserData> claimedUsers = [];
  UserData wisher;

  TextEditingController commentField = TextEditingController();
  TextEditingController hiddenCommentField = TextEditingController();

  Widget wisherCard(ItemModel model, WishlistModel wishlist) {
    int commentIndex = 0;
    List<Comment> comments = model.comments.map((c) => Comment(model: c, wishlist: wishlist, index: commentIndex++)).toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Hero(
        tag: model.wisherUID != 'no_user' ? widget.heroTag : '',
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          color: Colors.white,
          child: AnimatedSize(
            vsync: this,
            duration: Duration(milliseconds: 200),
            alignment: Alignment.topCenter,
            curve: Curves.ease,
            child: Container(
              padding: EdgeInsets.all(8),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              model.itemName,
                              style: textstyle_card_header_dark
                          ),
                          Text(
                              'User: ${wisher != null ? wisher.name : '--'}',
                              style: textstyle_card_dark_sub
                          ),
                          Text(
                              'Estimated cost: ${model.cost}',
                              style: textstyle_card_dark_sub
                          ),
                        ],
                      ),
                      wisherUserDot
                    ],
                  ),
                  SizedBox(height: 10,),
                  Column(
                    children: comments,
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: textFieldComment(
                            controller: commentField,
                            textColor: color_text_comment,
                            activeColor: color_primary,
                            borderColor: color_text_dark_sub,
                            errorColor: color_text_error,
                            helperText: 'Chat with wisher',
                            textStyle: textstyle_comment,
                            borderRadius: 30
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        color: color_primary,
                        onPressed: () async {
                          await model.addComment(commentField.text, widget.currentUser, false);
                          commentField.clear();
                        },
                        splashRadius: 20,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget hiddenCard(ItemModel model, WishlistModel wishlist) {

    int commentIndex = 0;
    List<Comment> comments = model.hiddenComments.map((c) => Comment(model: c, wishlist: wishlist, index: commentIndex++)).toList();

    List<Widget> claimedUserDots = claimedUsers.map<Widget>((user) => Padding(
      padding: const EdgeInsets.all(6.0),
      child: UserDot.fromUserData(userData: user, size: SIZE.MEDIUM),
    )).toList();

    if(claimedUserDots.isEmpty) {
      claimedUserDots.add(Padding(
        padding: EdgeInsets.all(6.0),
        child: UserDot.placeHolder(size: SIZE.MEDIUM,),
      ));
    }

    bool alreadyClaimed = model.claimedUsers.contains(widget.currentUser.uid);

    claimedUserDots.insert(0, claimButton(
      onTap: () {
        model.toggleUserClaim(widget.currentUser);
      },
      text: alreadyClaimed ? 'Remove me' : 'Add me',
      textColor: color_text_light,
      fillColor: alreadyClaimed ? color_text_error : color_claim_green,
      borderRadius: 30,
      width: 100,
    ));

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        color: Colors.white,
        child: AnimatedSize(
          vsync: this,
          duration: Duration(milliseconds: 200),
          alignment: Alignment.topCenter,
          curve: Curves.ease,
          child: Container(
            padding: EdgeInsets.all(8.0),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Claimed Users:',
                    style: textstyle_card_header_dark
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: claimedUserDots,
                  ),
                ),
                Divider(
                  color: color_divider_dark,
                  indent: 8,
                  endIndent: 8,
                ),
                SizedBox(height: 10,),
                Column(
                  children: comments,
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: textFieldComment(
                          controller: hiddenCommentField,
                          textColor: color_text_comment,
                          activeColor: color_primary,
                          borderColor: color_text_dark_sub,
                          errorColor: color_text_error,
                          helperText: 'Hidden chat',
                          textStyle: textstyle_comment,
                          borderRadius: 30
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      color: color_primary,
                      onPressed: () async {
                        await model.addComment(hiddenCommentField.text, widget.currentUser, true);
                        hiddenCommentField.clear();
                      },
                      splashRadius: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

  void loadFromDatabase(ItemModel item, WishlistModel wishlist) async {
    String wisherUID = wishlist.wisherUID;
    if(GlobalMemory.currentlyLoadedUsers.containsKey(wisherUID)) {
      wisher = GlobalMemory.currentlyLoadedUsers[wisherUID];
      debug('Wisher loaded from currentlyLoadedUsers');
    } else {
      wisher = await UserData.from(wisherUID);
      GlobalMemory.currentlyLoadedUsers.putIfAbsent(wisherUID, () => wisher);
      debug('Wisher was not in currentlyLoadedUsers, had to add it');
    }
    wisherUserDot = UserDot.fromUserData(userData: wisher, size: SIZE.LARGE,);

    await loadClaimedUsers(item, wishlist);

    setState(() {});
  }

  Future<void> loadClaimedUsers(ItemModel model, WishlistModel wishlist) async {
    List<UserData> updatedList = [];
    for(String uid in model.claimedUsers) {
      if(GlobalMemory.currentlyLoadedUsers.containsKey(uid)) {
        updatedList.add(GlobalMemory.currentlyLoadedUsers[uid]);
        debug('Got user from currentlyLoadedUsers map');
      } else {
        UserData user = await UserData.from(uid);
        updatedList.add(user);
        GlobalMemory.currentlyLoadedUsers.putIfAbsent(uid, () => user);
        debug('User was not in currentlyLoadedUsers map, had to add it');
      }
    }
    claimedUsers = updatedList;

    setState(() {});
  }

  bool claimedUsersChanged(ItemModel model) {
    List<String> uids = claimedUsers.map((e) => e.uid).toList();
    if(model.claimedUsers.length != uids.length) return true;
    model.claimedUsers.forEach((element) {
      if(!uids.contains(element)) return true;
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    WishlistModel wishlist = Provider.of<WishlistModel>(context);
    ItemModel model = wishlist != null ? wishlist.items[widget.itemIndex] : ItemModel.empty();

    if(wishlist != null && wisher == null) {
      loadFromDatabase(model, wishlist);
    }

    if(claimedUsersChanged(model)) loadClaimedUsers(model, wishlist);

    bool hideInfo = model.shouldBeHiddenFrom(widget.currentUser);

    return Scaffold(
      backgroundColor: color_background,
      appBar: AppBar(
        backgroundColor: color_primary,
        elevation: 10,
        title: Row(
          children: [
            Text(
              wishlist != null ? model.itemName : '--',
              style: textstyle_appbar,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            wisherCard(model, wishlist),
            if(!hideInfo) Divider(
              color: color_divider_dark,
              indent: 16,
              endIndent: 16,
            ),
            if(!hideInfo) Text(
              'Hidden from wisher',
              style: textstyle_subheader,
            ),
            if(!hideInfo) hiddenCard(model, wishlist),
          ],
        ),
      ),
    );
  }
}
