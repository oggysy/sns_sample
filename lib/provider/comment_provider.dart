import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sns_sample/model/comment.dart';

final allCommentsProvider =
    StreamProvider.family.autoDispose<List<Comment>, String>(
  (ref, String postId) {
    final controller = StreamController<List<Comment>>();
    final sub = FirebaseFirestore.instance
        .collection('post')
        .doc(postId)
        .collection('comment')
        .orderBy(
          'created_time',
        )
        .snapshots()
        .listen(
      (snapshots) {
        final comments = snapshots.docs.map(
          (doc) {
            Map<String, dynamic> data = doc.data();
            return Comment(
              id: doc.id,
              content: data['content'],
              commentAccountId: data['comment_account_id'],
              createdTime: data['created_time'],
            );
          },
        ).toList();
        controller.sink.add(comments);
      },
    );

    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });

    return controller.stream;
  },
);
