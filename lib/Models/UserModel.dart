import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? photo;
  String? userId;
  List? followers;
  List? following;
  String? name;
  String? bio;
  String? email;
  String? username;
  Notifications? notifications;
  bool? notification;

  UserModel(
      {this.photo,
      this.followers,
      this.following,
      this.name,
      this.bio,
      this.userId,
      this.email,
      this.username,
      this.notifications,
      this.notification});

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      username: snapshot["username"],
      userId: snapshot["userId"],
      email: snapshot["email"],
      photo: snapshot["photo"],
      bio: snapshot["bio"],
      followers: snapshot["followers"],
      following: snapshot["following"],
    );
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    photo = json['photo'];
    followers = json['followers'];
    following = json['following'];
    name = json['name'];
    bio = json['bio'];
    email = json['email'];
    username = json['username'];
    userId = json['userId'];
    notifications = json['notifications'] != null
        ? new Notifications.fromJson(json['notifications'])
        : null;
    notification = json['notification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photo'] = this.photo;
    data['followers'] = this.followers;
    data['following'] = this.following;
    data['name'] = this.name;
    data['bio'] = this.bio;
    data['email'] = this.email;
    data['username'] = this.username;
    data['userId'] = this.userId;
    if (this.notifications != null) {
      data['notifications'] = this.notifications!.toJson();
    }
    data['notification'] = this.notification;
    return data;
  }
}

class Notifications {
  List<dynamic>? follow;
  List<dynamic>? comment;

  Notifications({this.follow, this.comment});

  Notifications.fromJson(Map<String, dynamic> json) {
    follow = json['follow'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment'] = this.comment;
    data['follow'] = this.follow;
    return data;
  }
}
