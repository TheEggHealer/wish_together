import 'package:flutter/material.dart';
import 'package:wishtogether/constants.dart';
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
    return AlertDialog(
      title: Text('Sure you want to send this?'),
      content: SingleChildScrollView(
        child: Column(
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
      ),

      actions: [
        claimButton(
          text: 'Don\'t send',
          fillColor: color_text_error,
          onTap: () {
            onAnswer(context, false);
          },
          splashColor: color_splash_light,
          textColor: color_text_light,
        ),
        claimButton(
          text: 'Send',
          fillColor: color_claim_green,
          onTap: () {
            onAnswer(context, true);
          },
          splashColor: color_splash_light,
          textColor: color_text_light,
        ),
      ],
    );
  }
}
