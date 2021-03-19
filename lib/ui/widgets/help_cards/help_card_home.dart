import 'package:flutter/material.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/ui/custom_icons.dart';
import 'package:wishtogether/ui/widgets/help_cards/help_card.dart';
import 'package:wishtogether/ui/widgets/wishlist_card.dart';

class HelpCardHome extends StatelessWidget {

  UserPreferences prefs;

  HelpCardHome({this.prefs});

  @override
  Widget build(BuildContext context) {
    double smallSpace = 5;
    double largeSpace = 20;

    return HelpCard(
      prefs: prefs,
      content: [
        Text(
          '• Home screen',
          style: prefs.text_style_sub_header,
        ),
        SizedBox(height: smallSpace),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'On the home screen you are presented with all of the wishlists you '
                      'are part of. Both the ones you have created and those you have been '
                      'invited to and joined. To view a list, tap the card associated with '
                      'the list.',
                style: prefs.text_style_bread,
              )
            ]
          ),
        ),
        SizedBox(height: largeSpace),
        WishlistCard.template(prefs),
        SizedBox(height: largeSpace),
        Text(
          '• Icons',
          style: prefs.text_style_sub_header,
        ),
        SizedBox(height: smallSpace,),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    CustomIcons.profile,
                    color: prefs.color_icon,
                    size: 24,
                  ),
                  SizedBox(width: largeSpace,),
                  Expanded(
                    child: Text(
                      'This shows you how many users are part of this list.',
                      style: prefs.text_style_bread,
                    ),
                  ),
                ],
              ),
              SizedBox(height: largeSpace),
              Row(
                children: [
                  Icon(
                    CustomIcons.list_items,
                    color: prefs.color_icon,
                    size: 24,
                  ),
                  SizedBox(width: largeSpace,),
                  Expanded(
                    child: Text(
                      'This shows you the number of items in the list.',
                      style: prefs.text_style_bread,
                    ),
                  ),
                ],
              ),
              SizedBox(height: largeSpace),
              Row(
                children: [
                  Icon(
                    CustomIcons.group,
                    color: prefs.color_icon,
                    size: 24,
                  ),
                  SizedBox(width: largeSpace,),
                  Expanded(
                    child: Text(
                      'This icon shows that a list is a group wishlist. If it is not'
                          ' present, the list is a solo wishlist.',
                      style: prefs.text_style_bread,
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
