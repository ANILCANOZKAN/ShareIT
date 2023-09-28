import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/Models/PostModel.dart';
import 'package:flutter_application_1/Models/UserModel.dart';
import 'package:flutter_application_1/Resources/storage_methods.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user details
  Future<UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
  }

  //errors
  String emailError =
      "Bu E-mail başka bir kullanıcı tarafından kullanılmaktadır";
  String usernameError =
      "Bu kullanıcı adı başka bir kullanıcı tarafından kullanılmaktadır";
  String wrongThingsHappen = "Bir şeyler yanlış gitti";

  Future<bool> usernameCheck(String username) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    return result.docs.isEmpty;
  }

  Future<bool> emailCheck(String email) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    return result.docs.isEmpty;
  }

  Future<String> signUpUser(
      {required String email,
      required String password,
      required String username,
      required String name}) async {
    String res = wrongThingsHappen;
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          name.isNotEmpty) {
        if (username.contains(' ')) {
          return "Kullanıcı adında boşluk olamaz";
        }
        final validUsername = await usernameCheck(username);
        if (!validUsername) {
          return usernameError;
        }
        final validEmail = await usernameCheck(email);
        if (!validEmail) {
          return emailError;
        }
        // registering user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        Notifications notifications = new Notifications();
        UserModel user = UserModel(
            username: username,
            userId: cred.user!.uid,
            email: email,
            notifications: notifications,
            photo: "",
            bio: "",
            name: name,
            followers: [],
            following: [],
            notification: false);

        // adding user in our database
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = "Kayıt Başarılı";
      } else {
        res = "Lütfen tüm alanları doldurun";
      }
    } on FirebaseAuthException catch (err) {
      return err.message.toString();
    }
    return res;
  }

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = wrongThingsHappen;
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "Giriş başarılı";
      } else {
        res = "Lütfen tüm alanları doldurun";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == "INVALID_LOGIN_CREDENTIALS") {
        return "Bilgileriniz yanlış";
      } else if (err.code == "invalid-email") {
        return "Lütfen geçerli bir E-mail adresi giriniz";
      }
    }
    return res;
  }

  Future<String> updateUser(String email, String username, String name,
      String bio, Uint8List? file, String user_id) async {
    String response = wrongThingsHappen;
    try {
      if (email.isNotEmpty || username.isNotEmpty || user_id.isNotEmpty) {
        UserModel? currentUser = await getUserDetails();
        String photo =
            await StorageMethods().uploadImageToStorage('profilePics', file);
        if (email != currentUser.email) {
          final validEmail = await emailCheck(email);
          if (!validEmail) {
            return emailError;
          }
        }
        if (username != currentUser.username) {
          final validUsername = await usernameCheck(username);
          if (!validUsername) {
            return usernameError;
          }
        }
        if (user_id.isEmpty) {
          return wrongThingsHappen;
        }
        if (bio.length > 120) {
          return "Biyografi 120 karakterden fazla olamaz";
        }

        await _firestore.collection("users").doc(currentUser.userId).update({
          'bio': bio,
          'email': email,
          'name': name,
          'username': username,
          'photo': photo
        });
        response = "Güncelleme Başarılı";
      }
    } catch (error) {
      response = error.toString();
    }
    return response;
  }

  Future<void> addNotification(
      String currentUser_id, String user_id, bool isFollow,
      {String? post_id}) async {
    if (isFollow) {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(user_id).get();
      List follow = (snap.data()! as dynamic)['notifications']['follow'];
      if (follow.contains(currentUser_id)) {
        await _firestore.collection("users").doc(user_id).update({
          'notifications.follow': FieldValue.arrayRemove([currentUser_id])
        });
      } else {
        await _firestore.collection("users").doc(user_id).update({
          'notifications.follow': FieldValue.arrayUnion([currentUser_id])
        });
        await _firestore
            .collection("users")
            .doc(user_id)
            .update({'notification': true});
      }
    } else {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(user_id).get();
      List follow = (snap.data()! as dynamic)['notifications']['comment'];
      if (follow.contains(currentUser_id)) {
        await _firestore.collection("users").doc(user_id).update({
          'notifications.follow': FieldValue.arrayRemove([currentUser_id])
        });
      } else {
        await _firestore.collection("users").doc(user_id).update({
          'notifications.follow': FieldValue.arrayUnion([currentUser_id])
        });
      }
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
