import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:sns_sample/provider/follow/check_follow_provider.dart';
import 'package:sns_sample/utils/firestore/follow.dart';

class FollowButton extends ConsumerWidget {
  final String userId;
  const FollowButton({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFollowed = ref.watch(checkFollowProvider(userId));
    return isFollowed.when(
      data: (bool followed) {
        return ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: followed ? Colors.grey : Colors.blue),
            onPressed: () {
              if (followed) {
                FollowFIreStore.removefollow(userId);
                FollowFIreStore.removefollower(userId);
              } else {
                FollowFIreStore.addfollow(userId);
                FollowFIreStore.addfollower(userId);
              }
            },
            child: Text(followed ? 'フォロー解除' : 'フォローする'));
      },
      error: (error, stackTrace) => Text(error.toString()),
      loading: () {
        return Text('load');
      },
    );
  }
}
