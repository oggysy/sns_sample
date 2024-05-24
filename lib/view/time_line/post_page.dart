import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sns_sample/model/post.dart';
import 'package:sns_sample/utils/authentication.dart';
import 'package:sns_sample/utils/firestore/authenticator.dart';
import 'package:sns_sample/utils/firestore/posts.dart';
import 'package:sns_sample/utils/function_utils.dart';
import 'package:sns_sample/view/component/dialog/error_dialog.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  File? selectedImage;
  TextEditingController contentController = TextEditingController();
  bool buttonIsDisabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '新規投稿',
        ),
        actions: [
          IconButton(
              onPressed: buttonIsDisabled
                  ? () async {
                      setState(() {
                        buttonIsDisabled = false;
                      });
                      if (contentController.text.isNotEmpty) {
                        String? imagePath;
                        if (selectedImage != null) {
                          final uid = Authenticator.userId;
                          imagePath = await FunctionUtils.uploadImage(
                              uid!, selectedImage!);
                        }
                        Post newPost = Post(
                            content: contentController.text,
                            postAccountId: Authentication.myAccount!.id,
                            imagePath: imagePath);
                        var result = await PostFirestore.addPost(newPost);
                        if (result == true) {
                          Navigator.pop(context);
                        } else {
                          showDialog(
                              context: context,
                              builder: (_) => ErrorAlertDialog());
                        }
                      }
                    }
                  : null,
              icon: const Icon(Icons.send))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              selectedImage != null
                  ? Image(image: FileImage(selectedImage!))
                  : Container(),
              TextField(
                controller: contentController,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  final image = await FunctionUtils.getImageForGallery();
                  if (image != null) {
                    setState(() {
                      selectedImage = File(image.path);
                    });
                  }
                },
                child: const Text('画像を追加する'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
