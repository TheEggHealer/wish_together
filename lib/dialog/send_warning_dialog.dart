import 'package:flutter/material.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/dialog/custom_dialog.dart';
import 'package:wishtogether/ui/custom_icons.dart';
import 'package:wishtogether/ui/widgets/custom_buttons.dart';

class SendWarning extends StatefulWidget {

  final Function callback;

  SendWarning(this.callback);

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
      title: 'Are you sure?',
      icon: CustomIcons.bell,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('This message will be visible to the person who wish for this item. Make sure you don\'t accidentally spoil any surprises!'),
          Row(
            children: [
              Checkbox(
                value: dontShow, onChanged: (value) => setState(() => dontShow = value),
                activeColor: color_claim_green,
              ),
              Flexible(
                child: Text('Do not show this again.')
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
