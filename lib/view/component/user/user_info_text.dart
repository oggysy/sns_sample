import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sns_sample/provider/user_info_provider.dart';

class UserInfoRow extends ConsumerWidget {
  const UserInfoRow({super.key, required this.uid, required this.date});

  final String uid;
  final DateTime date;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoProvider(uid));
    return userInfo.when(
      data: (data) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              data.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '@${data.userId}',
              style: const TextStyle(color: Colors.grey),
            ),
            const Spacer(),
            Text(DateFormat('M月dd日').format(date)),
          ],
        );
      },
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const CircleAvatar(
        radius: 22,
      ),
    );
  }
}
