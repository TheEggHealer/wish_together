import 'package:flutter/material.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/comment_model.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/ui/widgets/user_dot.dart';

class Comment extends StatefulWidget {

  CommentModel model;
  int index;

  Comment({this.model, this.index});

  @override
  _CommentState createState() => _CommentState();
}

class _CommentState extends State<Comment> {

  UserData author;
  UserDot authorDot = UserDot.placeHolder(size: SIZE.AUTHOR);

  @override
  void initState() {
    super.initState();
    loadAuthor();
  }

  void loadAuthor() async {
    author = await widget.model.author;
    authorDot = UserDot.fromUserData(userData: author, size: SIZE.AUTHOR);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onLongPress: () {
        debug('User should be able to delete its own comment');
      },
      child: Container(
        color: widget.index % 2 == 0 ? Colors.transparent : color_comment_background,
        padding: EdgeInsets.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                widget.model.content,
                style: textstyle_comment
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '- ${author != null ? author.name : '--'}, ${widget.model.date}',
                    style: textstyle_comment_author
                  ),
                  SizedBox(width: 5,),
                  authorDot
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
