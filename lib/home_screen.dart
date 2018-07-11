import 'package:flutter/material.dart';
import 'image_pick_screen.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Home'),
        ),
        body: new Center(
          child: new Text('Hello'),
        ),
        floatingActionButton: new FloatingActionButton(
            onPressed: () => moveToPostPage(context),
            child: new Icon(Icons.add)
        ),
    );
  }
}
