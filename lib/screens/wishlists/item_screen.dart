import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/dialog/send_warning_dialog.dart';
import 'package:wishtogether/models/comment_model.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/services/ad_service.dart';
import 'package:wishtogether/services/database_service.dart';
import 'package:wishtogether/services/global_memory.dart';
import 'package:wishtogether/models/item_model.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/ui/custom_icons.dart';
import 'package:wishtogether/ui/widgets/comment.dart';
import 'package:wishtogether/ui/widgets/custom_buttons.dart';
import 'package:wishtogether/ui/widgets/custom_scaffold.dart';
import 'package:wishtogether/ui/widgets/custom_textfields.dart';
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

  Widget timeWidget(CommentModel comment, bool full, UserPreferences prefs) {
    return Center(
      child: Text(
        full ? '${comment.dateString}, ${comment.timeString}' : '${comment.timeString}',
        style: prefs.text_style_tiny,
      ),
    );
  }

  List<Widget> addTimeStamps(List<Comment> comments, UserPreferences prefs) {
    List<Widget> result = [];
    debug('Trying to add timestamp');

    result.add(timeWidget(comments[0].model, true, prefs));
    result.add(comments[0]);

    //If there are more than one comment, look at the time between each comment. If that time is larger than <duration>, add a time stamp.
    if(comments.length > 1) {
      DateTime last = comments[0].model.date;
      for (int i = 1; i < comments.length; i++) {
        DateTime now = comments[i].model.date;
        Duration diff = now.difference(last);
        if(diff.inHours > 0) {
          if(diff.inDays > 0) result.add(timeWidget(comments[i].model, true, prefs));
          else result.add(timeWidget(comments[i].model, false, prefs));
        }
        result.add(comments[i]);
        last = now;
      }
    }

    return result;
  }

  Widget wisherCard(ItemModel model, WishlistModel wishlist, UserPreferences prefs) {
    int commentIndex = 0;
    List<Widget> comments = model.comments.map((c) => Comment(currentUser: widget.currentUser, model: c, wishlist: wishlist, index: commentIndex++)).toList();
    if(comments.isNotEmpty) comments = addTimeStamps(comments, prefs);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Hero(
        tag: model.wisherUID != 'no_user' ? widget.heroTag : '',
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          color: prefs.color_card,
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if(model.cost != -1) Text(
                              'Esimated cost: ${model.cost}',
                              style: prefs.text_style_sub_sub_header
                            ),
                            Text(
                              model.description,
                              style: prefs.text_style_bread,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10,),
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
                        child: customTextField(
                          prefs: prefs,
                          multiline: true,
                          controller: commentField,
                          helperText: 'Chat with wisher',
                        ),
                      ),
                      IconButton(
                        icon: Icon(CustomIcons.send),
                        color: prefs.color_icon,
                        onPressed: () async {
                          if(commentField.text.isNotEmpty) {
                            if(widget.currentUser.settings['warn_before_chatting_with_wisher']) {
                              await showDialog(
                                context: context, builder: (context) =>
                                SendWarning((answer, dontShow) async {
                                  if(dontShow) {
                                    UserData currentUser = widget.currentUser;
                                    currentUser.settings.update('warn_before_chatting_with_wisher', (value) => false);
                                    DatabaseService dbs = DatabaseService();
                                    await dbs.uploadData(dbs.userData, currentUser.uid, {'settings': currentUser.settings});
                                  }
                                  if (answer) {
                                    await model.addComment(commentField.text, widget.currentUser, false);
                                    commentField.clear();
                                  }
                                })
                              );
                            } else {
                              await model.addComment(commentField.text, widget.currentUser, false);
                              commentField.clear();
                            }
                          }
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

  Widget hiddenCard(ItemModel model, WishlistModel wishlist, UserPreferences prefs) {

    int commentIndex = 0;
    List<Widget> comments = model.hiddenComments.map((c) => Comment(currentUser: widget.currentUser, model: c, wishlist: wishlist, index: commentIndex++)).toList();
    if(comments.isNotEmpty) comments = addTimeStamps(comments, prefs);

    List<Widget> claimedUserDots = claimedUsers.map<Widget>((user) => Padding(
      padding: const EdgeInsets.all(6.0),
      child: UserDot.fromUserData(userData: user, size: SIZE.MEDIUM),
    )).toList();

    //TODO Why is a placeholder added?
    if(claimedUserDots.isEmpty) {
      claimedUserDots.add(Padding(
        padding: EdgeInsets.all(6.0),
        child: UserDot.placeHolder(size: SIZE.MEDIUM,),
      ));
    }

    bool alreadyClaimed = model.claimedUsers.contains(widget.currentUser.uid);

    claimedUserDots.insert(0, customButton(
      onTap: () {
        model.toggleUserClaim(widget.currentUser);
      },
      text: alreadyClaimed ? 'Remove me' : 'Add me',
      textColor: prefs.color_background,
      fillColor: alreadyClaimed ? prefs.color_deny : prefs.color_accept,
      splashColor: prefs.color_splash
    ));

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        color: prefs.color_card,
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
                    style: prefs.text_style_sub_sub_header
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: claimedUserDots,
                  ),
                ),
                Divider(
                  color: prefs.color_divider,
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
                      child: customTextField(
                        prefs: prefs,
                        multiline: true,
                        controller: hiddenCommentField,
                        helperText: 'Hidden chat',
                      ),
                    ),
                    IconButton(
                      icon: Icon(CustomIcons.send),
                      color: prefs.color_icon,
                      onPressed: () async {
                        if(hiddenCommentField.text.isNotEmpty) {
                          await model.addComment(hiddenCommentField.text, widget.currentUser, true);
                          hiddenCommentField.clear();
                        }
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

    wisher = await GlobalMemory.getUserData(wisherUID);
    wisherUserDot = UserDot.fromUserData(userData: wisher, size: SIZE.LARGE,);

    await loadClaimedUsers(item, wishlist);

    setState(() {});
  }

  Future<void> loadClaimedUsers(ItemModel model, WishlistModel wishlist) async {
    List<UserData> updatedList = [];
    for(String uid in model.claimedUsers) {
      updatedList.add(await GlobalMemory.getUserData(uid));
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
    UserPreferences prefs = UserPreferences.from(widget.currentUser);

    WishlistModel wishlist = Provider.of<WishlistModel>(context);
    ItemModel model = wishlist != null ? wishlist.items[widget.itemIndex] : ItemModel.empty();

    if(wishlist != null && wisher == null) {
      loadFromDatabase(model, wishlist);
    }

    if(claimedUsersChanged(model)) loadClaimedUsers(model, wishlist);

    bool hideInfo = model.shouldBeHiddenFrom(widget.currentUser);

    return CustomScaffold(
      prefs: prefs,
      title: wishlist != null ? model.itemName : '--',
      backButton: true,
      body: Column(
        children: [
          wisherCard(model, wishlist, prefs),
          if(!hideInfo) Divider(
            color: prefs.color_divider,
          ),
          if(!hideInfo) Text(
            'Hidden from wisher',
            style: prefs.text_style_sub_sub_header,
          ),
          if(!hideInfo) hiddenCard(model, wishlist, prefs),
          SizedBox(
            height: 10 + AdService.adHeight,
          ),
        ],
      ),
    );
  }
}
