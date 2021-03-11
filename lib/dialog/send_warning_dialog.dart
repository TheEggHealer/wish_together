import 'package:flutter/material.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/dialog/custom_dialog.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/ui/custom_icons.dart';
import 'package:wishtogether/ui/widgets/custom_buttons.dart';

class SendWarning extends StatefulWidget {

  final Function callback;
  UserPreferences prefs;

  SendWarning(this.callback, this.prefs);

  @override
  State<StatefulWidget> createState() => _SendWarningState();
}

class _SendWarningState extends State<SendWarning> {

  bool dontShow = false;

  void onAnswer(BuildContext context, bool value) async {
    await widget.callback(value, dontShow);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      prefs: widget.prefs,
      title: 'Are you sure?',
      icon: CustomIcons.warning,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('This message will be visible to the wisher of this item. Make sure you don\'t accidentally spoil any surprises!', style: widget.prefs.text_style_bread,),
          Row(
            children: [
              Theme(
                data: ThemeData(unselectedWidgetColor: widget.prefs.color_icon),
                child: Checkbox(
                  value: dontShow, onChanged: (value) => setState(() => dontShow = value),
                  checkColor: widget.prefs.color_background,
                  activeColor: widget.prefs.color_accept,
                  hoverColor: widget.prefs.color_splash,
                  focusColor: widget.prefs.color_splash,
                ),
              ),
              Flexible(
                child: Text('Do not show this again.', style: widget.prefs.text_style_bread,)
              )
            ],
          )
        ],
      ),
      acceptButton: 'Send',
      denyButton: 'Don\'t send',
      onAccept: () {
        onAnswer(context, true);
      },
      onDeny: () {
        onAnswer(context, false);
      },
    );
  }
}
