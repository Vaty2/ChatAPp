import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class ProfileService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }

  Future<String> saveProfile(
      {required String firstName,
      required String lastName,
      required Uint8List file}) async {
    String resp = "error";
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    try {
      String imageUrl = await uploadImageToStorage(currentUserId, file);
      _firestore.collection('users').doc(currentUserId).set({
        'uid': currentUserId,
        'email': currentUserEmail,
        'displayName': "$firstName $lastName",
        'photoURL': imageUrl
      }, SetOptions(merge: true));
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }

  Future<Map<String, dynamic>> getProfile() async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;

    final docRef =
        FirebaseFirestore.instance.collection('users').doc(currentUserId);

    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      final userData = docSnapshot.data()!;
      return userData;
    } else {
      return {};
    }
  }
}
