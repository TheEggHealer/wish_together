import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/dialog/choose_photo_dialog.dart';
import 'package:wishtogether/models/comment_model.dart';
import 'package:wishtogether/models/item_model.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/services/ad_service.dart';
import 'package:wishtogether/services/image_service.dart';
import 'package:wishtogether/ui/widgets/custom_buttons.dart';
import 'package:wishtogether/ui/widgets/custom_scaffold.dart';
import 'package:wishtogether/ui/widgets/custom_textfields.dart';

import '../../services/image_service.dart';
import '../../services/image_service.dart';
import '../../services/image_service.dart';
import '../../ui/custom_icons.dart';

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
  File image;
  bool hideItem = false;
  List<bool> hideSelected = [false, true];

  bool loading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool validate() {
    return true;
  }

  bool isNumeric(String s) {
    if(s == null) return false;

    return double.tryParse(s) != null;
  }

  Future<void> onDone() async {
    setState(() {loading = true;});
    ItemModel item = await createItem();
    widget.wishlist.items.add(item);
    await widget.wishlist.uploadList();
    setState(() {loading = false;});
  }

  Future<ItemModel> createItem() async {

    String photoURL = image != null ? await ImageService().uploadImage(image) : '';

    ItemModel item = ItemModel.create(
      wishlist: widget.wishlist,
      itemName: itemController.text,
      cost: double.tryParse(costController.text) ?? 0,
      addedByUID: currentUser.uid,
      description: descriptionController.text,
      photoURL: photoURL,
      hideFromWisher: hideItem,
    );

    return item;
  }

  @override
  Widget build(BuildContext context) {

    currentUser = Provider.of<UserData>(context);
    UserPreferences prefs = UserPreferences.from(currentUser);
    Size size = MediaQuery.of(context).size;

    bool isWisher = currentUser.uid == widget.wishlist.wisherUID;

    return CustomScaffold(
      prefs: prefs,
      backButton: true,
      title: 'New Item',
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• Title',
                style: prefs.text_style_sub_header,
              ),
              SizedBox(height: 5),
              customTextField(
                validator: (val) => val.isNotEmpty ? null : 'Item must have a title',
                prefs: prefs,
                multiline: false,
                controller: itemController,
              ),
              SizedBox(height: 20),
              if(!isWisher) Text(
                '• Hide from wisher?',
                style: prefs.text_style_sub_header,
              ),
              if(!isWisher) SizedBox(height: 5),
              if(!isWisher) SizedBox(
                height: 28,
                child: ToggleButtons(
                  borderColor: prefs.color_comment,
                  fillColor: prefs.color_background,
                  selectedBorderColor: prefs.color_accept,
                  selectedColor: prefs.color_accept,
                  color: prefs.color_accept,
                  highlightColor: prefs.color_splash,
                  hoverColor: prefs.color_splash,
                  focusColor: prefs.color_splash,
                  splashColor: prefs.color_splash,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  isSelected: hideSelected,
                  borderWidth: 2,
                  onPressed: setSelected,
                  children: [
                    SizedBox(
                      width: 60,
                      child: Center(
                        child: Text(
                          'Yes',
                          style: prefs.text_style_bread,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: Center(
                        child: Text(
                          'No',
                          style: prefs.text_style_bread,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if(!isWisher) SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    '• Description',
                    style: prefs.text_style_sub_header,
                  ),
                  SizedBox(width: 10),
                  Text(
                    '(Optional)',
                    style: prefs.text_style_bread,
                  ),
                ],
              ),
              SizedBox(height: 5),
              customTextField(
                prefs: prefs,
                multiline: true,
                controller: descriptionController,
              ),
              SizedBox(height: 20),
              //Row(
              //  children: [
              //    Text(
              //      '• Estimated Cost',
              //      style: prefs.text_style_sub_header,
              //    ),
              //    SizedBox(width: 10),
              //    Text(
              //      '(Optional)',
              //      style: prefs.text_style_bread,
              //    ),
              //  ],
              //),
              //SizedBox(height: 5),
              //customTextField(
              //  prefs: prefs,
              //  multiline: true,
              //  controller: costController,
              //),
              //SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    '• Photo',
                    style: prefs.text_style_sub_header,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '(Optional)',
                      style: prefs.text_style_bread,
                    ),
                  ),
                  customButton(
                    text: image == null ? 'Choose' : 'Remove',
                    onTap: () async {
                      if(image == null) {
                        image = await ImageService().imageFromGallery();
                        setState(() {});
                      } else {
                        image = null;
                        setState(() {});
                      }
                      //showDialog(context: context, builder: (context) => ChoosePhotoDialog(prefs: prefs, callback: (image) {}));
                    },
                    fillColor: image == null ? prefs.color_accept : prefs.color_deny,
                    splashColor: prefs.color_splash,
                    textColor: prefs.color_background,
                  ),
                ],
              ),
              SizedBox(height: 20),
              if(image != null) Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: size.width / 2,
                    maxHeight: size.height / 2,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      image,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              if(AdService.hasAds) SizedBox(height: AdService.adHeight),
            ],
          ),
        ),
      ),
      fab: Padding(
        padding: EdgeInsets.only(bottom: AdService.adHeight),
        child: FloatingActionButton(
          backgroundColor: prefs.color_primary,
          splashColor: prefs.color_splash,
          hoverColor: prefs.color_splash,
          focusColor: prefs.color_splash,
          child: !loading ? Icon(
            Icons.check,
            color: prefs.color_background,
            size: 40,
          ) : SpinKitThreeBounce(
            color: prefs.color_background,
            size: 20,
          ),
          onPressed: () async {
            if(currentUser != null && _formKey.currentState.validate()) {
              await onDone();
              Navigator.pop(context);
            } else debug('Current user is null');
            //Navigator.push(context, MaterialPageRoute(builder: (context) => CreateWishlistScreen()));
          },
        ),
      ),
    );
  }

  void setSelected(int index) {
    hideItem = index == 0;
    hideSelected = [hideItem, !hideItem];
    setState(() {});
  }

}
