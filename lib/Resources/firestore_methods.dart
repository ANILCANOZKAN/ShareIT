import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/Models/CommentModel.dart';
import 'package:flutter_application_1/Models/PostModel.dart';
import 'package:flutter_application_1/Resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, String uid,
      String? sharedPostId, List<Uint8List?> images) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    if (description.length <= 10) {
      return "10 karakterden daha kısa gönderi atamazsınız";
    } else if (description.length > 255) {
      return "255 karakterden daha uzun gönderi atamazsınız";
    }
    try {
      String postId = const Uuid().v1();
      Media media = new Media();
      if (images.isNotEmpty) {
        List uploadedImages = await StorageMethods()
            .uploadImagesToStorage('postPics', images, postId);
        media.imageUrl = uploadedImages;
      }

      PostModel post = PostModel(
        body: description,
        userId: uid,
        media: media,
        like: [],
        post_Id: postId,
        sharedPost: sharedPostId,
        created_at: DateTime.now().millisecondsSinceEpoch,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'like': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'like': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post comment
  Future<String> postComment(
    String postId,
    String text,
    String uid,
  ) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        CommentModel comment = CommentModel(
          body: text,
          userId: uid,
          post_Id: postId,
          created_at: DateTime.now().millisecondsSinceEpoch,
        );
        await _firestore
            .collection('comments')
            .doc(commentId)
            .set(comment.toJson());
        String postOwner = "";
        await _firestore.collection("posts").doc(postId).get().then(
            (value) => postOwner = PostModel.fromJson(value.data()!).userId!);

        await _firestore.collection("users").doc(postOwner).update({
          "notification": true,
          "notifications.comment": FieldValue.arrayUnion([postId])
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> sendMessage(
      String currentUser_id, String user_id, String Text) async {
    if (Text.isNotEmpty) {
      await _firestore
          .collection("users")
          .doc(currentUser_id)
          .collection("messages")
          .doc(user_id)
          .collection("msgList")
          .doc(Uuid().v1())
          .set({
        "text": Text,
        "user_id": currentUser_id,
        "send_time": DateTime.now().millisecondsSinceEpoch
      });
      await _firestore
          .collection("users")
          .doc(user_id)
          .collection("messages")
          .doc(currentUser_id)
          .collection("msgList")
          .doc(Uuid().v1())
          .set({
        "text": Text,
        "user_id": currentUser_id,
        "send_time": DateTime.now().millisecondsSinceEpoch
      });
      await _firestore
          .collection("users")
          .doc(currentUser_id)
          .collection("messages")
          .doc(user_id)
          .set({"last_time": DateTime.now().millisecondsSinceEpoch});
      await _firestore
          .collection("users")
          .doc(user_id)
          .collection("messages")
          .doc(currentUser_id)
          .set({"last_time": DateTime.now().millisecondsSinceEpoch});
    }
  }

  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });
        await _firestore.collection('users').doc(uid).update({
          'followers': FieldValue.arrayRemove([followId])
        });

        await _firestore.collection('users').doc(followId).update({
          'following': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(followId).update({
          'following': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'followers': FieldValue.arrayUnion([followId])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
        List follow = (snap.data()! as dynamic)['notifications']['follow'];

        await _firestore.collection("users").doc(uid).update({
          'notifications.follow': FieldValue.arrayRemove([followId])
        });
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }
}
