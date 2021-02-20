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

  static Future<UserData> getUserData(String uid, {bool forceFetch = false}) async {
    Map<String, UserData> loaded = currentlyLoadedUsers;
    if(!forceFetch && loaded.containsKey(uid)) {
      return loaded[uid];
    } else {
      UserData userData = await UserData.from(uid);
      _currentlyLoadedUsers.putIfAbsent(uid, () => userData);
      return userData;
    }
  }

  //TODO All loading of users should happen here. Currently it happens in solo_wishlist_screen, item_card, item_screen

}