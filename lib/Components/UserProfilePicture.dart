import 'package:flutter/material.dart';

class UserProfilePicture {}

class userProfile extends StatelessWidget {
  userProfile({
    super.key,
    this.userPhoto,
  });
  String? userPhoto;
  double size = 50;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: size,
        height: size,
        child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            shape: CircleBorder(),
            onPressed: () {},
            child: CircleAvatar(
                radius: 100,
                backgroundImage: userPhoto!.length == 0
                    ? NetworkImage(
                        "https://upload.wikimedia.org/wikipedia/commons/8/85/NoPic-purple-02.png?20230816140649")
                    : NetworkImage(userPhoto!))),
      ),
    );
  }
}
