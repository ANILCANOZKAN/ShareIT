import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/UserModel.dart';
import 'package:flutter_application_1/View/searchedUsers.dart';

class searchStateUsers extends StatefulWidget {
  searchStateUsers(this.users, {super.key});

  List<UserModel>? users;

  @override
  State<searchStateUsers> createState() => searchStateUsersState();
}

class searchStateUsersState extends State<searchStateUsers> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.users?.length ?? 0,
      itemBuilder: (context, index) {
        return searchedUsers(widget.users?[index]);
      },
    );
  }
}
