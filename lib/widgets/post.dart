import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/constants/common_size.dart';
import 'package:insta_clone/constants/screen_size.dart';
import 'package:insta_clone/models/firestore/post_model.dart';
import 'package:insta_clone/models/user_model_state.dart';
import 'package:insta_clone/repo/image_network_repository.dart';
import 'package:insta_clone/repo/post_network_repository.dart';
import 'package:insta_clone/screens/comments_screen.dart';
import 'package:insta_clone/widgets/my_progress_indicator.dart';
import 'package:insta_clone/widgets/rounded_avatar.dart';
import 'package:provider/provider.dart';

import 'comment.dart';

class Post extends StatelessWidget {
  final PostModel postModel;

  Post(
    this.postModel, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _postHeader(),
        _postImage(),
        _postActions(context),
        _postLikes(),
        _postCaption(),
        _lastComment(),
        _moreComments(context),
      ],
    );
  }

  Widget _postCaption() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: common_gap, vertical: common_xxs_gap),
      child: Comment(
        username: postModel.username,
        text: postModel.caption,
        showImage: false,
      ),
    );
  }

  Widget _lastComment() {
    return Padding(
      padding: const EdgeInsets.only(
          right: common_gap, left: common_gap, top: common_xxs_gap),
      child: Comment(
        username: postModel.lastCommentor,
        text: postModel.lastComment,
        showImage: false,
      ),
    );
  }

  Padding _postLikes() {
    return Padding(
      padding: const EdgeInsets.only(left: common_gap),
      child: Text(
        '${postModel.numOfLikes == null ? 0 : postModel.numOfLikes.length} likes',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Row _postActions(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
            onPressed: () {},
            icon: ImageIcon(
              AssetImage('assets/images/bookmark.png'),
              color: Colors.black87,
            )),
        IconButton(
            onPressed: () {
              _goToComments(context);
            },
            icon: ImageIcon(
              AssetImage('assets/images/comment.png'),
              color: Colors.black87,
            )),
        IconButton(
            onPressed: () {},
            icon: ImageIcon(
              AssetImage('assets/images/direct_message.png'),
              color: Colors.black87,
            )),
        Spacer(),
        Consumer(
          builder: (BuildContext context, UserModelState userModelState,
              Widget child) {
            return IconButton(
                onPressed: () {
                  postNetworkRepository.toggleLike(
                      postModel.postKey, userModelState.userModel.userKey);
                },
                icon: ImageIcon(
                  AssetImage(postModel.numOfLikes
                          .contains(userModelState.userModel.userKey)
                      ? 'assets/images/heart_selected.png'
                      : 'assets/images/heart.png'),
                  color: Colors.redAccent,
                ));
          },
        ),
      ],
    );
  }

  Widget _postHeader() {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(common_xxs_gap),
          child: RoundedAvatar(),
        ),
        Expanded(child: Text(postModel.username)),
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_horiz,
              color: Colors.black,
            ))
      ],
    );
  }

  Widget _postImage() {
    Widget progress = MyProgressIndicator(
      containerSize: size.width,
    );
    return CachedNetworkImage(
      imageUrl: postModel.postImg,
      placeholder: (BuildContext context, String url) {
        return progress;
      },
      imageBuilder: (BuildContext context, ImageProvider imageProvider) {
        return AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
        );
      },
    );
  }

  Widget _moreComments(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _goToComments(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: common_gap),
        child: Visibility(
          visible:
              postModel.numOfComments != null && postModel.numOfComments >= 2,
          child: Text('${postModel.numOfComments - 1} more comments...'),
        ),
      ),
    );
  }

  _goToComments(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CommentsScreen(postModel.postKey),
    ));
  }
}
