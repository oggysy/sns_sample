import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sns_sample/utils/firestore/authenticator.dart';

class LikeFireStore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference users =
      _firestoreInstance.collection('users');
  static final CollectionReference posts =
      _firestoreInstance.collection('post');

  // ログインしているユーザーのドキュメントのサブコレクション(my_liked)に追加
  static Future<void> addLikedList(String postId) async {
    final loginUser = Authenticator.userId;
    await posts
        .doc(postId)
        .collection('like_user')
        .doc(loginUser)
        .set({'liked_user_name': loginUser});
  }

  static Future<bool> removeLike(String postId) async {
    final loginUser = Authenticator.userId;
    await posts.doc(postId).collection('like_user').doc(loginUser).delete();
    return false;
  }

  // static Future<List<String>> getLikedList() {
  //   List<String> likedList = [];
  //   final a = users.doc(userId).collection('my_liked').get();
  //   print(a);
  // }
}
