import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String id;
  String content;
  String commentAccountId;
  Timestamp? createdTime;

  Comment({
    this.id = '',
    this.content = '',
    this.commentAccountId = '',
    this.createdTime,
  });
}
