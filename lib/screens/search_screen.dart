import 'package:flutter/material.dart';
import 'package:insta_clone/constants/common_size.dart';
import 'package:insta_clone/widgets/rounded_avatar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  List<bool> following =List.generate(30, (index) => false);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              leading: RoundedAvatar(),
              title: Text('username $index'),
              subtitle: Text('user bio number $index'),
              trailing: Container(
                alignment: Alignment.center,
                height: 30,
                width: 80,
                decoration: BoxDecoration(
                  color: following[index]?Colors.red[50]:Colors.blue[50],
                  border: Border.all(
                    color: following[index]?Colors.red:Colors.blue,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'following',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              onTap: (){
               setState(() {
                 following[index] = !following[index];
               });
              },
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              color: Colors.grey,
            );
          },
          itemCount: 30),
    );
  }
}
