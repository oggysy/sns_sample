// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:sns_sample/model/account.dart';
// import 'package:sns_sample/model/post.dart';
// import 'package:sns_sample/provider/all_posts_provider.dart';
// import 'package:sns_sample/utils/firestore/posts.dart';
// import 'package:sns_sample/utils/firestore/users.dart';
// import 'package:sns_sample/view/component/time_line_contents.dart';

// class TimeLinePage extends ConsumerStatefulWidget {
//   const TimeLinePage({super.key});

//   @override
//   _TimeLinePageState createState() => _TimeLinePageState();
// }

// class _TimeLinePageState extends ConsumerState<TimeLinePage> {
//   @override
//   Widget build(BuildContext context) {
//     final postList = ref.watch(allPostsProvider);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('タイムライン'),
//         backgroundColor: Theme.of(context).primaryColor,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//           stream: PostFirestore.posts
//               .orderBy('created_time', descending: true)
//               .snapshots(),
//           builder: (context, postSnapshot) {
//             if (postSnapshot.hasData) {
//               List<String> postAccountIds = [];
//               postSnapshot.data!.docs.forEach((doc) {
//                 Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//                 if (!postAccountIds.contains(data['post_account_id'])) {
//                   postAccountIds.add(data['post_account_id']);
//                 }
//               });
//               return FutureBuilder<Map<String, Account>?>(
//                   future: UserFirestore.getPostUserMap(postAccountIds),
//                   builder: (context, userSnapshot) {
//                     if (userSnapshot.hasData &&
//                         userSnapshot.connectionState == ConnectionState.done) {
//                       return ListView.builder(
//                         itemCount: postSnapshot.data!.docs.length,
//                         itemBuilder: (ctx, index) {
//                           Map<String, dynamic> data =
//                               postSnapshot.data!.docs[index].data()
//                                   as Map<String, dynamic>;
//                           Post post = Post(
//                             id: postSnapshot.data!.docs[index].id,
//                             content: data['content'],
//                             postAccountId: data['post_account_id'],
//                             createdTime: data['created_time'],
//                           );
//                           Account postAccount =
//                               userSnapshot.data![post.postAccountId]!;

//                           return Container(
//                             decoration: BoxDecoration(
//                                 border: index == 0
//                                     ? const Border(
//                                         top: BorderSide(
//                                             color: Colors.grey, width: 0),
//                                         bottom: BorderSide(
//                                             color: Colors.grey, width: 0))
//                                     : const Border(
//                                         bottom: BorderSide(
//                                             color: Colors.grey, width: 0))),
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 15),
//                             child: TimeLineContents(
//                                 post: post, postAccount: postAccount),
//                           );
//                         },
//                       );
//                     } else {
//                       return Container();
//                     }
//                   });
//             } else {
//               return Container();
//             }
//           }),
//     );
//   }
// }
