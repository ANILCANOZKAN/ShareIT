import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/PostModel.dart';
import 'package:flutter_application_1/Resources/firestore_methods.dart';
import 'package:flutter_application_1/Theme/Theme.dart';
import 'package:flutter_application_1/layout/layout.dart';

class ImageView extends StatefulWidget {
  ImageView({super.key, required this.post});

  PostModel? post;

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  TextEditingController _textController = TextEditingController();

  String response = "";
  String returned = "";

  void postComment() async {
    response = await FireStoreMethods().postComment(widget.post!.post_Id!,
        _textController.text, FirebaseAuth.instance.currentUser!.uid);

    if (response == "success") {
      setState(() {
        _textController.text = "";
        returned = "Yorumunuz başarıyla kaydedildi";
      });
    } else {
      setState(() {
        returned = " Bir hata oluştu";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                BackButton(context),
                _doComment(),
              ],
            ),
          ),
          Expanded(
              flex: 6,
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.post?.media?.imageUrl?.length,
                itemBuilder: (context, index) {
                  return UserImage(
                      context, widget.post?.media?.imageUrl?[index]);
                },
              )),
          Expanded(
            flex: 2,
            child: ImageButton(post: widget.post!),
          )
        ],
      ),
    );
  }

  Container _doComment() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Text(
              returned,
              style: TextStyle(color: Colors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextField(
                  controller: _textController,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Colors.white,
                  decoration: const InputDecoration(
                      hintText: "Yorum yap",
                      hintStyle: TextStyle(color: Colors.white),
                      fillColor: Colors.black26,
                      filled: true,
                      constraints:
                          BoxConstraints(maxWidth: 323, maxHeight: 30)),
                ),
                IconButton(
                    onPressed: postComment,
                    icon: Icon(
                      Icons.send_outlined,
                      color: ProjectTheme().theme.iconTheme.color,
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Padding BackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 25, 0, 0),
      child: Container(
          alignment: Alignment.topLeft,
          child: TextButton(
            child: Icon(
              Icons.chevron_left_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
    );
  }

  UserImage(context, imageUrl) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Image.network(
          imageUrl,
          errorBuilder: (context, error, stackTrace) => Center(
            child: Text(
              "Resim bulunamadı",
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
          ),
        ));
  }
}

class ImageButton extends StatefulWidget {
  ImageButton({
    super.key,
    required this.post,
  });

  PostModel post;

  @override
  State<ImageButton> createState() => _ImageButtonState();
}

class _ImageButtonState extends State<ImageButton> {
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _isLiked =
        widget.post.like?.contains(FirebaseAuth.instance.currentUser?.uid) ??
            false;
  }

  void changeLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  Future<void> postLike() async {
    await FireStoreMethods().likePost(widget.post.post_Id!,
        FirebaseAuth.instance.currentUser!.uid, widget.post.like!);
    changeLike();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          IconButton(
              onPressed: postLike,
              icon: Icon(
                _isLiked
                    ? Icons.favorite_rounded
                    : Icons.favorite_outline_outlined,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          layout(page: 2, sharedPost: widget.post),
                    ));
              },
              icon: Icon(
                Icons.share_outlined,
                color: Colors.white,
              ))
        ],
      ),
    );
  }
}
