import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/UserProfilePicture.dart';
import 'package:flutter_application_1/Models/CommentModel.dart';
import 'package:flutter_application_1/Models/UserModel.dart';

class viewComment extends StatefulWidget {
  viewComment({super.key, this.comment});
  CommentModel? comment;
  @override
  State<viewComment> createState() => _viewCommentState();
}

class _viewCommentState extends State<viewComment> {
  bool isUserLoading = false;
  List<UserModel>? _user;

  void initState() {
    super.initState();
    getUser(widget.comment?.userId ?? "");
  }

  Future<void> getUser(userId) async {
    var db = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot =
        await db.collection("users").where("userId", isEqualTo: userId).get();
    final fetchedDatas = querySnapshot.docs.map((doc) => doc.data()).toList();
    if (fetchedDatas is List && fetchedDatas != null) {
      setState(() {
        _user = fetchedDatas.map((e) => UserModel.fromJson(e)).toList();
      });
    }
    changeUserLoading();
  }

  @override
  Widget build(BuildContext context) {
    return isUserLoading
        ? SizedBox(
            height: 80,
            child: Row(
              children: [
                SizedBox(
                    width: 60,
                    child: userProfile(
                      userPhoto: _user?[0].photo ?? "",
                    )),
                Container(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 82,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _user?[0].username ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                  color: Color(0xff3e003e),
                                  fontWeight: FontWeight.w500),
                            ),
                            const Text(
                              "Tarih",
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
            ),
          )
        : LinearProgressIndicator();
  }

  void changeUserLoading() {
    setState(() {
      isUserLoading = !isUserLoading;
    });
  }
}
