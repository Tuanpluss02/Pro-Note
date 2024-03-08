import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseStorageService {
  final storageRef = FirebaseStorage.instance.ref('profile_pictures');

  Future<String> uploadProfilePicture(
      {required String uid, required File images}) async {
    try {
      final ref = storageRef.child(uid);
      await ref.putFile(images);
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint('Error uploading image: $e');
      throw "Error uploading image, please try again.";
    }
  }

  Future<void> deleteProfilePicture({required String uid}) async {
    try {
      final ref = storageRef.child(uid);
      await ref.delete();
    } catch (e) {
      debugPrint('Error deleting image: $e');
      throw "Error deleting image, please try again.";
    }
  }
}
