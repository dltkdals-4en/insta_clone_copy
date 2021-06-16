import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/models/firestore/post_model.dart';
import 'package:insta_clone/repo/post_network_repository.dart';
import 'package:insta_clone/repo/user_network_repository.dart';
import 'package:insta_clone/widgets/my_progress_indicator.dart';
import 'package:insta_clone/widgets/post.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen(
    this.followings, {
    Key key,
  }) : super(key: key);

  final List<dynamic> followings;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<PostModel>>.value(
      value: postNetworkRepository.fetchPostsFromAllFollowers(followings),
      child: Consumer<List<PostModel>>(
        builder: (BuildContext context, List<PostModel> posts, Widget child) {
          if (posts == null || posts.isEmpty) {
            return MyProgressIndicator();
          } else {
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
                  style:
                      TextStyle(fontFamily: 'VeganStyle', color: Colors.black),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: ImageIcon(
                        AssetImage('assets/images/actionbar_camera.png'),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: ImageIcon(
                        AssetImage('assets/images/direct_message.png'),
                      ),
                    ),
                  ],
                ),
              ),
              body: ListView.builder(
                itemBuilder: (context, index) =>
                    feedListBuilder(context, posts[index]),
                itemCount: posts.length,
              ),
            );
          }
        },
      ),
    );
  }

  Widget feedListBuilder(BuildContext context, PostModel postModel) {
    return Post(postModel);
  }
}
