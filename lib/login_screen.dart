import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key key, this.loginFunc}) : super(key: key);
  // ボタンを押した時のクロージャー
  final loginFunc;

  @override
  Widget build(BuildContext context) {
    // ボタンだけ表示
    return new Scaffold(
      body: new Center(
        child: new FlatButton(
          onPressed: loginFunc,
          child: new Text('ログイン'),
          color: Colors.blue,
        ),
      ),
    );
  }
}