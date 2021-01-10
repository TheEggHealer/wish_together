import 'package:wishtogether/models/user_data.dart';

class GlobalMemory {

  static Map<String, UserData> _currentlyLoadedUsers = {};

  static get currentlyLoadedUsers {
    _currentlyLoadedUsers.forEach((uid, user) {
      if(user.fetchAgain()) {
        user.timeFetched = DateTime.now();
        user.fetch();
      }
    });
    return _currentlyLoadedUsers;
  }

  //TODO All loading of users should happen here. Currently it happens in solo_wishlist_screen, item_card, item_screen

}