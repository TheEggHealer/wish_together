import 'package:flutter/material.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/notification_model.dart';
import 'package:wishtogether/models/user_data.dart';

class NotificationWidget extends StatefulWidget {

  NotificationModel model;
  UserData currentUser;

  NotificationWidget(this.model, this.currentUser);

  @override
  State<StatefulWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {

  String body = '';
  bool loaded = false;

  Future load() async {
    body = await widget.model.body;
    loaded = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    if(!loaded) load();

    return Padding(
      padding: EdgeInsets.all(8),
      child: Card(
        elevation: 10,
        color: color_card_background,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                widget.model.icon,
                color: color_divider_dark,
                size: 20,
              ),
              SizedBox(width: 10,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.model.title,
                      style: textstyle_list_title
                    ),
                    Text(
                      body,
                      style: textstyle_notification_body
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if(widget.model.hasAcceptOption) FloatingActionButton(
                    onPressed: () async {
                      widget.model.onAccept(widget.currentUser);
                    },
                    child: Icon(Icons.done),
                    mini: true,
                    backgroundColor: color_claim_green,
                    splashColor: color_splash_light,
                    focusColor: color_splash_light,
                    hoverColor: color_splash_light,
                    foregroundColor: Colors.white,
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      widget.model.onDeny(widget.currentUser);
                    },
                    child: Icon(Icons.close),
                    mini: true,
                    backgroundColor: color_text_error,
                    splashColor: color_splash_light,
                    focusColor: color_splash_light,
                    hoverColor: color_splash_light,
                    foregroundColor: Colors.white,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
