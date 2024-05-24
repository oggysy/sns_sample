import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sns_sample/model/account.dart';
import 'package:sns_sample/utils/authentication.dart';

class UserFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference users =
      _firestoreInstance.collection('users');

  static Future<dynamic> setUser(Account newAccount) async {
    try {
      await users.doc(newAccount.id).set({
        'name': newAccount.name,
        'user_id': newAccount.userId,
        'self_introduction': newAccount.selfIntroduction,
        'image_path': newAccount.imagePath,
        'created_time': Timestamp.now(),
        'updated_time': Timestamp.now(),
      });
      print('新規作成完了');
      return true;
    } on FirebaseException catch (error) {
      print('新規ユーザー作成失敗$error');
      return false;
    }
  }

  static Future<dynamic> getUser(String uid) async {
    try {
      DocumentSnapshot documentSnapshot = await users.doc(uid).get();
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      Account myAccount = Account(
          id: uid,
          name: data['name'],
          userId: data['user_id'],
          selfIntroduction: data['self_introduction'],
          imagePath: data['image_path'],
          createdTime: data['created_time'],
          updatedTime: data['updated_time']);
      Authentication.myAccount = myAccount;
      print('ユーザー取得完了');
      return true;
    } on FirebaseException catch (error) {
      print(error);
      return false;
    }
  }

  static Future<dynamic> updateUser(Account updateAccount) async {
    try {
      await users.doc(updateAccount.id).update({
        'name': updateAccount.name,
        'image_path': updateAccount.imagePath,
        'user_id': updateAccount.userId,
        'self_introduction': updateAccount.selfIntroduction,
        'updated_time': Timestamp.now()
      });
      print('更新完了');
      return true;
    } on FirebaseException catch (error) {
      print(error);
      return false;
    }
  }

  // static Future<Map<String, Account>?> getPostUserMap(
  //     List<String> accountIds) async {
  //   Map<String, Account> map = {};
  //   try {
  //     await Future.forEach(accountIds, (String accountId) async {
  //       var doc = await users.doc(accountId).get();
  //       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //       Account postAccount = Account(
  //         id: accountId,
  //         name: data['name'],
  //         userId: data['user_id'],
  //         imagePath: data['image_path'],
  //         selfIntroduction: data['self_introduction'],
  //         createdTime: data['created_time'],
  //         updatedTime: data['updated_time'],
  //       );
  //       map[accountId] = postAccount;
  //     });
  //     print('投稿ユーザーの取得完了');
  //     return map;
  //   } on FirebaseException catch (error) {
  //     print('取得エラー:$error');
  //     return null;
  //   }
  // }

  static Future<Account> getPostUserMap(String accountId) async {
    try {
      var doc = await users.doc(accountId).get();
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Account(
        id: accountId,
        name: data['name'],
        userId: data['user_id'],
        imagePath: data['image_path'],
        selfIntroduction: data['self_introduction'],
        createdTime: data['created_time'],
        updatedTime: data['updated_time'],
      );
    } on FirebaseException catch (error) {
      print('取得エラー:$error');
      return Account();
    }
  }
}
