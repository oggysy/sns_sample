import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sns_sample/model/post.dart';
import 'package:sns_sample/utils/firestore/authenticator.dart';

class CommentFireStore {
  static final _firebaseInstance = FirebaseFirestore.instance;

  static Future<dynamic> addComment(String commentText, Post post) async {
    try {
      final userId = Authenticator.userId;
      final comment = _firebaseInstance
          .collection('post')
          .doc(post.id)
          .collection('comment');

      final CollectionReference _userPosts = _firebaseInstance
          .collection('users')
          .doc(post.postAccountId)
          .collection('my_post');

      var result = await comment.add({
        'content': commentText,
        'comment_account_id': userId,
        'created_time': Timestamp.now(),
      });
      _userPosts.doc(result.id).set({
        'post_id': result.id,
        'created_time': Timestamp.now(),
      });
      return true;
    } on FirebaseException catch (error) {
      print(error);
      return false;
    }
  }
}
