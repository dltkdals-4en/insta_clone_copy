import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_clone/constants/firestore_keys.dart';
import 'package:insta_clone/models/firestore/user_model.dart';
import 'package:insta_clone/repo/helper/transformers.dart';

class UserNetworkRepository with Transformers {
  Future<void> attemptCreateUser({String userKey, String email}) async {
    final DocumentReference userRef =
        Firestore.instance.collection(COLLECTION_USERS).document(userKey);

    DocumentSnapshot snapshot = await userRef.get();
    if (!snapshot.exists) {
      return await userRef.setData(UserModel.getMapForCreateUser(email));
    }
  }

  Stream<UserModel> getUserModelStream(String userKey) {
    return Firestore.instance
        .collection(COLLECTION_USERS)
        .document(userKey)
        .snapshots()
        .transform(toUser);
  }

  Stream<List<UserModel>> getAllUsersWithoutMe() {
    return Firestore.instance
        .collection(COLLECTION_USERS)
        .snapshots()
        .transform(toUsersExceptMe);
  }

  Future<void> followUser({String myUserkey, String otherUserKey}) async {
    final DocumentReference myUserRef =
        Firestore.instance.collection(COLLECTION_USERS).document(myUserkey);
    final DocumentSnapshot mySnapshot = await myUserRef.get();
    final DocumentReference otherUserRef =
        Firestore.instance.collection(COLLECTION_USERS).document(otherUserKey);
    final DocumentSnapshot otherSnapshot = await otherUserRef.get();

    Firestore.instance.runTransaction((tx) async {
      if (mySnapshot.exists && otherSnapshot.exists)
        await tx.update(myUserRef, {
          KEY_FOLLOWINGS: FieldValue.arrayUnion([otherUserKey])
        });
      int currentFollowers = otherSnapshot.data[KEY_FOLLOWERS];
      await tx.update(otherUserRef, {KEY_FOLLOWERS: currentFollowers + 1});
    });
  }

  Future<void> unFollowUser({String myUserkey, String otherUserKey}) async {
    final DocumentReference myUserRef =
        Firestore.instance.collection(COLLECTION_USERS).document(myUserkey);
    final DocumentSnapshot mySnapshot = await myUserRef.get();
    final DocumentReference otherUserRef =
        Firestore.instance.collection(COLLECTION_USERS).document(otherUserKey);
    final DocumentSnapshot otherSnapshot = await otherUserRef.get();

    Firestore.instance.runTransaction((tx) async {
      if (mySnapshot.exists && otherSnapshot.exists)
        await tx.update(myUserRef, {
          KEY_FOLLOWINGS: FieldValue.arrayRemove([otherUserKey])
        });
      int currentFollowers = otherSnapshot.data[KEY_FOLLOWERS];
      await tx.update(otherUserRef, {KEY_FOLLOWERS: currentFollowers - 1});
    });
  }
}

UserNetworkRepository userNetworkRepository = UserNetworkRepository();
