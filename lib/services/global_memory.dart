import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/user_data.dart';

class GlobalMemory {

  static Map<String, UserData> _currentlyLoadedUsers = {};

  static get currentlyLoadedUsers {
    _currentlyLoadedUsers.forEach((uid, user) {
      if(user.fetchAgain()) {
        debug('Fetching for: $uid');
        user.timeFetched = DateTime.now();
        user.fetch();
      }
    });
    return _currentlyLoadedUsers;
  }

  static Future<UserData> getUserData(String uid, {bool forceFetch = false}) async {
    if(['0', '1', '2'].contains(uid)) return UserData.tmp();
    
    Map<String, UserData> loaded = currentlyLoadedUsers;
    if(!forceFetch && loaded.containsKey(uid)) {
      return loaded[uid];
    } else {
      UserData userData = await UserData.from(uid);
      _currentlyLoadedUsers[uid] = userData;
      return userData;
    }
  }

}