import 'package:flutter/material.dart';
import 'package:insta_clone/screens/feed_screen.dart';
import 'package:insta_clone/screens/profile_screen.dart';
import 'package:insta_clone/screens/search_screen.dart';

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

  static List<Widget> _screens = <Widget>[
    FeedScreen(),
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
    print(index);
    setState(() {
      _selectedIndex = index;
    });
  }
}
