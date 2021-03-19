import 'package:flutter/material.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/ui/widgets/help_cards/help_card.dart';

class HelpCardItems extends StatelessWidget {

  UserPreferences prefs;

  HelpCardItems({this.prefs});

  @override
  Widget build(BuildContext context) {
    double smallSpace = 5;
    double largeSpace = 20;

    return HelpCard(
      prefs: prefs,
      content: [
        Text(
          '• Item screen',
          style: prefs.text_style_sub_header,
        ),
        SizedBox(height: smallSpace),
        RichText(
          text: TextSpan(
              children: [
                TextSpan(
                  text: 'The item screen is different depending on if you are '
                      'the wisher or not. If the item has a photo, it will be '
                      'shown at the top of the screen. If the item wasn’t '
                      'added by the wisher, the user who added it will be '
                      'shown below the photo.\n\n'
                      'If you are the wisher, only one chat-card will be '
                      'shown. At the top of this card is the description of '
                      'the item, if provided when it was created, and an icon '
                      'for the wisher. Below this is the chat. ',
                  style: prefs.text_style_bread,
                ),
                TextSpan(
                  text: 'Everything in this card is visible to everyone. ',
                  style: prefs.text_style_bread_bold,
                ),
                TextSpan(
                  text: '\n\nIf you are not the wisher, an additional card is '
                      'shown. Here you can claim the item and chat with '
                      'everybody except the wisher. ',
                  style: prefs.text_style_bread,
                ),
                TextSpan(
                  text: 'Nothing in this card is shown to the wisher.',
                  style: prefs.text_style_bread_bold,
                ),
              ]
          ),
        ),
      ],
    );
  }
}
