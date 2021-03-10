import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/comment_model.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_model.dart';
import 'package:wishtogether/models/wishlist_model.dart';

class ItemModel {

  WishlistModel wishlist;
  Map<String, dynamic> raw;
  String itemName;
  String description = '';
  List<CommentModel> comments;
  List<CommentModel> hiddenComments;
  double cost; //-1 if no cost is set
  List<String> claimedUsers;
  String wisherUID;
  String addedByUID;

  ItemModel({this.raw, this.wishlist, this.wisherUID}) {
    _deconstructData();
  }

  ItemModel.empty() {
    itemName = '--';
    description = '';
    comments = [];
    hiddenComments = [];
    cost = -1;
    claimedUsers = [];
    wisherUID = 'no_user';
  }

  ItemModel.create({this.wishlist, this.itemName, this.cost, this.addedByUID, this.description}) {
    wisherUID = wishlist.wisherUID;
    comments = [];
    hiddenComments = [];
    claimedUsers = [];
  }

  get commentsAsData => comments.map((comment) => comment.raw).toList();
  get hiddenCommentsAsData => hiddenComments.map((comment) => comment.raw).toList();

  bool shouldBeHiddenFrom(UserData userData) {
    return wisherUID == userData.uid;
  }

  UserData get wisherUserData {

  }

  void _deconstructData() {
    itemName = raw['item_name'];
    comments = (raw['comments'].map<CommentModel>((e) => CommentModel(raw: e))).toList();
    hiddenComments = (raw['hidden_comments'].map<CommentModel>((e) => CommentModel(raw: e))).toList();
    cost = double.parse(raw['cost'].toString());
    claimedUsers = List<String>.from(raw['claimed_users']);
    addedByUID = raw['added_by_uid'] ?? '';
    description = raw['description'] ?? '';
  }

  toggleUserClaim(UserData user) {
    if(claimedUsers.contains(user.uid)) claimedUsers.remove(user.uid);
    else claimedUsers.add(user.uid);
    wishlist.uploadList();
  }

  addComment(String content, UserData user, bool hidden) async {
    CommentModel comment = await CommentModel.from(content, user);
    if(hidden) hiddenComments.add(comment);
    else comments.add(comment);
    wishlist.uploadList();
  }

}