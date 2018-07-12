import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'image_pick_screen.dart';
import 'post.dart';
import 'login.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Login login = Login.instance;

  void _postDialog(String postId, String imageUrl) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(children: <Widget>[
            new SimpleDialogOption(
                child: new Container(
                  margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: new Text('削除'),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  new Post(setState: () {
                    setState(() {});
                  }).deleteFunc(postId, imageUrl);
                })
          ]);
        });
  }

  // 投稿画面へ
  void moveToPostPage(BuildContext context) {
    Navigator.push(
      context,
      new PageRouteBuilder(
        opaque: true,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext context, _, __) {
          return new ImagePickPage();
        },
        transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation, Widget child) {
          return new SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child, // child is the value returned by pageBuilder
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 投稿がない時
    Widget _notHaveContents(bool isLoading) {
      return new Column(
        children: <Widget>[
          new Expanded(
              child: new Center(
                child: new Text(isLoading ? 'Loading...' : '投稿がありません'),
              ))
        ],
      );
    }

    // 投稿内容
    Widget _postContent(AsyncSnapshot<QuerySnapshot> snapshot) {
      return new Column(
        children: snapshot.data.documents.reversed.map((DocumentSnapshot document) {
          String uid = document['uid'];
          String profileImageUrl = document['profileImageUrl'];
          String userName = document['userName'];
          String imageUrl = document['imageUrl'];
          String text = document['text'];

          return new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(left: 10.0),
                child: new Row(
                  children: <Widget>[
                    new Container(
                      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.0),
                      child: (profileImageUrl == '' || profileImageUrl == null)
                          ? new Icon(CupertinoIcons.profile_circled, size: 40.0)
                          : new Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new CachedNetworkImageProvider(
                                  profileImageUrl),
                            ),
                          )),
                    ),
                    new Expanded(
                      child: new Text(userName),
                    ),
                    login.uid() == uid
                        ? new IconButton(
                            icon: new Icon(
                              IconData(0xf397,
                                  fontFamily: 'CupertinoIcons',
                                  fontPackage: 'cupertino_icons'),
                              color: Colors.grey,
                            ),
                            onPressed: () => _postDialog(document.documentID, imageUrl),
                          )
                        : new Container()
                  ],
                ),
              ),
              new Image.network(
                imageUrl,
                fit: BoxFit.cover,
                height: 350.0,
              ),
              new Container(
                  margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 5.0),
                  child: text == null ? null : new Text(text)),
              new Divider(),
            ],
          );
        }).toList(),
      );
    }

    // 投稿がある時
    Widget _haveContents(AsyncSnapshot<QuerySnapshot> snapshot) {
      return new SingleChildScrollView(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _postContent(snapshot),
          ],
        ),
      );
    }

    // 読み込み完了時
    Widget _loadedData(AsyncSnapshot<QuerySnapshot> snapshot) {
      return snapshot.data.documents.length == 0
          ? _notHaveContents(false)
          : _haveContents(snapshot);
    }

    Widget _body = new Container(
      color: Colors.white,
      child: new StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('posts')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return snapshot.hasData
              ? _loadedData(snapshot)
              : _notHaveContents(true);
        },
      ),
    );

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Home'),
        ),
        body: _body,
        floatingActionButton: new FloatingActionButton(
            onPressed: () => moveToPostPage(context),
            child: new Icon(Icons.add)
        ),
    );
  }
}
