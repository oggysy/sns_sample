import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:sns_sample/provider/post/post_comment_count_provider.dart';

class CommentCountView extends ConsumerWidget {
  final String postId;
  const CommentCountView({
    Key? key,
    required this.postId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentsCount = ref.watch(postCommentsCountProvider(postId));
    return commentsCount.when(
      data: (int likesCount) {
        return Text(likesCount.toString());
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return const Center(
          child: Text('0'),
        );
      },
    );
  }
}
