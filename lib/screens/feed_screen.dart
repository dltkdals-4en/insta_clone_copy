import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/repo/user_network_repository.dart';
import 'package:insta_clone/widgets/post.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.camera_alt,
            color: Colors.black,
          ),
        ),
        middle: Text(
          'insta_clone',
          style: TextStyle(fontFamily: 'VeganStyle', color: Colors.black),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              onPressed: () {

              },
              icon: ImageIcon(
                AssetImage('assets/images/actionbar_camera.png'),
              ),
            ),
            IconButton(
              onPressed: () {

              },
              icon: ImageIcon(
                AssetImage('assets/images/direct_message.png'),
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemBuilder: feedListBuilder,
        itemCount: 30,
      ),
    );
  }

  Widget feedListBuilder(BuildContext context, int index) {
    return Post(index);
  }
}


