import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthState extends ChangeNotifier {
  FirebaseAuthStatus _firebaseAuthStatus = FirebaseAuthStatus.signout;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _firebaseUser;

  void watchAuthChange() {
    _firebaseAuth.onAuthStateChanged.listen((firebaseUser) {
      if (firebaseUser == null && _firebaseUser == null) {
        return;
      } else if (firebaseUser != _firebaseUser) {
        _firebaseUser = firebaseUser;
        changeFirebaseAuthStatus();
      }
    });
  }

  void login(BuildContext context,{@required String email, @required String password}) {
    _firebaseAuth
        .signInWithEmailAndPassword(email: email.trim(), password: password.trim())
        .catchError((error) {
      String _message = "";
      switch (error.code) {
        case 'ERROR_INVALID_EMAIL':
          _message = "없는 이메일";
          break;
        case 'ERROR_WRONG_PASSWORD':
          _message = "비번 틀림";
          break;
        case 'ERROR_USER_NOT_FOUND':
          _message = "잘못된 유저";
          break;
        case 'ERROR_USER_DISABLED':
          _message = "금지된 유저";
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
          _message = "너무 많이 시도";
          break;
        case 'ERROR_OPERATION_NOT_ALLOWED':
          _message = "동작 실패";
          break;
      }
      SnackBar snackBar = SnackBar(
        content: Text(_message),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }

  void registerUser(BuildContext context,
      {@required String email, @required String password}) {
    _firebaseAuth
        .createUserWithEmailAndPassword(
            email: email.trim(), password: password.trim())
        .catchError((error) {
      print(error);
      String _message = "";
      switch (error.code) {
        case 'ERROR_WEAK_PASSWORD':
          _message = "패스워드를 잘 넣어줘";
          break;
        case 'ERROR_INVALID_EMAIL':
          _message = "이메일 주소 안맞아";
          break;
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          _message = "다른 이메일 써줘";
          break;
      }
      SnackBar snackBar = SnackBar(
        content: Text(_message),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }

  void signOut() {
    _firebaseAuthStatus = FirebaseAuthStatus.signout;
    if (_firebaseUser != null) {
      _firebaseUser = null;
      _firebaseAuth.signOut();
    }
    notifyListeners();
  }
  void lobinWithFacebook(BuildContext context){
    
  }
  void changeFirebaseAuthStatus([FirebaseAuthStatus firebaseAuthStatus]) {
    if (firebaseAuthStatus != null) {
      _firebaseAuthStatus = firebaseAuthStatus;
    } else {
      if (_firebaseUser != null) {
        _firebaseAuthStatus = FirebaseAuthStatus.signin;
      } else {
        _firebaseAuthStatus = FirebaseAuthStatus.signout;
      }
    }
    notifyListeners();
  }

  FirebaseAuthStatus get firebaseAuthStatus => _firebaseAuthStatus;
}

enum FirebaseAuthStatus { signout, progress, signin }
