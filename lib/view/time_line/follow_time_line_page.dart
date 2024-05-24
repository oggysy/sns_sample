import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sns_sample/provider/follow/follw_post_provider.dart';
import 'package:sns_sample/view/component/time_line_contents.dart';
import 'package:sns_sample/view/time_line/time_line_detail.dart';

class FollowTimeLinePage extends ConsumerStatefulWidget {
  const FollowTimeLinePage({super.key});

  @override
  _FollowTimeLinePageState createState() => _FollowTimeLinePageState();
}

class _FollowTimeLinePageState extends ConsumerState<FollowTimeLinePage> {
  @override
  Widget build(BuildContext context) {
    final postList = ref.watch(followPostsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('フォロー中'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: postList.when(
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
                                top: BorderSide(color: Colors.grey, width: 0),
                                bottom:
                                    BorderSide(color: Colors.grey, width: 0))
                            : const Border(
                                bottom:
                                    BorderSide(color: Colors.grey, width: 0))),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: TimeLineContents(post: datas[index]),
                  ),
                );
              });
        },
        error: (error, stack) => Text(error.toString()),
        loading: () => const CircularProgressIndicator(),
      ),
    );
  }
}
