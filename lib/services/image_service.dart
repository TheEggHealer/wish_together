import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:path/path.dart' as p;


class ImageService {

  final picker = ImagePicker(); //TODO According to the pub.dev for this package (https://pub.dev/packages/image_picker), it sometimes closes the Main Activity. Look into this!

  Future<File> imageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery, imageQuality: 30);
    return File(pickedFile.path);
  }

  Future<File> imageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera, imageQuality: 30);
    return File(pickedFile.path);
  }

  ///Returns the firestore url to the uploaded image
  Future<String> uploadImage(File image) async {
    debug('Uploading image to FirebaseFirestore');
    String fileName = '${Uuid().v1()}+${p.basename(image.path)}';
    Reference ref = FirebaseStorage.instance.ref().child('images/$fileName');
    TaskSnapshot uploadTask = await ref.putFile(image);
    return await uploadTask.ref.getDownloadURL();
  }

}