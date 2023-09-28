import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/UserModel.dart';
import 'package:flutter_application_1/Usage/Account.dart';

class UserProfilePicture {}

class userProfile extends StatelessWidget {
  userProfile({super.key, this.user});
  UserModel? user;
  double size = 50;
  var prop;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          width: size,
          height: size,
          child: ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(CircleBorder()),
                padding: MaterialStatePropertyAll(EdgeInsets.zero)),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Account(userId: user?.userId ?? "")));
            },
            child: CircleAvatar(
                minRadius: 50,
                backgroundImage: NetworkImage((user?.photo?.length ?? 0) == 0
                    ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlzWGeKBgGeQ_zA2_-P89bHLjOVxE0JQA0jQ&usqp=CAU"
                    : user?.photo ?? "")),
          )),
    );
  }
}
