import 'package:insta_clone/models/firestore/user_model.dart';

String getNewPostKey(UserModel userModel)=>"${DateTime.now().millisecondsSinceEpoch}_${userModel.userKey}";