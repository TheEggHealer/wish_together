import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/user_data.dart';

class ImageService {

  Future<String> getProfilePicture(UserData user) async {
    debug('Loading profile picture for ${user.name}');
    String url = await FirebaseStorage.instance.ref().child('profile_pictures/${user.uid}.jpg').getDownloadURL();
    debug(url);
    return url;
  }

}