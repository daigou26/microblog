import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'login.dart';

Login login;

class Post {
  final String _postsCollection = 'posts';

  // 投稿内容
  String text;

  // imageFile
  File imageFile;

  // 投稿した時のクロージャー
  final backToMain;
  final showProgress;
  final dismissProgress;

  // 削除した時のクロージャー
  final setState;

  // 初期設定
  Post({this.text,
    this.imageFile,
    this.backToMain,
    this.showProgress,
    this.dismissProgress,
    this.setState}) {
    login = Login.instance;
  }

  void postFunc() async {
    Uri downloadUrl;

    showProgress();

    if (imageFile != null) {
      // storageに画像を送信
      DateTime dateTimeNow = new DateTime.now();
      int time = dateTimeNow.millisecondsSinceEpoch;

      StorageReference ref = FirebaseStorage.instance.ref().child("${login.uid()}_$time.jpg");
      StorageUploadTask uploadTask = ref.putFile(imageFile);
      downloadUrl = (await uploadTask.future).downloadUrl;
    }

    // firebaseに送信
    String userName = login.displayName();
    String profileImageUrl = login.photoUrl();

    final mainReference = Firestore.instance.collection(_postsCollection).document();
    PostContent postContent = new PostContent(
      text: text,
      imageUrl: downloadUrl.toString(),
      userName: userName,
      profileImageUrl: profileImageUrl,);

    await mainReference.setData(postContent.toJson());

    dismissProgress();
    backToMain();
  }

  void deleteFunc(String postId, String imageUrl) async {
    // 画像を削除
    Match match = new RegExp('${login.uid()}_.*?\.jpg').firstMatch(imageUrl);
    StorageReference ref = FirebaseStorage.instance.ref().child(match.group(0));
    await ref.delete();

    Firestore.instance.collection(_postsCollection).document(postId).delete();

    setState();
  }
}

class PostContent {
  String text;
  String imageUrl;
  String userName;
  String profileImageUrl;
  DateTime dateTimeNow = new DateTime.now();

  PostContent({
    this.text,
    this.imageUrl,
    this.userName,
    this.profileImageUrl});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {
      "uid": login.uid(),
      "date": dateTimeNow.millisecondsSinceEpoch,
      "imageUrl": imageUrl,
      "userName": userName,
    };

    if (text != null && text != "") {
      result.addAll({
        "text": text,
      });
    }

    if (profileImageUrl != null) {
      result.addAll({
        "profileImageUrl": profileImageUrl,
      });
    }

    return result;
  }
}
