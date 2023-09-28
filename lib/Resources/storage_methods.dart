import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // adding image to firebase storage
  Future<String> uploadImageToStorage(String childName, Uint8List? file) async {
    // creating location to our firebase storage
    if (file != null) {
      Reference ref =
          _storage.ref().child(childName).child(_auth.currentUser!.uid);

      String id = const Uuid().v1();
      ref = ref.child(id);

      // putting in uint8list format -> Upload task like a future but not future
      UploadTask uploadTask = ref.putData(file);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    }
    return "";
  }

  Future<List> uploadImagesToStorage(
      String childName, List<Uint8List?> files, String post_id) async {
    List urls = [];
    // creating location to our firebase storage
    if (files != null) {
      // putting in uint8list format -> Upload task like a future but not future
      for (int i = 0; i < files.length; i++) {
        Reference ref = _storage
            .ref()
            .child(childName)
            .child(post_id)
            .child(const Uuid().v1());
        UploadTask uploadTask = ref.putData(files[i]!);
        TaskSnapshot snapshot = await uploadTask;
        urls.add(await snapshot.ref.getDownloadURL());
      }

      return urls;
    }
    return [];
  }
}
