import 'package:flutter/material.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/ui/custom_icons.dart';
import 'package:wishtogether/ui/widgets/help_cards/help_card.dart';

class HelpCardWishlists extends StatelessWidget {

  UserPreferences prefs;

  HelpCardWishlists({this.prefs});

  @override
  Widget build(BuildContext context) {
    double smallSpace = 5;
    double largeSpace = 20;

    return HelpCard(
      prefs: prefs,
      content: [
        Text(
          '• Solo wishlist',
          style: prefs.text_style_sub_header,
        ),
        SizedBox(height: smallSpace),
        RichText(
          text: TextSpan(
              children: [
                TextSpan(
                  text: 'The solo wishlist is a list where there is only one '
                      'wisher. The users that are invited to this list can '
                      'claim and comment on the items the wisher wishes for.\n\n'
                      'If you are not the wisher, you can signal that you '
                      'want to buy a thing on the list by claiming the item '
                      '(Long press on the item card). This will appear as a '
                      'dot with your color on the right side of the item card. ',
                  style: prefs.text_style_bread,
                ),
                TextSpan(
                  text: 'Claim-dots are not visible to the wisher, however, the '
                      'other users that are invited can see them. ',
                  style: prefs.text_style_bread_bold,
                ),
                TextSpan(
                  text: 'Multiple users can claim the same item, signaling that '
                      'they may want to buy it together and split the cost for '
                      'example.',
                  style: prefs.text_style_bread,
                ),
              ]
          ),
        ),
        SizedBox(height: largeSpace),
        Text(
          '• Group wishlist',
          style: prefs.text_style_sub_header,
        ),
        SizedBox(height: smallSpace),
        RichText(
          text: TextSpan(
              children: [
                TextSpan(
                  text: 'The group wishlist is a list of solo wishlists, '
                      'grouped together. Here, every user that is invited '
                      'can create their own list and they are easily '
                      'accessable and viewed. ',
                  style: prefs.text_style_bread,
                )
              ]
          ),
        ),
        SizedBox(height: largeSpace),
        Text(
          '• Icons',
          style: prefs.text_style_sub_header,
        ),
        SizedBox(height: smallSpace),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    CustomIcons.camera,
                    color: prefs.color_icon,
                    size: 24,
                  ),
                  SizedBox(width: largeSpace,),
                  Expanded(
                    child: Text(
                      'This shows you that an item has a photo.',
                      style: prefs.text_style_bread,
                    ),
                  ),
                ],
              ),
              SizedBox(height: largeSpace),
              Row(
                children: [
                  Icon(
                    CustomIcons.hide,
                    color: prefs.color_icon,
                    size: 24,
                  ),
                  SizedBox(width: largeSpace,),
                  Expanded(
                    child: Text(
                      'This shows you that the item is not visible to the wisher.'
                          ' It has been added by another user.',
                      style: prefs.text_style_bread,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
