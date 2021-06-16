import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insta_clone/constants/common_size.dart';
import 'package:insta_clone/models/firestore/user_model.dart';
import 'package:insta_clone/models/user_model_state.dart';
import 'package:insta_clone/repo/user_network_repository.dart';
import 'package:insta_clone/widgets/my_progress_indicator.dart';
import 'package:insta_clone/widgets/rounded_avatar.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Follow/Unfollow'),
      ),
      body: StreamBuilder<List<UserModel>>(
          stream: userNetworkRepository.getAllUsersWithoutMe(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SafeArea(
                child: Consumer<UserModelState>(
                  builder: (BuildContext context,
                      UserModelState myUserModelState, Widget child) {
                    return ListView.separated(
                        itemBuilder: (context, index) {
                          UserModel otherUser = snapshot.data[index];

                          bool amIFollowing = myUserModelState
                              .amIFollowingThisUser(otherUser.userKey);
                          return ListTile(
                            leading: RoundedAvatar(),
                            title: Text(otherUser.username),
                            subtitle:
                                Text('user bio number ${otherUser.username}'),
                            trailing: Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 80,
                              decoration: BoxDecoration(
                                color: amIFollowing
                                    ? Colors.red[50]
                                    : Colors.blue[50],
                                border: Border.all(
                                  color:
                                      amIFollowing ? Colors.red : Colors.blue,
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                amIFollowing ? 'unfollow' : 'follow',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                amIFollowing
                                    ? userNetworkRepository.unFollowUser(
                                        myUserkey:
                                            myUserModelState.userModel.userKey,
                                        otherUserKey: otherUser.userKey)
                                    : userNetworkRepository.followUser(
                                        myUserkey:
                                            myUserModelState.userModel.userKey,
                                        otherUserKey: otherUser.userKey);
                              });
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: Colors.grey,
                          );
                        },
                        itemCount: snapshot.data.length);
                  },
                ),
              );
            } else {
              return MyProgressIndicator();
            }
          }),
    );
  }
}
