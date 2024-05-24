import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sns_sample/model/post.dart';
import 'package:sns_sample/utils/firestore/follow.dart';

final followPostsProvider = StreamProvider.autoDispose<List<Post>>(
  (ref) async* {
    final followList = await FollowFIreStore.getFollowList();
    if (followList.isEmpty) {
      yield [];
    } else {


      await for (final snapshots in FirebaseFirestore.instance
          .collection('post')
          .orderBy('created_time', descending: true)
          .where('post_account_id', whereIn: followList)
          .snapshots()) {
        final posts = snapshots.docs.map(
          (doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return Post(
              id: doc.id,
              content: data['content'],
              postAccountId: data['post_account_id'],
              createdTime: data['created_time'],
              imagePath: data['image_path'],
            );
          },
        ).toList();
        yield posts;
      }
    }
  },
);
