import 'dart:io';
import 'package:flutter/material.dart';
import 'post.dart';

class PostPage extends StatefulWidget {
  final File imageFile;

  PostPage({Key key, this.imageFile}) : super(key: key);

  @override
  _PostPageState createState() => new _PostPageState(imageFile: imageFile);
}

class _PostPageState extends State<PostPage> {
  TextEditingController _controller = new TextEditingController();
  final File imageFile;
  String locationError;

  _PostPageState({Key key, this.imageFile});

  // main画面に戻る
  void _backToMain() {
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  void _showProgress() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new Center(
          child: new SizedBox(
            height: 50.0,
            width: 50.0,
            child: new CircularProgressIndicator(
              value: null,
              strokeWidth: 7.0,
            ),
          ),
        );
      },
    );
  }

  void _dismissProgress() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // シェアボタン
    List<Widget> shareButton = <Widget>[
      new Container(
        margin: const EdgeInsets.all(10.0),
        child: new RaisedButton(
          elevation: 0.0,
          onPressed: () {
            new Post(
              text: _controller.text,
              imageFile: imageFile,
              backToMain: () {
                _backToMain();
              },
              showProgress: () {
                _showProgress();
              },
              dismissProgress: () {
                _dismissProgress();
              },
            ).postFunc();
          },
          child: new Text(
            'シェア',
            style: new TextStyle(
              color: Colors.blue,
            ),
          ),
          color: Colors.white,
        ),
      ),
    ];

    // テキストフィールド
    TextFormField captionField = new TextFormField(
      maxLength: 30,
      style: new TextStyle(
        fontSize: 20.0,
        color: Colors.black,
      ),
      controller: _controller,
      decoration: new InputDecoration(
        border: InputBorder.none,
        filled: true,
        hintText: 'キャプションを入力...',
        contentPadding: const EdgeInsets.all(20.0),
      ),
    );

    // view
    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: shareButton,
        backgroundColor: Colors.white,
        elevation: 1.5,
      ),
      body: captionField
    );
  }
}
