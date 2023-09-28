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
  @override
  Widget build(BuildContext context) {
    return UserDetails(context);
  }

  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    var fetchedDatas = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.post?.userId)
        .get();
    setState(() {
      _user = UserModel.fromJson(fetchedDatas.data()!);
    });
  }

  Widget UserDetails(BuildContext context) {
    List created = timeFormat().timeFormatter(widget.post?.created_at ?? 0);
    return Row(
      children: [
        userProfile(user: _user),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                _user?.name ?? "",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Color(0XFF3e003e),
                      fontSize: 16,
                    ),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  "@${_user?.username ?? ""}",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Color.fromARGB(119, 62, 0, 62),
                        fontSize: 16,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: timeText(created[1], created[0], context),
              ),
            ],
          ),
        )
      ],
    );
  }

  Text timeText(created, d, BuildContext context) {
    return Text(" - " + (created.toString()) + d,
        style: TextStyle(
          color: Color.fromARGB(119, 62, 0, 62),
          fontSize: 16,
        ));
  }
}
