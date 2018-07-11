import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class Login {
  static final Login _singleton = new Login._internal();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  GoogleSignInAccount _googleAccount;
  FirebaseUser _firebaseUser;
  String _uid;

  Login._internal();
  static Login get instance => _singleton;

  Future<bool> isLoggedIn() async {
    if (_firebaseUser == null) {
      if (_googleAccount == null) {
        _googleAccount = _googleSignIn.currentUser;
      }
      if (_googleAccount == null) {
        // user情報がなければ、前回ログインしていた情報を引き出す
        _googleAccount = await _googleSignIn.signInSilently();
      }
      if (_googleAccount != null) {
        final GoogleSignInAuthentication googleAuth = await _googleAccount.authentication;
        _firebaseUser = await _auth.signInWithGoogle(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        _uid = _firebaseUser.uid;
      }
    }
    return _firebaseUser != null;
  }

  // ログイン画面
  // ログインしてなければログイン画面を表示する
  Future<bool> ensureLoggedIn() async {
    await _signInWithGoogle();

    return await isLoggedIn();
  }

  Future<Null> _signInWithGoogle() async {
    if (_googleAccount == null) {
      _googleAccount = _googleSignIn.currentUser;
    }
    if (_googleAccount == null) {
      // user情報がなければ、前回ログインしていた情報を引き出す
      _googleAccount = await _googleSignIn.signInSilently();
    }
    if (_googleAccount == null) {
      // ログインしたことがなければログインする
      _googleAccount = await _googleSignIn.signIn();
    }
    final GoogleSignInAuthentication googleAuth = await _googleAccount.authentication;
    _firebaseUser = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    _uid = _firebaseUser.uid;
  }

  // ログインしていた場合にユーザー名リターン
  String displayName() {
    if (_googleAccount == null)
      return "";
    return _googleAccount.displayName;
  }

  // ログインしていた場合に画像URLをリターン
  String photoUrl(){
    if (_googleAccount == null)
      return "";
    return _googleAccount.photoUrl;
  }

  String uid() {
    return _uid;
  }
}