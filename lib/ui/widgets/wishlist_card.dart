import 'package:flutter/material.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/ui/custom_icons.dart';

class WishlistCard extends StatelessWidget {

  final WishlistModel model;
  final Function onClick;
  final UserPreferences prefs;

  WishlistCard({this.model, this.onClick, this.prefs});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Color cardColor = Color(model.color);

    return Center(
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        color: cardColor,
        child: InkWell(
          splashColor: prefs.color_splash,
          focusColor: prefs.color_splash,
          highlightColor: prefs.color_splash,
          hoverColor: prefs.color_splash,
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          onTap: onClick,
          child: Container(
              width: size.width / 2.4,
              height: size.width / 3.2, //3.2
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    model.name,
                    style: prefs.text_style_wishlist_card(cardColor),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            model.wisherName,
                            style: prefs.text_style_wishlist_tiny(cardColor),
                          ),
                          Text(
                            model.dateCreated,
                            style: prefs.text_style_wishlist_tiny(cardColor),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Icon(
                                CustomIcons.list_items,
                                color: prefs.color_wishlist_card(cardColor),
                              ),
                              Text(
                                model.listCount.toString(),
                                style: prefs.text_style_wishlist_card(cardColor),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                CustomIcons.profile,
                                color: prefs.color_wishlist_card(cardColor),
                              ),
                              Text(
                                model.userCount.toString(),
                                style: prefs.text_style_wishlist_card(cardColor),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  )
                ],
              )
          ),
        ),
      ),
    );
  }
}
