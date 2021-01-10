import 'package:wishtogether/constants.dart';
import 'package:wishtogether/models/comment_model.dart';
import 'package:wishtogether/models/user_data.dart';
import 'package:wishtogether/models/user_model.dart';
import 'package:wishtogether/models/wishlist_model.dart';

class ItemModel {

  WishlistModel wishlist;
  Map<String, dynamic> raw;
  String itemName;
  List<CommentModel> comments;
  List<CommentModel> hiddenComments;
  int cost;
  List<String> claimedUsers;
  String wisherUID;

  ItemModel({this.raw, this.wishlist, this.wisherUID}) {
    _deconstructData();
  }

  ItemModel.empty() {
    itemName = '--';
    comments = [];
    hiddenComments = [];
    int cost = 0;
    claimedUsers = [];
    wisherUID = 'no_user';
  }

  get commentsAsData => comments.map((comment) => comment.raw).toList();
  get hiddenCommentsAsData => hiddenComments.map((comment) => comment.raw).toList();

  bool shouldBeHiddenFrom(UserData userData) {
    return wisherUID == userData.uid;
  }

  void _deconstructData() {
    debug('Deconstructing item from $raw');
    itemName = raw['item_name'];
    comments = (raw['comments'].map<CommentModel>((e) => CommentModel(raw: e))).toList();
    hiddenComments = (raw['hidden_comments'].map<CommentModel>((e) => CommentModel(raw: e))).toList();
    cost = raw['cost'];
    claimedUsers = List<String>.from(raw['claimed_users']);
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