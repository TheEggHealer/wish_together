import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/wishlist_model.dart';
import 'package:wishtogether/constants.dart';
import 'package:wishtogether/services/notification_service.dart';

class DatabaseService {

  final String uid;

  final CollectionReference userData = FirebaseFirestore.instance.collection('userData');
  final CollectionReference wishlist = FirebaseFirestore.instance.collection('wishlists');
  final CollectionReference uuidMaps = FirebaseFirestore.instance.collection('uuidMaps');

  DatabaseService({this.uid});

  Future forceData(CollectionReference collection, String documentId, Map<String, dynamic> data) async {
    _printUpload(collection, data);
    return await collection.doc(documentId).set(data);
  }

  Future uploadData(CollectionReference collection, String documentId, Map<String, dynamic> data) async {
   _printUpload(collection, data);
    return await collection.doc(documentId).set(data, SetOptions(merge: true));
  }

  void _printUpload(CollectionReference collection, Map<String, dynamic> data) {
    debug("=========== UPLOADING DATA ===========");
    debug("==== To collection: ${collection.id}");
    data.forEach((key, value) {debug("==== $key -> $value");});
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

  List<WishlistModel> _wishlistFromQuery(QuerySnapshot query) {
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
          _wishlistFromQuery);
      return stream;
    } else {
      return Stream<List<WishlistModel>>.empty();
    }
  }

  Stream<WishlistModel> wishlistStream(String id) {
    Stream<WishlistModel> stream = wishlist.where(
      FieldPath.documentId, isEqualTo: id
    ).snapshots().map((e) => _wishlistFromQuery(e).first);
    return stream;
  }

  Future<WishlistModel> getWishlist(String id) async {
    DocumentSnapshot doc = await wishlist.doc(id).get();
    WishlistModel model = WishlistModel(raw: doc.data(), id: id);
    return model;
  }

  Future<String> uidFromEmail(String email) async {
    DocumentSnapshot doc = await uuidMaps.doc('mailToUUID').get();
    Map<String, dynamic> data = doc.data();
    String uid = data.containsKey(email) ? data[email] : '';
    return uid;
  }

  Future changeMailToUIDAssociation(String oldMail, String newMail) async {
    String uid = await uidFromEmail(oldMail);

    uploadData(uuidMaps, 'byMail', {oldMail: FieldValue.delete(), newMail: uid});
  }
  
  Future mapUID(String mail, String uid) async {
    //uploadData(uuidMaps, 'mailToUUID', {mail: uid});
    addToken(uid);
  }

  Future addToken(String uid) async {
    DocumentSnapshot doc = await uuidMaps.doc('notificationTokenToUUID').get(GetOptions(source: Source.server));

    String token = await NotificationService().getToken();
    uploadData(uuidMaps, 'notificationTokenToUUID', {token: uid});
  }

  Future removeToken(String uid) async {
    DocumentSnapshot doc = await uuidMaps.doc('notificationTokenToUUID').get(GetOptions(source: Source.server));

    String token = await NotificationService().getToken();
    uploadData(uuidMaps, 'notificationTokenToUUID', {token: FieldValue.delete()});
  }

  Future<List<String>> getTokensFor(String uid) async {
    DocumentSnapshot doc = await uuidMaps.doc('notificationTokenToUUID').get();
    Map<String, dynamic> data = doc.data();
    return List<String>.from(
      data.entries.map((entry) => entry.value == uid ? entry.key : null).where((element) => element != null)
    );
  }

}