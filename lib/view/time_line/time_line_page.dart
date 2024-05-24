import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sns_sample/provider/post/all_posts_provider.dart';
import 'package:sns_sample/view/component/time_line_contents.dart';
import 'package:sns_sample/view/time_line/time_line_detail.dart';

class TimeLinePage extends ConsumerStatefulWidget {
  const TimeLinePage({super.key});

  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class _TimeLinePageState extends ConsumerState<TimeLinePage> {
  @override
  Widget build(BuildContext context) {
    final postList = ref.watch(allPostsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('タイムライン'),
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
