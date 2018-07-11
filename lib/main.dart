import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'login_screen.dart';
import 'home_screen.dart';

void main() => runApp(new MainWidget());

class MainWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'MicroBlog',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LaunchControlWidget(),
    );
  }
}

// ログインしてるかどうかで画面を切り替える為のState
class LaunchControlWidget extends StatefulWidget {
  LaunchControlWidget({Key key}) : super(key: key);

  @override
  State createState() => new LaunchControlState();
}

class LaunchControlState extends State<LaunchControlWidget> {
  bool isLoggedIn = false;
  bool isLoading = true;
  final Login login = Login.instance;

  @override
  void initState() {
    super.initState();
    // 起動時にログイン情報を取得
    (login.isLoggedIn()).then((bool loggedIn){
      setState(() {
        isLoading = false;
        isLoggedIn = loggedIn;
      });
    });
  }

  Widget loading = new Container(
    color: Colors.white
  );

  @override
  Widget build(BuildContext context) {
    // ログインしているかどうかで画面を変更
    return isLoading
        ? loading
        : isLoggedIn
        ? new MyHomePage()
        : new LoginScreen(loginFunc: () { _loginFunc(); },);
  }

  // ボタンを押した時に呼ぶクロージャーの中身
  void _loginFunc() {
    (login.ensureLoggedIn()).then( (bool loggedIn) {
      setState(() {
        isLoggedIn = loggedIn;
      });
    });
  }
}