import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/UserProfilePicture.dart';
import 'package:flutter_application_1/Components/timeFormat.dart';
import 'package:flutter_application_1/Models/CommentModel.dart';
import 'package:flutter_application_1/Models/UserModel.dart';

class viewComment extends StatefulWidget {
  viewComment({super.key, this.comment});
  CommentModel? comment;
  @override
  State<viewComment> createState() => _viewCommentState();
}

class _viewCommentState extends State<viewComment> {
  @override
  Widget build(BuildContext context) {
    List created = timeFormat().timeFormatter(widget.comment?.created_at ?? 0);
    return SizedBox(
      height: 80,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(widget.comment?.userId ?? "")
              .snapshots(),
          builder: (context, user) {
            if (user.connectionState == ConnectionState.waiting) {
              return LinearProgressIndicator();
            }
            if (user.data?.data() != null) {
              UserModel _user = UserModel.fromJson(user.data!.data()!);
              return Row(
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    child: userProfile(
                      user: _user,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 82,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                userInfo(_user.name ?? ""),
                                SizedBox(
                                  width: 10,
                                ),
                                userInfo(_user.username ?? "", isOp: true),
                              ]),
                              Text(
                                created[1].toString() + created[0].toString(),
                                maxLines: 1,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                    color: Color.fromARGB(119, 62, 0, 62),
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 82,
                          child: Text(widget.comment?.body ?? "",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                color: Color(0xff3e003e),
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }
            return SizedBox();
          }),
    );
  }
}

class userInfo extends StatelessWidget {
  userInfo(
    this.text, {
    super.key,
    this.isOp = false,
  });

  final String text;
  bool isOp;

  @override
  Widget build(BuildContext context) {
    return Text(
      isOp ? ("@" + text) : text,
      maxLines: 1,
      overflow: TextOverflow.fade,
      style: TextStyle(
          color: isOp ? Color.fromARGB(120, 62, 0, 62) : Color(0xff3e003e),
          fontWeight: FontWeight.w500),
    );
  }
}
