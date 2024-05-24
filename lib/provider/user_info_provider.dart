import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sns_sample/model/account.dart';

final userInfoProvider =
    StreamProvider.family.autoDispose<Account, String>((ref, accountId) {
  // return UserFirestore.getPostUserMap(accountId);
  final firestoreInstance = FirebaseFirestore.instance;
  final CollectionReference users = firestoreInstance.collection('users');
  final controller = StreamController<Account>();

  final sub = users.doc(accountId).snapshots().listen((doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    Account account = Account(
        id: accountId,
        name: data['name'],
        userId: data['user_id'],
        selfIntroduction: data['self_introduction'],
        imagePath: data['image_path'],
        createdTime: data['created_time'],
        updatedTime: data['updated_time']);

    controller.sink.add(account);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
