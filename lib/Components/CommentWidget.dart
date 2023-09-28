import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Components/viewComment.dart';
import 'package:flutter_application_1/Models/CommentModel.dart';
import 'package:flutter_application_1/Resources/firestore_methods.dart';

class CommentWidget {
  void CommentSection(
      context,
      String? user_id,
      String? post_id,
      String? user_username,
      String? user_name,
      String? user_photo,
      bool? isAdd) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        context: context,
        isScrollControlled: true,
        builder: (_) => commentBottomSheet(
              context: context,
              post_id: post_id,
              user_id: user_id,
              user_name: user_name,
              user_username: user_username,
              user_photo: user_photo,
              isAdd: isAdd,
            ));
  }
}

class _addComment extends StatefulWidget {
  _addComment(
      {super.key,
      this.post_id,
      this.user_id,
      this.user_photo,
      this.user_username,
      this.user_name,
      this.isAdd});

  late String? post_id;
  late String? user_id;
  late String? user_photo;
  late String? user_username;
  late String? user_name;
  bool? isAdd;

  @override
  State<_addComment> createState() => _addCommentState();
}

class _addCommentState extends State<_addComment> {
  TextEditingController _commentTextController = TextEditingController();
  void dispose() {
    _commentTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
                autofocus: widget.isAdd ?? false,
                controller: _commentTextController,
                decoration: InputDecoration(
                    hintText: "Yorum yap",
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 68,
                        maxHeight: 30))),
          ),
          IconButton(
              onPressed: () {
                FireStoreMethods().postComment(widget.post_id ?? "",
                    _commentTextController.text, widget.user_id ?? "");
                setState(() {
                  _commentTextController.text = "";
                  widget.isAdd = false;
                });
              },
              icon: Icon(
                Icons.send_outlined,
                color: Color(0xff3e003e),
              ))
        ],
      ),
    );
  }
}

class commentBottomSheet extends StatefulWidget {
  commentBottomSheet(
      {super.key,
      required context,
      this.post_id,
      this.user_id,
      this.user_photo,
      this.user_username,
      this.user_name,
      this.isAdd});

  String? post_id;
  String? user_id;
  String? user_photo;
  String? user_username;
  String? user_name;
  bool? isAdd;
  @override
  State<commentBottomSheet> createState() => _commentBottomSheetState();
}

class _commentBottomSheetState extends State<commentBottomSheet> {
  List<CommentModel>? _comments;

  bool isCommentsLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 40),
          child: Text(
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
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("comments")
                  .where("post_Id", isEqualTo: widget.post_id)
                  .orderBy("created_at")
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                      _fetchedComments) {
                if (_fetchedComments.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemBuilder: (context, index) {
                    var _listedComments = _fetchedComments.data?.docs
                        .map((doc) => doc.data())
                        .toList();
                    if (_listedComments != null) {
                      _comments = _listedComments
                          .map(
                            (element) => CommentModel.fromJson(element),
                          )
                          .toList();
                    }
                    return viewComment(comment: _comments?[index]);
                  },
                  itemCount: _fetchedComments.data?.docs.length ?? 0,
                );
              },
            )),
        Divider(),
        _addComment(
          isAdd: widget.isAdd,
          post_id: widget.post_id,
          user_id: widget.user_id,
          user_name: widget.user_name,
          user_photo: widget.user_photo,
          user_username: widget.user_username,
        ),
      ],
    );
  }
}
