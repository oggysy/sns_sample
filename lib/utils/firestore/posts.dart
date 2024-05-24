import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sns_sample/model/post.dart';

class PostFirestore {
  static final _firebaseInstance = FirebaseFirestore.instance;

  static final CollectionReference posts = _firebaseInstance.collection('post');

  static Future<dynamic> addPost(Post newPost) async {
    try {
      final CollectionReference _userPosts = _firebaseInstance
          .collection('users')
          .doc(newPost.postAccountId)
          .collection('my_post');
      var result = await posts.add({
        'content': newPost.content,
        'post_account_id': newPost.postAccountId,
        'created_time': Timestamp.now(),
        'image_path': newPost.imagePath,
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

  // static Future<List<Post>?> getPostsFromIds(List<String> ids) async {
  //   List<Post> postList = [];
  //   try {
  //     await Future.forEach(ids, (String id) async {
  //       var doc = await posts.doc(id).get();
  //       if (!doc.exists) {
  //         return postList;
  //       }
  //       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //       Post post = Post(
  //         id: doc.id,
  //         content: data['content'],
  //         postAccountId: data['post_account_id'],
  //         createdTime: data['created_time'],
  //       );
  //       postList.add(post);
  //     });
  //     return postList;
  //   } on FirebaseException catch (error) {
  //     print(error);
  //     return null;
  //   }
  // }

  static Future<bool> addLikeCount(bool isLiked, String id) async {
    var doc = posts.doc(id);
    var count = await doc.get();
    Map<String, dynamic> data = count.data() as Map<String, dynamic>;
    var c = data['like_count'] as int;
    var increment = c + 1;
    doc.update({'like_count': increment});
    return !isLiked;
  }
}
