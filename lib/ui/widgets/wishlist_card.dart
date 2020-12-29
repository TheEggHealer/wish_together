import 'package:flutter/material.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/ui/icons.dart';

class WishlistCard extends StatelessWidget {

  WishlistModel model;

  WishlistCard({this.model});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Center(
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Color(model.color),
        child: Container(
          width: size.width / 2.4,
          height: size.width / 3.2,
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Text(
                  model.name,
                  style: textstyle_card_header_light,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.wisher.name,
                        style: textstyle_card_date_light,
                      ),
                      Text(
                        model.dateCreated,
                        style: textstyle_card_date_light,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Icon(
                            CustomIcons.list,
                            color: color_text_light,
                          ),
                          Text(
                            model.listCount.toString(),
                            style: textstyle_card_header_light,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            CustomIcons.profile,
                            color: color_text_light,
                          ),
                          Text(
                            model.userCount.toString(),
                            style: textstyle_card_header_light,
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
    );
  }
}
