import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'post_screen.dart';

class ImagePickPage extends StatefulWidget {
  ImagePickPage({Key key}) : super(key: key);

  @override
  _ImagePickPageState createState() => new _ImagePickPageState();
}

class _ImagePickPageState extends State<ImagePickPage> {
  bool notNull(Object o) => o != null;
  File _imageFile;

  void getImage() async {
    // ギャラリーから画像取得
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight: 1000.0, maxWidth: 1000.0);

    setState(() {
      _imageFile = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _body = new Container(
      color: Colors.white,
      child: new SizedBox.expand(
        child: new Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new Expanded(
              child: new Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: _imageFile == null
                    ? new Center(
                  child: new Text('画像が選択されていません'),
                )
                    : new Image.file(_imageFile),
              ),
            ),
            new Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.only(left: 20.0),
              child: new Row(
                children: <Widget>[
                  new IconButton(
                    icon: new Icon(Icons.add_a_photo),
                    onPressed: getImage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.close),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[
          new Container(
            margin: const EdgeInsets.all(10.0),
            child: new RaisedButton(
              elevation: 0.0,
              onPressed: () {
                if (_imageFile != null) {
                  Navigator.push(
                      context,
                      new PageRouteBuilder(
                        opaque: true,
                        transitionDuration: const Duration(milliseconds: 200),
                        pageBuilder: (BuildContext context, _, __) {
                          return new PostPage(
                            imageFile: _imageFile,
                          );
                        },
                        transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                            Widget child) {
                          return new SlideTransition(
                            position: new Tween<Offset>(
                              begin: const Offset(1.0, 0.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child, // child is the value returned by pageBuilder
                          );
                        },
                      ));
                } else {
                  // text fieldがからの時dialogを出す
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return new AlertDialog(
                        content: new SingleChildScrollView(
                          child: new ListBody(
                            children: <Widget>[
                              new Text('画像を選択してください'),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                  new Future.delayed(new Duration(seconds: 2), () {
                    Navigator.pop(context); //pop dialog
                  });
                }
              },
              child: new Text(
                '次へ',
                style: new TextStyle(
                  color: Colors.blue,
                ),
              ),
              color: Colors.white,
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 1.5,
      ),
      body: _body,
    );
  }
}
