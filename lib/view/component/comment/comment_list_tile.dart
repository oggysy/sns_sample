import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sns_sample/model/comment.dart';
import 'package:sns_sample/provider/user_info_provider.dart';

class CommentListTile extends ConsumerWidget {
  const CommentListTile({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAccountInfo =
        ref.watch(userInfoProvider(comment.commentAccountId));

    return Padding(
        padding: const EdgeInsets.all(6.0),
        child: postAccountInfo.when(
            data: (data) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 22,
                    foregroundImage: NetworkImage(data.imagePath),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '@${data.userId}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const Spacer(),
                            Text(DateFormat('M月dd日')
                                .format(comment.createdTime!.toDate())),
                          ],
                        ),
                        Text(comment.content),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            error: (error, stack) => Text(error.toString()),
            loading: () => Container()));
  }
}
