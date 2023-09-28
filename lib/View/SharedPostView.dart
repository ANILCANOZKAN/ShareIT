import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/SharedUserText.dart';
import 'package:flutter_application_1/Components/userView.dart';
import 'package:flutter_application_1/FullScreen/sharedPostFullView.dart';
import 'package:flutter_application_1/Models/PostModel.dart';

class SharedPostView extends StatefulWidget {
  SharedPostView({super.key, this.postId});
  String? postId;
  @override
  State<SharedPostView> createState() => _SharedPostViewState();
}

class _SharedPostViewState extends State<SharedPostView> {
  PostModel? post;
  bool isLoading = true;

  void initState() {
    super.initState();
    getPost();
  }

  Future<void> getPost() async {
    setState(() {
      isLoading = false;
    });
    var gettingPost = await FirebaseFirestore.instance
        .collection("posts")
        .doc(widget.postId)
        .get();
    if (gettingPost.data() != null) {
      setState(() {
        isLoading = true;
        post = PostModel.fromJson(gettingPost.data() as Map<String, dynamic>);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.white),
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)))),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => sharedPostFullView(
                          post: post,
                        )));
          },
          child: isLoading
              ? Column(
                  children: [userView(post: post), SharedUserText(post: post)])
              : CircularProgressIndicator.adaptive()),
    );
    ;
  }
}
