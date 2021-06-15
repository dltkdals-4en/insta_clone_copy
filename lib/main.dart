import 'package:flutter/material.dart';
import 'package:insta_clone/models/fire_base_auth_state.dart';
import 'package:insta_clone/screens/auth_screen.dart';
import 'package:insta_clone/widgets/my_progress_indicator.dart';
import 'package:provider/provider.dart';

import 'constants/material_white.dart';
import 'home_page.dart';
import 'screens/feed_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  FirebaseAuthState _firebaseAuthState = FirebaseAuthState();
  Widget _currentWidget;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _firebaseAuthState.watchAuthChange();
    return ChangeNotifierProvider<FirebaseAuthState>.value(
      value: _firebaseAuthState,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: white,
        ),
        home: Consumer<FirebaseAuthState>(builder: (BuildContext context,
            FirebaseAuthState firebaseAuthState, Widget child) {
          switch (firebaseAuthState.firebaseAuthStatus) {
            case FirebaseAuthStatus.signout:
              _currentWidget = AuthScreen();
              break;
            case FirebaseAuthStatus.signin:
              _currentWidget = HomePage();
              break;
            default:
              _currentWidget = MyProgressIndicator();
              break;
          }
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: _currentWidget,
          );
        }),
      ),
    );
  }
}
