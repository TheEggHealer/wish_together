import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/comment_model.dart';
import 'package:wishtogether/models/item_model.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/services/ad_service.dart';
import 'package:wishtogether/ui/widgets/custom_textfields.dart';

class CreateItemScreen extends StatefulWidget {

  WishlistModel wishlist;

  CreateItemScreen(this.wishlist);

  @override
  _CreateItemScreenState createState() => _CreateItemScreenState();
}

class _CreateItemScreenState extends State<CreateItemScreen> {

  UserData currentUser;
  TextEditingController itemController = TextEditingController();
  TextEditingController costController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool hasCost = false;
  bool hasDescription = false;


  bool validate() {
    return true;
  }

  bool isNumeric(String s) {
    if(s == null) return false;

    return double.tryParse(s) != null;
  }

  Future<void> onDone() async {
    debug('Creating new item');
    ItemModel item = await createItem();
    widget.wishlist.items.add(item);
    await widget.wishlist.uploadList();
  }

  Future<ItemModel> createItem() async {

    ItemModel item = ItemModel.create(
      wishlist: widget.wishlist,
      itemName: itemController.text,
      cost: double.tryParse(costController.text) ?? 0,
      addedByUID: currentUser.uid,
    );

    if(hasDescription) {
      item.hasDescription = true;
      CommentModel description = await CommentModel.from(descriptionController.text, currentUser);
      if(currentUser.uid == item.wisherUID) item.comments.add(description);
      else item.hiddenComments.add(description);
    }
    return item;
  }

  @override
  Widget build(BuildContext context) {

    currentUser = Provider.of<UserData>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: color_primary,
        elevation: 10,
        title: Text(
          'Create new item',
          style: textstyle_appbar,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Item',
                style: textstyle_header,
              ),
              SizedBox(height: 10),
              textFieldComment(
                onChanged: (text) {

                },
                multiline: false,
                controller: itemController,
                textColor: color_text_comment,
                activeColor: color_primary,
                borderColor: color_text_dark_sub,
                errorColor: color_text_error,
                textStyle: textstyle_comment,
                borderRadius: 30
              ),
              SizedBox(height: 20),
              Text(
                'Estimated cost',
                style: textstyle_header,
              ),
              SizedBox(height: 10),
              textFieldComment(
                onChanged: (val) => hasCost = isNumeric(val),
                multiline: false,
                controller: costController,
                textColor: color_text_comment,
                activeColor: color_primary,
                borderColor: color_text_dark_sub,
                errorColor: color_text_error,
                helperText: 'Estimated cost of item (optional)',
                textStyle: textstyle_comment,
                borderRadius: 30
              ),
              SizedBox(height: 20),
              Text(
                'Description',
                style: textstyle_header,
              ),
              SizedBox(height: 10),
              textFieldComment(
                onChanged: (val) => hasDescription = val.isNotEmpty,
                multiline: true,
                controller: descriptionController,
                textColor: color_text_comment,
                activeColor: color_primary,
                borderColor: color_text_dark_sub,
                errorColor: color_text_error,
                helperText: 'Describe the item (optional)',
                textStyle: textstyle_comment,
                borderRadius: 30
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: AdService.adHeight),
        child: FloatingActionButton(
          backgroundColor: color_primary,
          splashColor: color_splash_light,
          hoverColor: color_splash_light,
          focusColor: color_splash_light,
          child: Icon(
            Icons.check,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () async {
            if(currentUser != null && validate()) {
              await onDone();
              Navigator.pop(context);
            } else debug('Current user is null');
            //Navigator.push(context, MaterialPageRoute(builder: (context) => CreateWishlistScreen()));
          },
        ),
      ),
    );
  }
}
