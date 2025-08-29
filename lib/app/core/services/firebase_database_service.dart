import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feed_app/app/core/injection/injection_container.dart';
import 'package:feed_app/app/features/auth/data/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'dart:io';

class FirebaseDatabaseService {

  final FirebaseFirestore _firestore = sl<FirebaseFirestore>();
  final FirebaseStorage _storage = sl<FirebaseStorage>();

  static const String usersCollection = 'users';

  Future<void> createUser(UserModel user) async {
    await _firestore
        .collection(usersCollection)
        .doc(user.uid)
        .set(user.toJson());
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _firestore
        .collection(usersCollection)
        .doc(uid)
        .get();

    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    }
    return null;
  }

  Future<void> updateUser(UserModel user) async {
    await _firestore
        .collection(usersCollection)
        .doc(user.uid)
        .update(user.toJson());
  }

  Future<String?> uploadImage(File imageFile, String uid) async {
    try {
      final ref = _storage.ref().child('user_images').child('$uid.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteUser(String uid) async {
    await _firestore
        .collection(usersCollection)
        .doc(uid)
        .delete();
  }
}