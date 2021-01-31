import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/dialog/color_picker_dialog.dart';
import 'package:wishtogether/ui/custom_icons.dart';
import 'package:wishtogether/ui/widgets/color_chooser_square.dart';
import 'package:wishtogether/ui/widgets/custom_buttons.dart';
import 'package:wishtogether/ui/widgets/custom_textfields.dart';

class CreateWishlistScreen extends StatefulWidget {
  @override
  _CreateWishlistScreenState createState() => _CreateWishlistScreenState();
}

class _CreateWishlistScreenState extends State<CreateWishlistScreen> {

  TextEditingController titleController = TextEditingController();
  Color color = Colors.green[300];
  int toggleIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color_primary,
        elevation: 10,
        title: Text(
          'Create new',
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
                'Title',
                style: textstyle_header,
              ),
              SizedBox(height: 10),
              textFieldComment(
                onChanged: (text) {

                },
                multiline: false,
                controller: titleController,
                textColor: color_text_comment,
                activeColor: color_primary,
                borderColor: color_text_dark_sub,
                errorColor: color_text_error,
                helperText: 'Title for wishlist',
                textStyle: textstyle_comment,
                borderRadius: 30
              ),
              SizedBox(height: 20),
              Text(
                'Color',
                style: textstyle_header,
              ),
              SizedBox(height: 10),
              ColorChooserSquare(
                color: color,
                size: 80,
                radius: 16,
                onTap: () {
                  showDialog(context: context, builder: (context) => ColorPickerDialog(
                    currentColor: color,
                    onDone: (color) {
                      setState(() {
                        this.color = color;
                      });
                    },
                  ));
                },
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Type',
                    style: textstyle_header,
                  ),
                  SizedBox(width: 10,),
                  IconButton(
                    icon: Icon(CustomIcons.help),
                    onPressed: () {},
                    splashRadius: 20,
                  ),
                ],
              ),
              SizedBox(height: 10),
              ToggleSwitch(
                labels: [
                  'Solo',
                  'Group'
                ],
                icons: [
                  CustomIcons.profile,
                  CustomIcons.settings
                ],
                minWidth: 90,
                activeBgColor: color_primary,
                activeFgColor: color_text_light,
                inactiveBgColor: color_text_dark_sub,
                inactiveFgColor: color_text_light,
                onToggle: (index) {
                  setState(() {
                    toggleIndex = index;
                  });
                },
                initialLabelIndex: toggleIndex,
              ),
              SizedBox(height: 20),
              Divider(
                color: color_divider_dark,
                height: 0,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Invited users',
                    style: textstyle_header,
                  ),
                  claimButton(
                    onTap: () {},
                    text: 'Invite',
                    textColor: color_text_light,
                    splashColor: color_splash_light,
                    fillColor: color_claim_green,
                  )
                ],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: color_primary,
        splashColor: color_splash_light,
        hoverColor: color_splash_light,
        focusColor: color_splash_light,
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 30,
        ),
        onPressed: () {
          //Navigator.push(context, MaterialPageRoute(builder: (context) => CreateWishlistScreen()));
        },
      ),
    );
  }
}
