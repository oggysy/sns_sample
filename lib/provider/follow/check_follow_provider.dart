import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sns_sample/utils/firestore/authenticator.dart';

final checkFollowProvider = StreamProvider.family.autoDispose<bool, String>(
  (
    ref,
    String userId,
  ) {
    final loginUserId = Authenticator.userId;
    final controller = StreamController<bool>();

    final sub = FirebaseFirestore.instance
        .collection(
          'users',
        )
        .doc(loginUserId)
        .collection('follow')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isEmpty) {
        controller.add(false);
      } else {
        bool found = false;
        for (var doc in snapshot.docs) {
          if (doc.id == userId) {
            controller.add(true);
            found = true;
            break;
          }
        }

        if (!found) {
          controller.add(false);
        }
      }
    });

    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });

    return controller.stream;
  },
);
