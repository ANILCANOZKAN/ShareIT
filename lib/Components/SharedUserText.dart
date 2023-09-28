import 'package:flutter/material.dart';
import 'package:flutter_application_1/FullScreen/ImageView.dart';
import 'package:flutter_application_1/Models/PostModel.dart';
import 'package:flutter_application_1/Theme/Theme.dart';

class SharedUserText extends StatefulWidget {
  SharedUserText({super.key, this.post});
  PostModel? post;
  @override
  State<SharedUserText> createState() => _SharedUserTextState();
}

class _SharedUserTextState extends State<SharedUserText> {
  bool _isShowPost = false;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _UserText(isShowPost: _isShowPost, text: widget.post?.body ?? ""),
      if ((widget.post?.body?.length ?? 0) > 250)
        showPostButton()
      else
        SizedBox(
          height: 20,
        ),
      widget.post?.media?.imageUrl != null ? userImageView() : SizedBox(),
    ]);
  }

  SizedBox userImageView() {
    return SizedBox(
        height: 260,
        child: PageView.builder(
          itemBuilder: (context, index) {
            return UserImage(widget.post?.media?.imageUrl?[index] ?? "");
          },
          itemCount: widget.post?.media?.imageUrl?.length,
        ));
  }

  TextButton showPostButton() {
    return TextButton(
      child: Text(
        _isShowPost ? "Gizle" : "Devamını göster",
      ),
      onPressed: () {
        setState(() {
          _isShowPost = !_isShowPost;
        });
      },
    );
  }

  SizedBox UserImage(image) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: BeveledRectangleBorder(), padding: EdgeInsets.all(0)),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ImageView(post: widget.post)));
            },
            child: Image.network(image,
                errorBuilder: (context, error, stackTrace) => imageError())));
  }

  Widget imageError() {
    return Text("Resim bulunamadı");
  }
}

class _UserText extends StatelessWidget {
  const _UserText({
    super.key,
    required bool isShowPost,
    required String text,
  })  : _isShowPost = isShowPost,
        _text = text;

  final bool _isShowPost;
  final String _text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: AnimatedCrossFade(
        duration: Duration(milliseconds: 200),
        crossFadeState:
            _isShowPost ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        firstChild: Text(
          style: ProjectTheme()
              .theme
              .textTheme
              .bodyLarge
              ?.copyWith(height: 2, fontSize: 15),
          _text,
        ),
        secondChild: Text(
          style: ProjectTheme().theme.textTheme.bodyLarge?.copyWith(
              overflow: TextOverflow.ellipsis, height: 2, fontSize: 15),
          _text,
          maxLines: 6,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
