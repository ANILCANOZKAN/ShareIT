import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/projectTitle.dart';
import 'package:flutter_application_1/Components/searchStateUsers.dart';
import 'package:flutter_application_1/Models/PostModel.dart';
import 'package:flutter_application_1/Models/UserModel.dart';
import 'package:flutter_application_1/Provider/UserProvider.dart';
import 'package:flutter_application_1/Usage/Search.dart';
import 'package:flutter_application_1/View/SharedPostView.dart';
import 'package:flutter_application_1/sharedPostCard.dart';
import 'package:provider/provider.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  initState() {
    super.initState();
    getFollowNotifications();
  }

  List followRequest = [];
  List<UserModel> followRequestUsers = [];
  bool isLoadingFollowRequest = true;

  List comment = [];
  List<PostModel> commentPost = [];
  bool isCommentLoading = true;

  UserModel? currentUser;

  changeLoadingFollowRequest() {
    setState(() {
      isLoadingFollowRequest = !isLoadingFollowRequest;
    });
  }

  changeLoadingComment() {
    setState(() {
      isCommentLoading = !isCommentLoading;
    });
  }

  Future<void> getCommentNotifications() async {
    changeLoadingComment();
    var dummy = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    UserModel user = UserModel.fromJson(dummy.data()!);
    setState(() {
      comment = user.notifications?.comment ?? [];
    });
    await getCommentPosts();
    changeLoadingComment();
  }

  getPost(String post_id) async {
    var dummy =
        await FirebaseFirestore.instance.collection("posts").doc(post_id).get();
    return PostModel.fromJson(dummy.data()!);
  }

  Future<void> getCommentPosts() async {
    for (int i = 0; i < comment.length; i++) {
      PostModel post = await getPost(comment[i]);
      setState(() {
        commentPost.add(post);
      });
    }
  }

  Future<void> getFollowNotifications() async {
    changeLoadingFollowRequest();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"notification": false});
    var dummy = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    UserModel user = UserModel.fromJson(dummy.data()!);

    setState(() {
      followRequest = user.notifications?.follow ?? [];
    });
    await getFollowRequestUsers();
    changeLoadingFollowRequest();
    await getCommentNotifications();
  }

  Future<UserModel> getUser(String user_id) async {
    var dummy =
        await FirebaseFirestore.instance.collection("users").doc(user_id).get();
    return UserModel.fromJson(dummy.data()!);
  }

  getFollowRequestUsers() async {
    for (int i = 0; i < followRequest.length; i++) {
      UserModel user = await getUser(followRequest[i]);
      setState(() {
        followRequestUsers.add(user);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? currentUser = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
                onPressed: () => Navigator.pop(context, 'refresh'),
                icon: Icon(
                  Icons.chevron_left,
                  size: 30,
                ));
          },
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: projectTitle().appBarTitle(currentUser!.name!),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  notText("Takip istekleri"),
                  Divider(),
                  isLoadingFollowRequest
                      ? Expanded(child: searchStateUsers(followRequestUsers))
                      : CircularProgressIndicator.adaptive()
                ],
              ),
            ),
            Divider(),
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  notText("Yorumlar yapılan postlar"),
                  Divider(),
                  isCommentLoading
                      ? Expanded(
                          child: ListView.builder(
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                SharedPostView(
                                    postId: commentPost[index].post_Id),
                                Divider()
                              ],
                            );
                          },
                          itemCount: commentPost.length,
                        ))
                      : CircularProgressIndicator.adaptive(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text notText(String text) {
    return Text(
      text,
      style: TextStyle(
          color: Color(0xff3e003e), fontSize: 20, fontWeight: FontWeight.w500),
    );
  }
}
