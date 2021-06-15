import 'package:flutter/material.dart';
import 'package:insta_clone/models/fire_base_auth_state.dart';
import 'package:insta_clone/models/user_model_state.dart';
import 'package:insta_clone/repo/user_network_repository.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FirebaseAuthState>.value(
            value: _firebaseAuthState),
        ChangeNotifierProvider<UserModelState>(
          create: (_) => UserModelState(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: white,
        ),
        home: Consumer<FirebaseAuthState>(builder: (BuildContext context,
            FirebaseAuthState firebaseAuthState, Widget child) {
          switch (firebaseAuthState.firebaseAuthStatus) {
            case FirebaseAuthStatus.signout:
              _clearUserModel(context);
              _currentWidget = AuthScreen();
              break;
            case FirebaseAuthStatus.signin:
              _initUserModel(firebaseAuthState, context);
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

  void _initUserModel(
      FirebaseAuthState firebaseAuthState, BuildContext context) {
    UserModelState userModelState =
        Provider.of<UserModelState>(context, listen: false);

    userModelState.currentStreamSub = userNetworkRepository
        .getUserModelStream(firebaseAuthState.firebaseUser.uid)
        .listen((userModel) {
      userModelState.userModel = userModel;
    });
  }

  void _clearUserModel(BuildContext context) {
    UserModelState userModelState =
    Provider.of<UserModelState>(context, listen: false);
    userModelState.clear();
  }
}
