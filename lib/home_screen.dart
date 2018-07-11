import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
            onPressed: () => null,
            child: new Icon(Icons.add)
        ),
    );
  }
}
