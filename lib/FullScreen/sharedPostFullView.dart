import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/Sharing.dart';
import 'package:flutter_application_1/Components/projectTitle.dart';
import 'package:flutter_application_1/Models/PostModel.dart';
import 'package:flutter_application_1/Models/UserModel.dart';

class sharedPostFullView extends StatefulWidget {
  sharedPostFullView({super.key, this.post});
  PostModel? post;

  @override
  State<sharedPostFullView> createState() => _sharedPostFullViewState();
}

class _sharedPostFullViewState extends State<sharedPostFullView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: projectTitle().appBarTitle("ShareIT"),
      ),
      body: ListView(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("posts")
                  .doc(widget.post!.post_Id!)
                  .snapshots(),
              builder: (context, post) {
                if (post.connectionState == ConnectionState.waiting) {
                  return SizedBox();
                }
                PostModel _post = PostModel.fromJson(post.data!.data()!);
                return PostView(post: _post);
              })
        ],
      ),
    );
  }
}
