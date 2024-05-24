import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sns_sample/model/account.dart';
import 'package:sns_sample/provider/post/user_post_provider.dart';
import 'package:sns_sample/utils/authentication.dart';
import 'package:sns_sample/utils/firestore/authenticator.dart';
import 'package:sns_sample/view/account/edit_account_page.dart';
import 'package:sns_sample/view/component/follow/follow_count_view.dart';
import 'package:sns_sample/view/component/follow/follower_count_view.dart';
import 'package:sns_sample/view/component/time_line_contents.dart';
import 'package:sns_sample/view/time_line/time_line_detail.dart';

class MyAccountPage extends ConsumerStatefulWidget {
  const MyAccountPage({super.key});

  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends ConsumerState<MyAccountPage> {
  Account myAccount = Authentication.myAccount!;

  @override
  Widget build(BuildContext context) {
    final postList = ref.watch(userPostsProvider(Authenticator.userId!));
    return Scaffold(
      appBar: AppBar(
        title: const Text('マイアカウント'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 15, left: 15, top: 20),
                  height: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 32,
                                foregroundImage:
                                    NetworkImage(myAccount.imagePath),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    myAccount.name,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '@${myAccount.userId}',
                                    style: const TextStyle(color: Colors.grey),
                                  )
                                ],
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              var result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) =>
                                          const EditAccountPage()));
                              if (result == true) {
                                setState(() {
                                  myAccount = Authentication.myAccount!;
                                });
                              }
                            },
                            child: const Text('編集'),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(myAccount.selfIntroduction),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FollowCountView(userId: myAccount.id),
                          const Text(
                            'フォロー中',
                            style: TextStyle(fontSize: 9),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          FollowerCountView(userId: myAccount.id),
                          const Text(
                            'フォロワー',
                            style: TextStyle(fontSize: 9),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.blue, width: 3),
                    ),
                  ),
                  child: const Text(
                    '投稿',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: postList.when(
                    data: (datas) {
                      return ListView.builder(
                        itemCount: datas.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TimeLineDetail(
                                    postData: datas[index],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: index == 0
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
                              child: TimeLineContents(post: datas[index]),
                            ),
                          );
                        },
                      );
                    },
                    error: (error, stack) => Text(error.toString()),
                    loading: () => const CircularProgressIndicator(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
