import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/models/user_model_state.dart';
import 'package:insta_clone/screens/camera_screen.dart';
import 'package:insta_clone/screens/feed_screen.dart';
import 'package:insta_clone/screens/profile_screen.dart';
import 'package:insta_clone/screens/search_screen.dart';
import 'package:insta_clone/widgets/my_progress_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'constants/screen_size.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BottomNavigationBarItem> btmNavItems = [
    BottomNavigationBarItem(
      label: '',
      icon: Icon(Icons.home),
    ),
    BottomNavigationBarItem(
      label: '',
      icon: Icon(Icons.search),
    ),
    BottomNavigationBarItem(
      label: '',
      icon: Icon(Icons.add),
    ),
    BottomNavigationBarItem(
      label: '',
      icon: Icon(Icons.healing),
    ),
    BottomNavigationBarItem(
      label: '',
      icon: Icon(Icons.account_circle),
    ),
  ];
  int _selectedIndex = 0;
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  static List<Widget> _screens = <Widget>[
    Consumer<UserModelState>(
      builder:
          (BuildContext context, UserModelState userModelState, Widget child) {
        if (userModelState == null ||
            userModelState.userModel == null ||
            userModelState.userModel.followings == null ||
            userModelState.userModel.followings.isEmpty) {
          return MyProgressIndicator();
        }else {
          return FeedScreen(userModelState.userModel.followings);
        }
      },
    ),
    SearchScreen(),
    Container(
      color: Colors.greenAccent,
    ),
    Container(
      color: Colors.deepPurpleAccent,
    ),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    if (size == null) size = MediaQuery.of(context).size;
    return Scaffold(
      key: _key,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: btmNavItems,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black87,
        currentIndex: _selectedIndex,
        onTap: _onBtmItemClick,
      ),
    );
  }

  void _onBtmItemClick(int index) {
    switch (index) {
      case 2:
        _openCamera();
        break;
      default:
        {
          print(index);
          setState(() {
            _selectedIndex = index;
          });
        }
    }
  }

  void _openCamera() async {
    if (await checkIfPermissionGranted(context)) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CameraScreen()));
    } else {
      SnackBar snackBar = SnackBar(
        content: Text('사진, 파일, 마이크 접근 허용해주세요'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            _key.currentState.hideCurrentSnackBar();
            AppSettings.openAppSettings();
          },
        ),
      );
      _key.currentState.showSnackBar(snackBar);
    }
  }

  Future<bool> checkIfPermissionGranted(BuildContext context) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
      Platform.isIOS ? Permission.photos : Permission.storage,
    ].request();
    bool permitted = true;

    statuses.forEach((Permission, permissionStatus) {
      if (!permissionStatus.isGranted) permitted = false;
    });
    return permitted;
  }
}
