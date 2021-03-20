import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/comment_model.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/ui/widgets/user_dot.dart';

class Comment extends StatefulWidget {

  UserData currentUser;
  CommentModel model;
  WishlistModel wishlist;
  int index;

  Comment({this.currentUser, this.model, this.wishlist, this.index});

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {

  UserData author;
  UserDot authorDot = UserDot.placeHolder(size: SIZE.SMALL);

  @override
  void initState() {
    super.initState();
    loadAuthor();
  }

  void loadAuthor() async {
    author = await widget.model.author(widget.wishlist);
    authorDot = UserDot.fromUserData(userData: author, size: SIZE.SMALL);
    setState(() {});
  }

  bool isCurrentUser() {
    return author != null && author.uid == widget.currentUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    UserPreferences prefs = UserPreferences.from(widget.currentUser);

    Size size = MediaQuery.of(context).size;

    List<Widget> commentRow = [
      if(!isCurrentUser()) authorDot,
      SizedBox(width: 5),
      Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: prefs.color_comment,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isCurrentUser() ? 10 : 3),
            topRight: Radius.circular(isCurrentUser() ? 3 : 10),
            bottomRight: Radius.circular(10),
            bottomLeft: Radius.circular(10)
          ),
        ),
        constraints: BoxConstraints(
          minWidth: 30,
          minHeight: 30,
          maxWidth: size.width * 0.6,
        ),
        child: Linkify(
          onOpen: (link) async {
            if (await canLaunch(link.url)) {
              await launch(link.url);
            } else {
              throw 'Could not launch $link';
            }
          },
          text: widget.model.content,
          style: prefs.text_style_bread,
        ),
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Align(
        alignment: isCurrentUser() ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: isCurrentUser() ? commentRow.reversed.toList() : commentRow,
        ),
      ),
    );


    //return InkWell(
    //  onLongPress: () {
    //    HapticFeedback.lightImpact();
    //    debug('User should be able to delete its own comment');
    //  },
    //  child: Container(
    //    color: widget.index % 2 == 0 ? Colors.transparent : color_comment_background,
    //    padding: EdgeInsets.all(6),
    //    child: Column(
    //      crossAxisAlignment: CrossAxisAlignment.start,
    //      children: [
    //        Text(
    //            widget.model.content,
    //            style: textstyle_comment
    //        ),
    //        Align(
    //          alignment: Alignment.centerRight,
    //          child: Row(
    //            mainAxisSize: MainAxisSize.min,
    //            children: [
    //              Text(
    //                '- ${author != null ? author.name : '--'}, ${widget.model.date}',
    //                style: textstyle_comment_author
    //              ),
    //              SizedBox(width: 5,),
    //              authorDot
    //            ],
    //          ),
    //        )
    //      ],
    //    ),
    //  ),
    //);
  }
}
