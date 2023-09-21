import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/UserProfilePicture.dart';
import 'package:flutter_application_1/Components/timeFormat.dart';
import 'package:flutter_application_1/Models/PostModel.dart';
import 'package:flutter_application_1/Models/UserModel.dart';

class userView extends StatefulWidget {
  userView({super.key, required this.post});

  PostModel? post;

  @override
  State<userView> createState() => _userViewState();
}

class _userViewState extends State<userView> {
  UserModel? _user;
  bool isLoading = false;

  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 500), () {
      getUser(widget.post?.userId);
    });
  }

  void changeLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return UserDetails(context);
  }

  Widget UserDetails(BuildContext context) {
    List created = timeFormat().timeFormatter(widget.post?.created_at ?? 0);
    return isLoading
        ? Row(
            children: [
              userProfile(userPhoto: _user?.photo ?? ""),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      _user?.name ?? "",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Color(0XFF3e003e),
                            fontSize: 17,
                          ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "@${_user?.username ?? ""}",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Color.fromARGB(119, 62, 0, 62),
                            fontSize: 15,
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Column(
                        children: [
                          timeText(created[1], created[0], context),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        : SizedBox(height: 40, child: LinearProgressIndicator());
  }

  Text timeText(created, d, BuildContext context) {
    return Text(" - " + (created.toString()) + d,
        style: TextStyle(
          color: Color.fromARGB(119, 62, 0, 62),
          fontSize: 15,
        ));
  }

  Future<void> getUser(String? userId) async {
    var db = FirebaseFirestore.instance;
    final response = await db.collection("users").doc(userId).get();
    //dart.io'dan gelmeli
    final fetchedData = response.data();
    if (fetchedData != null) {
      setState(() {
        _user = UserModel.fromJson(fetchedData);
      });
    }
    changeLoading();
  }
}
