import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/constants.dart';

class DatabaseService {

  final String uid;

  final CollectionReference userData = FirebaseFirestore.instance.collection('userData');
  final CollectionReference wishlist = FirebaseFirestore.instance.collection('wishlists');

  DatabaseService({this.uid});

  Future forceData(CollectionReference collection, Map<String, dynamic> data) async {
    _printUpload(collection, data);
    return await collection.doc(uid).set(data);
  }

  Future uploadData(CollectionReference collection, Map<String, dynamic> data) async {
   _printUpload(collection, data);
    return await collection.doc(uid).set(data, SetOptions(merge: true));
  }

  void _printUpload(CollectionReference collection, Map<String, dynamic> data) {
    debug("=========== UPLOADING DATA ===========");
    debug("==== To collection: ${collection.id}");
    data.forEach((key, value) {print("==== $key -> $value");});
    debug("======================================");
  }

  Future<bool> checkExist(CollectionReference collection) async {
    try {
      bool exists = false;
      await collection.doc(uid).get().then((doc) => exists = doc.exists);
      return exists;
    } catch(e) {
      debug(e.toString());
      return false;
    }
  }

  UserData _userDataFromDocument(DocumentSnapshot snapshot) {
    Map<String, dynamic> raw = snapshot.data();
    UserData data = UserData(
      raw: raw,
      uid: uid,
    );

    return data;
  }

  List<WishlistModel> _wishlistFromDocument(QuerySnapshot query) {
    return query.docs.map((e) => WishlistModel(raw: e.data(), id: e.id)).toList();

  }

  Future<Map<String, dynamic>> getRaw(CollectionReference collection) async {
    DocumentSnapshot snap = await collection.doc(uid).get();
    return snap.data();
  }

  Stream<UserData> get userDocument {
    return userData.doc(uid).snapshots().map(_userDataFromDocument);
  }

  Stream<List<WishlistModel>> wishlistDocs(List<String> ids) {
    if(ids.isNotEmpty) {
      Stream<List<WishlistModel>> stream = wishlist.where(
          FieldPath.documentId, whereIn: ids).snapshots().map(
          _wishlistFromDocument);
      return stream;
    } else {
      return Stream<List<WishlistModel>>.empty();
    }
  }

}