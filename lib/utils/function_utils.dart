import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:uuid/uuid.dart';

class FunctionUtils {
  static Future<dynamic> getImageForGallery() async {
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
  }

  static Future<String> uploadImage(String uid, File image) async {
    var uuid = Uuid().v4();
    final img.Image? originalImage =
        img.decodeImage(File(image.path).readAsBytesSync());
    final img.Image resizedImage = img.copyResize(originalImage!, width: 300);
    final List<int> resizedBytes = img.encodeBmp(resizedImage);
    final Uint8List resizedUint8List = Uint8List.fromList(resizedBytes);
    final FirebaseStorage storageInstance = FirebaseStorage.instance;
    final Reference ref = storageInstance.ref();
    await ref.child('$uid/$uuid').putData(resizedUint8List);
    String downloadUrl =
        await storageInstance.ref().child('$uid/$uuid').getDownloadURL();
    return downloadUrl;
  }

  static Future<String> uploadProfileImage(String uid, File image) async {
    final img.Image? originalImage =
        img.decodeImage(File(image.path).readAsBytesSync());
    final img.Image resizedImage = img.copyResize(originalImage!, width: 300);
    final List<int> resizedBytes = img.encodeBmp(resizedImage);
    final Uint8List resizedUint8List = Uint8List.fromList(resizedBytes);
    final FirebaseStorage storageInstance = FirebaseStorage.instance;
    final Reference ref = storageInstance.ref();
    await ref.child('$uid/profileImage').putData(resizedUint8List);
    String downloadUrl =
        await storageInstance.ref().child('$uid/profileImage').getDownloadURL();
    return downloadUrl;
  }

  // static Future<bool> hasLike(String postId) async {
  //   final currentUserId = Authenticator.userId;
  //   var resulut = false;

  //   final a = FirebaseFirestore.instance
  //       .collection('post')
  //       .doc(postId)
  //       .collection('like_user')
  //       .snapshots();
  // }
}
