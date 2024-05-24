import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:sns_sample/provider/like/has_like_provider.dart';
import 'package:sns_sample/utils/firestore/like.dart';

class LikesButton extends ConsumerWidget {
  final String postId;
  const LikesButton({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLiked = ref.watch(hasLikedPostProvider(postId));
    return isLiked.when(
      data: (bool like) {
        return LikeButton(
          isLiked: like,
          onTap: (isLiked) {
            if (isLiked) {
              return LikeFireStore.removeLike(postId);
            }
            // アニメーションが反映されないため結果に関わらずtrueを返す
            LikeFireStore.addLikedList(postId);
            return Future(() => true);
          },
          size: 20,
        );
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return const Center(
          child: LikeButton(
            size: 20,
          ),
        );
      },
    );
  }
}
