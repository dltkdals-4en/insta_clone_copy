import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/constants/common_size.dart';
import 'package:insta_clone/constants/screen_size.dart';
import 'package:insta_clone/models/user_model_state.dart';
import 'package:insta_clone/screens/profile_screen.dart';
import 'package:insta_clone/widgets/rounded_avatar.dart';
import 'package:provider/provider.dart';

class ProfileBody extends StatefulWidget {
  ProfileBody({Key key, this.onMenuChanged}) : super(key: key);
  final Function onMenuChanged;

  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> with SingleTickerProviderStateMixin {
  SelectedTab _selectedTab = SelectedTab.left;
  double _leftImagesPageMargin = 0;
  double _rightImagesPageMargin = size.width;
  AnimationController _iconanimationController;

  @override
  void initState() {
    _iconanimationController =AnimationController(vsync: this,
    duration: duration);
    super.initState();
  }
  @override
  void dispose() {
    _iconanimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _appbar(),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(common_gap),
                          child: RoundedAvatar(
                            size: 80,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: common_gap),
                            child: Table(
                              children: [
                                TableRow(
                                  children: [
                                    _valueText('111111'),
                                    _valueText('111111'),
                                    _valueText('111111'),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    _labelText('Post'),
                                    _labelText('Followers'),
                                    _labelText('Folloing'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    _username(context),
                    _userBio(),
                    _editProfileBtn(),
                    _tabBtn(),
                    _selectedIndicator(),
                  ]),
                ),
                _imagesPager(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Text _valueText(String value) {
    return Text(
      value,
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Text _labelText(String label) {
    return Text(
      label,
      style: TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: 11,
      ),
      textAlign: TextAlign.center,
    );
  }

  SliverToBoxAdapter _imagesPager() {
    return SliverToBoxAdapter(
      child: Stack(
        children: <Widget>[
          AnimatedContainer(
            duration: duration,
            transform: Matrix4.translationValues(_leftImagesPageMargin, 0, 0),
            child: _images(),
          ),
          AnimatedContainer(
            duration: duration,
            transform: Matrix4.translationValues(_rightImagesPageMargin, 0, 0),
            child: _images(),
          ),
        ],
      ),
    );
  }

  GridView _images() {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      shrinkWrap: true,
      childAspectRatio: 1,
      children: List.generate(
        30,
        (index) => CachedNetworkImage(
          imageUrl: 'https://picsum.photos/id/$index/200/200',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Row _tabBtn() {
    return Row(
      children: [
        Expanded(
          child: IconButton(
            onPressed: () {
              setState(() {
                _tabSelected(SelectedTab.left);
              });
            },
            icon: ImageIcon(
              AssetImage('assets/images/grid.png'),
              color: _selectedTab == SelectedTab.left
                  ? Colors.black
                  : Colors.black26,
            ),
          ),
        ),
        Expanded(
          child: IconButton(
            onPressed: () {
              _tabSelected(SelectedTab.right);
            },
            icon: ImageIcon(
              AssetImage('assets/images/saved.png'),
              color: _selectedTab == SelectedTab.left
                  ? Colors.black26
                  : Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  _tabSelected(SelectedTab selectedTab) {
    setState(() {
      switch (selectedTab) {
        case SelectedTab.left:
          _selectedTab = SelectedTab.left;
          _leftImagesPageMargin = 0;
          _rightImagesPageMargin = size.width;
          break;
        case SelectedTab.right:
          _selectedTab = SelectedTab.right;
          _leftImagesPageMargin = -size.width;
          _rightImagesPageMargin = 0;
          break;
      }
    });
  }

  Padding _editProfileBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_gap),
      child: SizedBox(
        height: 24,
        child: OutlineButton(
          onPressed: () {},
          borderSide: BorderSide(color: Colors.black45),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          child: Text(
            'edit Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _username(context) {
    UserModelState userModelState = Provider.of<UserModelState>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: common_gap,
      ),
      child: Text(
        userModelState == null || userModelState.userModel == null
            ? ""
            : userModelState.userModel.username,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  _userBio() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: common_gap, vertical: common_xxs_gap),
      child: Text(
        'userBio',
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget _selectedIndicator() {
    return AnimatedContainer(
      child: Container(
        height: 3,
        width: size.width / 2,
        color: Colors.black87,
      ),
      duration: duration,
      alignment: _selectedTab == SelectedTab.left
          ? Alignment.centerLeft
          : Alignment.centerRight,
      curve: Curves.easeInOut,
    );
  }

  Row _appbar() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 44,
        ),
        Expanded(child: Text('Title')),
        IconButton(
            onPressed: () {
              widget.onMenuChanged();
              _iconanimationController.status ==AnimationStatus.completed?_iconanimationController.reverse():_iconanimationController.forward();
            },
            icon: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _iconanimationController,
            ),
        ),
      ],
    );
  }
}

enum SelectedTab { left, right }
