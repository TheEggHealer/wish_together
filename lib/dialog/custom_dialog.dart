import 'package:flutter/material.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/ui/widgets/custom_buttons.dart';

class CustomDialog extends StatefulWidget {

  IconData icon;
  String title;
  Widget content;

  String acceptButton = '';
  String denyButton = '';
  Function onAccept;
  Function onDeny;

  CustomDialog({this.title, this.icon, this.content, this.acceptButton, this.denyButton, this.onAccept, this.onDeny});

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    widget.icon,
                    color: color_text_dark,
                    size: 30,
                  ),
                  SizedBox(width: 10,),
                  Text(
                    widget.title,
                    style: textstyle_header,
                  )
                ],
              ),
              SizedBox(height: 10),
              widget.content,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if(widget.denyButton != null) claimButton(
                    text: widget.denyButton,
                    fillColor: color_text_error,
                    onTap: () {
                      widget.onDeny();
                    },
                    splashColor: color_splash_light,
                    textColor: color_text_light,
                  ),
                  SizedBox(width: 10),
                  if(widget.acceptButton != null) claimButton(
                    text: widget.acceptButton,
                    fillColor: color_claim_green,
                    onTap: () {
                      widget.onAccept();
                    },
                    splashColor: color_splash_light,
                    textColor: color_text_light,
                  ),
                ],
              )
            ]
          ),
        ),
      ),
    );
  }
}
