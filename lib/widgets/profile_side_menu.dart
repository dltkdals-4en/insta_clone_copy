import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/models/fire_base_auth_state.dart';
import 'package:insta_clone/screens/auth_screen.dart';
import 'package:provider/provider.dart';

class ProfileSideMenu extends StatelessWidget {
  ProfileSideMenu(
    this.menuWidth, {
    Key key,
  }) : super(key: key);
  final double menuWidth;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: menuWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text(
                'Setting',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.black,
              ),
              title: Text('sign out'),
              onTap: () {
                Provider.of<FirebaseAuthState>(context, listen: false)
                    .signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
