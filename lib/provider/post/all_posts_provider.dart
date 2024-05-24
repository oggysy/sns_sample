import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sns_sample/model/post.dart';

final allPostsProvider = StreamProvider.autoDispose<List<Post>>(
  (ref) {
    final controller = StreamController<List<Post>>();
    final sub = FirebaseFirestore.instance
        .collection(
          'post',
        )
        .orderBy(
          'created_time',
          descending: true,
        )
        .snapshots()
        .listen(
      (snapshots) {
        final posts = snapshots.docs.map(
          (doc) {
            Map<String, dynamic> data = doc.data();
            return Post(
              id: doc.id,
              content: data['content'],
              postAccountId: data['post_account_id'],
              createdTime: data['created_time'],
              imagePath: data['image_path'],
            );
          },
        ).toList();
        controller.sink.add(posts);
      },
    );

    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });

    return controller.stream;
  },
);
