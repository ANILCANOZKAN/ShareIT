import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/UserProfilePicture.dart';
import 'package:flutter_application_1/Models/UserModel.dart';
import 'package:flutter_application_1/Theme/Theme.dart';
import 'package:flutter_application_1/Usage/Account.dart';
import 'package:flutter_application_1/layout/layout.dart';

class searchedUsers extends StatefulWidget {
  searchedUsers(this.user, {super.key});

  UserModel? user;
  @override
  State<searchedUsers> createState() => _searchedUsersState();
}

class _searchedUsersState extends State<searchedUsers> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          TextButton(
            style:
                ButtonStyle(padding: MaterialStatePropertyAll(EdgeInsets.zero)),
            onPressed: () async {
              String refresh = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Account(
                            userId: widget.user!.userId!,
                          )));
            },
            child: Row(children: [
              userProfile(user: widget.user),
              Text(
                widget.user?.name ?? '',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Color(0xff3e003e),
                    fontWeight: FontWeight.w700,
                    fontSize: 17),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                '@${widget.user?.username}' ?? '',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Color.fromARGB(111, 62, 0, 62),
                    fontWeight: FontWeight.w700,
                    fontSize: 17),
                textAlign: TextAlign.center,
              ),
            ]),
          ),
          Divider(),
        ],
      ),
    );
  }

  ElevatedButton _userPP(String? photo) {
    return ElevatedButton(
        style: const ButtonStyle(
            padding: MaterialStatePropertyAll(EdgeInsets.all(0)),
            elevation: MaterialStatePropertyAll(0),
            backgroundColor: MaterialStatePropertyAll(Colors.transparent)),
        onPressed: () {},
        child: SizedBox(
          width: 60,
          height: 60,
          child: CircleAvatar(
              backgroundImage: NetworkImage(photo ??
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlzWGeKBgGeQ_zA2_-P89bHLjOVxE0JQA0jQ&usqp=CAU")),
        ));
  }
}
