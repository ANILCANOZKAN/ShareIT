import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/viewComment.dart';
import 'package:flutter_application_1/Models/CommentModel.dart';

class CommentWidget {
  void showComment(BuildContext context, String? post_id) {
    CommentSection(context, post_id);
  }

  void CommentSection(context, String? post_Id) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        context: context,
        isScrollControlled: true,
        builder: (_) => commentBottomSheet(context: context, post_Id: post_Id));
  }

  void addCommentSection(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        context: context,
        builder: (BuildContext bc) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: _addComment(),
          );
        });
  }
}

class _addComment extends StatefulWidget {
  _addComment({
    super.key,
  });

  @override
  State<_addComment> createState() => _addCommentState();
}

class _addCommentState extends State<_addComment> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
              decoration: InputDecoration(
                  hintText: "Yorum yap",
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 68,
                      maxHeight: 30))),
        ),
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.send_outlined,
              color: Color(0xff3e003e),
            ))
      ],
    );
  }
}

class commentBottomSheet extends StatefulWidget {
  commentBottomSheet({super.key, required context, this.post_Id});
  String? post_Id;
  @override
  State<commentBottomSheet> createState() => _commentBottomSheetState();
}

class _commentBottomSheetState extends State<commentBottomSheet> {
  List<CommentModel>? _comments;

  bool isCommentsLoading = false;

  void initState() {
    super.initState();
    getComments(widget.post_Id);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 40),
            child: const Text(
              "Yorumlar",
              style: TextStyle(
                  color: Color(0xff3e003e),
                  fontWeight: FontWeight.w600,
                  fontSize: 15),
            ),
          ),
          const Divider(),
          Expanded(
            flex: 9,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: _comments?.length ?? 0,
              itemBuilder: (context, index) {
                return viewComment(comment: _comments?[index]);
              },
            ),
          ),
          Divider(),
          _addComment(),
        ],
      ),
    );
  }

  void changeCommentsLoading() {
    isCommentsLoading = !isCommentsLoading;
  }

  void getComments(post_Id) async {
    var db = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await db
        .collection("comments")
        .where("post_Id", isEqualTo: post_Id)
        .get();

    final _fetchedDatas = querySnapshot.docs.map((doc) => doc.data()).toList();

    if (_fetchedDatas is List && _fetchedDatas != null) {
      setState(() {
        _comments = _fetchedDatas.map((e) => CommentModel.fromJson(e)).toList();
      });
    }
    changeCommentsLoading();
  }
}
