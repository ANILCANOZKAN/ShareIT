import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/CommentWidget.dart';
import 'package:flutter_application_1/Components/userView.dart';
import 'package:flutter_application_1/Models/PostModel.dart';

import 'package:flutter_application_1/Theme/Theme.dart';

class smallIcon {
  static double smallIconSize = 25;
}

class PostView extends StatefulWidget {
  const PostView({super.key, required this.post});
  final PostModel? post;

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  @override
  Widget build(BuildContext context) {
    if (widget.post?.body != null) {
      return Column(
        children: [
          Column(children: [
            userView(post: widget.post),
            UserText(body: widget.post?.body, media: widget.post?.media ?? null)
          ]),
          SharingUtility(post: widget.post),
          Divider(),
        ],
      );
    } else {
      return SizedBox();
    }
  }
}

class UserText extends StatefulWidget {
  const UserText({
    super.key,
    required this.body,
    required this.media,
  });
  final String? body;
  final Media? media;
  @override
  State<UserText> createState() => _UserTextState();
}

class _UserTextState extends State<UserText> {
  bool _isShowPost = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _UserText(isShowPost: _isShowPost, text: widget.body ?? ""),
        if (widget.body!.length > 250)
          showPostButton()
        else
          SizedBox(
            height: 20,
          ),
        widget.media?.imageUrl != null ? userImageView() : SizedBox(),
      ],
    );
  }

  SizedBox userImageView() {
    return SizedBox(
        height: 260,
        child: PageView.builder(
          itemBuilder: (context, index) {
            return UserImage(widget.media?.imageUrl?[index] ?? "");
          },
          itemCount: widget.media?.imageUrl?.length,
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
              Navigator.pushNamed(context, "/image");
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

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Color.fromARGB(34, 255, 255, 255),
            border: Border.all(color: Color(0xff3e003e)),
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          getIconButton(
            selectedIcon: Icons.home_outlined,
            route: "/home",
          ),
          getIconButton(
            selectedIcon: Icons.search_rounded,
            route: "/search",
          ),
          getIconButton(selectedIcon: Icons.add_circle_outline_rounded),
          getIconButton(
            selectedIcon: Icons.trending_up_rounded,
            route: "/trends",
          ),
          getIconButton(
            selectedIcon: Icons.account_circle_outlined,
            route: "/account",
          ),
        ]));
  }
}

class getIconButton extends StatelessWidget {
  getIconButton({
    super.key,
    required this.selectedIcon,
    this.selectedSize = 35,
    this.route = "/home",
    this.function,
  });

  final IconData selectedIcon;
  final double? selectedSize;
  final String? route;
  final void function;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pushNamed(context, route ?? "/home");
        },
        icon: Icon(
          selectedIcon,
          size: selectedSize,
          color: Color(0xff3e003e),
        ));
  }
}

class SharingUtility extends StatefulWidget {
  const SharingUtility({super.key, required this.post});
  final PostModel? post;
  @override
  State<SharingUtility> createState() => _SharingUtilityState();
}

class _SharingUtilityState extends State<SharingUtility> {
  int commentLine = 2;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            getIconButton(
              selectedIcon: Icons.favorite_outline_rounded,
              selectedSize: smallIcon.smallIconSize,
            ),
            IconButton(
                onPressed: () {
                  CommentWidget().addCommentSection(context);
                },
                icon: Icon(
                  Icons.add_comment_outlined,
                  color: Color(0xff3e003e),
                  size: 25,
                )),
            getIconButton(
              selectedIcon: Icons.share_outlined,
              selectedSize: smallIcon.smallIconSize,
            )
          ],
        ),
        Container(
          padding: const EdgeInsets.only(left: 17),
          alignment: Alignment.topLeft,
          child: Text('${widget.post?.like ?? 0} Beğeni',
              style: ProjectTheme()
                  .theme
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: const Color(0xff3e003e))),
        ),
        Container(
          padding: const EdgeInsets.only(left: 10),
          alignment: Alignment.topLeft,
          child: TextButton(
            onPressed: () {
              CommentWidget().showComment(context, widget.post?.post_Id);
            },
            child: Text("Yorumları göster"),
          ),
        ),
      ],
    );
  }
}
