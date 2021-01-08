import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/database/database_service.dart';
import 'package:wishtogether/models/item_model.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/ui/widgets/comment.dart';
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

  Widget wisherCard(ItemModel model) {
    int commentIndex = 0;
    List<Comment> comments = model.comments.map((c) => Comment(model: c, index: commentIndex++)).toList();

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
                            onChanged: (val) {
                            },
                            controller: commentField,
                            textColor: color_text_comment,
                            activeColor: color_primary,
                            borderColor: color_text_dark_sub,
                            errorColor: color_text_error,
                            helperText: 'Comment to wisher',
                            textStyle: textstyle_comment,
                            borderRadius: 30
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        color: color_primary,
                        onPressed: () async {
                          model.addComment(commentField.text, widget.currentUser, false);
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

  Widget hiddenCard(ItemModel model) {

    List<Widget> claimedUserDots = claimedUsers.map((user) => Padding(
      padding: const EdgeInsets.all(6.0),
      child: UserDot.fromUserData(userData: user, size: SIZE.MEDIUM),
    )).toList();

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
                )
              ],
            ),
          ),
        ),
      )
    );
  }

  void loadFromDatabase(ItemModel item, WishlistModel wishlist) async {
    wisher = await UserData.from(wishlist.wisherUID);
    wisherUserDot = UserDot.fromUserData(userData: wisher, size: SIZE.LARGE,);

    for(String uid in item.claimedUsers) {
      UserData user = await UserData.from(uid);
      claimedUsers.add(user);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    WishlistModel wishlist = Provider.of<WishlistModel>(context);
    ItemModel model = wishlist != null ? wishlist.items[widget.itemIndex] : ItemModel.empty();

    if(wishlist != null && wisher == null) {
      loadFromDatabase(model, wishlist);
    }


    return Scaffold(
      backgroundColor: color_background,
      appBar: AppBar(
        backgroundColor: color_primary,
        elevation: 10,
        title: Row(
          children: [
            Text(
              wishlist != null ? wishlist.name : '--',
              style: textstyle_appbar,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: wisherCard(model),
      ),
    );
  }
}
