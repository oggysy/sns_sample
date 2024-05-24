// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:sns_sample/utils/firestore/authenticator.dart';

// final hasLikeProvider = StreamProvider.family.autoDispose<bool, String>(
//   (
//     ref,
//     String postId,
//   ) {
//     final controller = StreamController<bool>.broadcast();

//     controller.onListen = () {
//       controller.sink.add(false);
//     };
//     final currentUserId = Authenticator.userId;

//     final sub = FirebaseFirestore.instance
//         .collection('post')
//         .doc(postId)
//         .collection('like_user')
//         .snapshots()
//         .listen((snapshot) {
//       bool hasLike = false;
//       for (var doc in snapshot.docs) {
//         if (doc.id == currentUserId) {
//           hasLike = true;
//           break;
//         }
//       }
//       controller.sink.add(hasLike);
//     });

//     ref.onDispose(() {
//       sub.cancel();
//       controller.close();
//     });

//     return controller.stream;
//   },
// );

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sns_sample/utils/firestore/authenticator.dart';

final hasLikedPostProvider = StreamProvider.family.autoDispose<bool, String>(
  (
    ref,
    String postId,
  ) {
    final userId = Authenticator.userId;

    if (userId == null) {
      return Stream<bool>.value(false);
    }

    final controller = StreamController<bool>();

    final sub = FirebaseFirestore.instance
        .collection(
          'post',
        )
        .doc(postId)
        .collection('like_user')
        .where(
          'liked_user_name',
          isEqualTo: userId,
        )
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        controller.add(true);
      } else {
        controller.add(false);
      }
    });

    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });

    return controller.stream;
  },
);
