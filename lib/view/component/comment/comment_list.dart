import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sns_sample/provider/comment_provider.dart';
import 'package:sns_sample/view/component/comment/comment_list_tile.dart';

class CommnetList extends ConsumerWidget {
  const CommnetList({super.key, required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentList = ref.watch(allCommentsProvider(postId));

    return Padding(
        padding: const EdgeInsets.all(6.0),
        child: commentList.when(
            data: (datas) {
              if (datas.isNotEmpty) {
                return Column(
                  children: [
                    for (var data in datas)
                      Container(
                        decoration: BoxDecoration(
                            border: data == datas[0]
                                ? const Border(
                                    top: BorderSide(
                                        color: Colors.grey, width: 0),
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 0))
                                : const Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 0))),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        child: CommentListTile(comment: data),
                      )
                  ],
                );
              } else {
                return Container();
              }
            },
            error: (error, stack) => Text(error.toString()),
            loading: () => Container()));
  }
}
