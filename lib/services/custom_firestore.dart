import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project1/models/current_user_model.dart';
import 'package:project1/models/firestore_models.dart';

class CustomFireStore {
  CustomFireStore._();
  static final instance = CustomFireStore._();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // this method will add user info to firestore
  Future dataToFirestore(
      String userUid, Map<String, dynamic> userInfoData) async {
    return await _firestore
        .collection('allUsers')
        .doc(userUid)
        .set(userInfoData);
  }

  // updating user profile picture
  Future updateProfile(String uid, String imageUrl) async {
    FirebaseFirestore.instance.collection('allUsers').doc(uid).update(
      {'photoUrl': imageUrl},
    );
  }

  // updating username
  Future updateName(String uid, String name) async {
    FirebaseFirestore.instance.collection('allUsers').doc(uid).update(
      {'displayName': name},
    );
  }

  List<FirestoreModelsStatus> _fireUsersStatus(QuerySnapshot? snapshot) {
    return snapshot!.docs.map((e) {
      return FirestoreModelsStatus(
          displayName: e['displayName'],
          photoUrl: e['photoUrl'],
          email: e['email'],
          status: e['status'],
          userId: e['userId']);
    }).toList();
  }
  // search for users by typing thier display name
  // Future<Stream<QuerySnapshot>> searchUserFromFirestore({String? name}) async {
  //   return _firestore
  //       .collection('allUsers')
  //       .where('displayName', isEqualTo: name)
  //       .snapshots();
  // }

  // fetching for all users mapping them in to [_fireUser] method
  Stream<List<FirestoreModels>> get fromFirestoreAll {
    return _firestore
        .collection('allUsers')
        .where('userId', isNotEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .map(_fireUsers);
  }

  // converting firestore object to dart object
  List<FirestoreModels> _fireUsers(QuerySnapshot? snapshot) {
    return snapshot!.docs.map((e) {
      return FirestoreModels(
          displayName: e['displayName'],
          photoUrl: e['photoUrl'],
          email: e['email'],
          userId: e['userId']);
    }).toList();
  }

  // fetching for all users mapping them in to [_fireUser] method
  Stream<List<FirestoreModelsStatus>> get fromFirestoreStatusAll {
    return _firestore.collection('allUsers').snapshots().map(_fireUsersStatus);
  }

  // add status

  Future addStatus({
    required String caption,
    required String imageUlr,
  }) async {
    return await _firestore
        .collection('allUsers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'status': FieldValue.arrayUnion([
        {
          'caption': caption,
          'userId': FirebaseAuth.instance.currentUser!.uid,
          'imageUrl': imageUlr,
          'postedAt': DateTime.now(),
        },
      ]),
    }, SetOptions(merge: true));
  }

  Future sendMessage({
    required String userId,
    required String message,
    required String profileLink,
  }) async {
    FirebaseFirestore.instance.collection('Chats/$userId/message').add({
      'message': message,
      'createdAt': DateTime.now(),
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'profileLink': profileLink,
    });
    await FirebaseFirestore.instance.collection('allUsers').doc(userId).update(
      {'lastMessageTime': DateTime.now()},
    );
  }

  List<Message> _message(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) {
      return Message(
        createdAt: e['sentAt'].toString(),
        message: e['message'],
        profileLink: e['imageUrl'],
        userId: e['sendBy'],
      );
    }).toList();
  }

  Stream<List<Message>> message({required String chatRoomId}) {
    return FirebaseFirestore.instance
        .collection('chatrooms/$chatRoomId/chats')
        .orderBy(
          'sentAt',
          descending: true,
        )
        .snapshots()
        .map(_message);
  }

  // sending message method
  Future sendPrivateMessage({
    required String chatRoomId,
    required String messageBody,
    required DateTime time,
    required String uid,
    required String imageUrl,
  }) async {
    return await FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('chats')
        .add(
      {
        'message': messageBody,
        'sentAt': time,
        'sendBy': uid,
        'imageUrl': imageUrl,
      },
    );
  }

  // creating chatroom id

  Future createChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomInfo) async {
    final _snapshot = await FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .get();
    return _snapshot.exists
        ? true
        : FirebaseFirestore.instance
            .collection('chatrooms')
            .doc(chatRoomId)
            .set(chatRoomInfo);
  }
}
