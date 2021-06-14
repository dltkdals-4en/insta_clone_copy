import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/constants/screen_size.dart';
import 'package:insta_clone/widgets/profile_body.dart';
import 'package:insta_clone/widgets/profile_side_menu.dart';
const duration = Duration(milliseconds: 300);
class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  MenuStatus _menuStatus = MenuStatus.closed;
  double bodyXpos = 0;
  double menuXpos = size.width;
  double menuWidth = size.width / 3*2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children:<Widget> [
          AnimatedContainer(
            transform: Matrix4.translationValues(bodyXpos, 0, 0),
            child: ProfileBody(onMenuChanged: () {
              setState(() {
                _menuStatus = (_menuStatus == MenuStatus.closed)
                    ? MenuStatus.opened
                    : MenuStatus.closed;
                switch (_menuStatus) {
                  case MenuStatus.opened:
                    bodyXpos = -menuWidth;
                    menuXpos = size.width-menuWidth;
                    break;
                  case MenuStatus.closed:
                    bodyXpos=0;
                    menuXpos=size.width;
                    break;
                }
              });
            }),
            duration: duration,
          ),
          AnimatedContainer(
            transform: Matrix4.translationValues(menuXpos, 0, 0),
            duration: duration,
            child: ProfileSideMenu(menuWidth),
          ),
        ],
      ),
    );
  }
}

enum MenuStatus { opened, closed }
