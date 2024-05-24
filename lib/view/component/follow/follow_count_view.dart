import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:sns_sample/provider/follow/follow_count_provider.dart';

class FollowCountView extends ConsumerWidget {
  final String userId;
  const FollowCountView({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followCount = ref.watch(followCountProvider(userId));
    return followCount.when(
      data: (int followCount) {
        return Text(followCount.toString());
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
