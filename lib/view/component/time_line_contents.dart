import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sns_sample/model/post.dart';
import 'package:sns_sample/provider/user_info_provider.dart';
import 'package:sns_sample/utils/firestore/authenticator.dart';
import 'package:sns_sample/view/account/my_account_page.dart';
import 'package:sns_sample/view/account/ohter_account_page.dart';
import 'package:sns_sample/view/component/comment/comment_count_view.dart';
import 'package:sns_sample/view/component/like/like_button.dart';
import 'package:sns_sample/view/component/like/like_count_view.dart';
import 'package:sns_sample/view/component/user/icon_image.dart';
import 'package:sns_sample/view/component/user/user_info_text.dart';

class TimeLineContents extends ConsumerWidget {
  const TimeLineContents({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAccountInfo = ref.watch(userInfoProvider(post.postAccountId));

    return Padding(
        padding: const EdgeInsets.all(6.0),
        child: postAccountInfo.when(
            data: (data) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      final loginUser = Authenticator.userId;
                      final isMyAccount = loginUser == data.id;
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        if (isMyAccount) {
                          return const MyAccountPage();
                        } else {
                          return OtherAccountPage(account: data);
                        }
                      }));
                    },
                    child: IconImage(uid: data.id),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UserInfoRow(
                            uid: data.id, date: post.createdTime!.toDate()),
                        Text(post.content),
                        const SizedBox(
                          height: 5,
                        ),
                        if (post.imagePath != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image(
                                    image: NetworkImage(post.imagePath!))),
                          ),
                        Row(
                          children: [
                            LikesButton(
                              postId: post.id,
                            ),
                            LikesCountView(postId: post.id),
                            const SizedBox(
                              width: 12,
                            ),
                            GestureDetector(
                                child: const Icon(
                                  Icons.mode_comment_outlined,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                onTap: () {
                                  print('tap');
                                }),
                            const SizedBox(
                              width: 6,
                            ),
                            CommentCountView(postId: post.id),
                          ],
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
