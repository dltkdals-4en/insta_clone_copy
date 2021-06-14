

import 'package:flutter/material.dart';
import 'package:insta_clone/screens/auth_screen.dart';


import 'constants/material_white.dart';
import 'home_page.dart';
import 'screens/feed_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch:white,
      ),
      home: HomePage(),
    );
  }
}


