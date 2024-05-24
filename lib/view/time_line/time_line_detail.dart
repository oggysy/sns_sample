import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sns_sample/model/post.dart';
import 'package:sns_sample/provider/user_info_provider.dart';
import 'package:sns_sample/utils/firestore/comment.dart';
import 'package:sns_sample/view/component/comment/comment_list.dart';
import 'package:sns_sample/view/component/like/like_button.dart';
import 'package:sns_sample/view/component/like/like_count_view.dart';

class TimeLineDetail extends ConsumerStatefulWidget {
  const TimeLineDetail({super.key, required this.postData});

  final Post postData;

  @override
  TimeLineDetailState createState() => TimeLineDetailState();
}

class TimeLineDetailState extends ConsumerState<TimeLineDetail> {
  TextEditingController commentController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool buttonIsDisabled = true;

  @override
  Widget build(BuildContext context) {
    final postAccountInfo =
        ref.watch(userInfoProvider(widget.postData.postAccountId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('ポスト'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: postAccountInfo.when(
            data: (userData) {
              return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                      foregroundImage:
                                          NetworkImage(userData.imagePath)),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    userData.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '@${userData.userId}',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const Spacer(),
                                  Text(DateFormat('M月dd日').format(
                                      widget.postData.createdTime!.toDate())),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                widget.postData.content,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            if (widget.postData.imagePath != null)
                              Container(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 20),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image(
                                      image: NetworkImage(
                                          widget.postData.imagePath!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  LikesButton(postId: widget.postData.id),
                                  LikesCountView(postId: widget.postData.id)
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Divider(),
                            CommnetList(postId: widget.postData.id),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 60,
                      color: Colors.black38,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: buttonIsDisabled
                                    ? () async {
                                        if (commentController.text.isNotEmpty) {
                                          setState(() {
                                            buttonIsDisabled = false;
                                          });
                                          final commentText =
                                              commentController.text;
                                          await CommentFireStore.addComment(
                                              commentText, widget.postData);
                                          commentController.text = '';
                                          FocusScope.of(context).unfocus();
                                          scrollController.animateTo(
                                            scrollController
                                                    .position.maxScrollExtent -
                                                300,
                                            duration: const Duration(
                                                milliseconds: 600),
                                            curve: Curves.easeOut,
                                          );
                                          buttonIsDisabled = true;
                                        }
                                      }
                                    : null,
                                icon: const Icon(
                                  Icons.send_outlined,
                                  color: Colors.blue,
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: TextField(
                                    controller: commentController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '返信をポスト',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            error: (error, stack) => Text(error.toString()),
            loading: () => const CircularProgressIndicator()),
      ),
    );
  }
}
