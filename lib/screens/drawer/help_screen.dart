import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_preferences.dart';
import 'package:wishtogether/ui/widgets/custom_scaffold.dart';
import 'package:wishtogether/ui/widgets/empty_list.dart';
import 'package:wishtogether/ui/widgets/help_cards/help_card.dart';
import 'package:wishtogether/ui/widgets/help_cards/help_card_home.dart';
import 'package:wishtogether/ui/widgets/help_cards/help_card_items.dart';
import 'package:wishtogether/ui/widgets/help_cards/help_card_wishlists.dart';

class HelpScreen extends StatefulWidget {

  int initScreen;

  HelpScreen({this.initScreen});

  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {

  UserData currentUser;
  PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.initScreen);
  }

  @override
  Widget build(BuildContext context) {

    currentUser = Provider.of<UserData>(context);
    UserPreferences prefs = UserPreferences.from(currentUser);
    Size size = MediaQuery.of(context).size;

    List<Widget> items = [
      HelpCardHome(
        prefs: prefs,
      ),
      HelpCardWishlists(
        prefs: prefs,
      ),
      HelpCardItems(
        prefs: prefs,
      ),

    ];

    return CustomScaffold(
      prefs: prefs,
      backButton: true,
      title: 'Help',
      padding: false,
      body: Container(
        child: Column(
          children: [
            Container(
              width: size.width,
              height: size.height * 0.8,
              child: PageView(
                children: items,
                controller: _controller,
              ),
            ),
            SmoothPageIndicator(
              controller: _controller,
              count: items.length,
              effect: ScrollingDotsEffect(
                radius: 4,
                dotHeight: 6,
                dotWidth: 6,
                activeDotColor: prefs.color_primary,
                dotColor: prefs.color_soft,
                activeDotScale: 1.5,
                maxVisibleDots: 5,
                spacing: 8,
              ),
            )
          ],
        ),
      ),
    );
  }
}
