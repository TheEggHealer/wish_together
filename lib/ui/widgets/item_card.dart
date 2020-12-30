import 'package:flutter/material.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/item_model.dart';

class ItemCard extends StatelessWidget {

  final ItemModel model;

  ItemCard({this.model});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.white,
        child: InkWell(
          onTap: () {},
          child: Container(
            width: double.infinity,
            child: Text(
              model.itemName,
              style: textstyle_card_header_dark,
            ),
          ),
        ),
      ),
    );
  }

}
