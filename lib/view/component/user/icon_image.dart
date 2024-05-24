import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sns_sample/provider/user_info_provider.dart';

class IconImage extends ConsumerWidget {
  const IconImage({super.key, required this.uid});

  final String uid;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(userInfoProvider(uid));
    return userInfo.when(
      data: (data) {
        return CircleAvatar(
          radius: 22,
          foregroundImage: NetworkImage(data.imagePath),
        );
      },
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const CircleAvatar(
        radius: 22,
      ),
    );
  }
}
