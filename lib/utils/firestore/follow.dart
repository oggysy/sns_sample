import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sns_sample/utils/firestore/authenticator.dart';

class FollowFIreStore {
  static Future<void> addfollow(String userId) async {
    final loginUser = Authenticator.userId;
    try {
      final followCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(loginUser)
          .collection('follow');
      followCollection.doc(userId).set(
        {'follow_account_id': userId, 'follow_date': Timestamp.now()},
      );
    } on FirebaseException catch (error) {
      print(error);
    }
  }

  static Future<void> addfollower(String userId) async {
    final loginUser = Authenticator.userId;
    try {
      final followCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('follower');
      followCollection.doc(loginUser).set(
        {'follow_account_id': loginUser, 'follow_date': Timestamp.now()},
      );
    } on FirebaseException catch (error) {
      print(error);
    }
  }

  static Future<void> removefollow(String userId) async {
    final loginUser = Authenticator.userId;
    try {
      final followCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(loginUser)
          .collection('follow');

      followCollection.doc(userId).delete();
    } on FirebaseException catch (error) {
      print(error);
    }
  }

  static Future<void> removefollower(String userId) async {
    final loginUser = Authenticator.userId;
    try {
      final followCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('follower');

      followCollection.doc(loginUser).delete();
    } on FirebaseException catch (error) {
      print(error);
    }
  }

  static Future<List<String>> getFollowList() async {
    final loginUser = Authenticator.userId;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(loginUser)
        .collection('follow')
        .get();
    final followList = snapshot.docs.map((doc) => doc.id).toList();
    return followList;
  }
}
