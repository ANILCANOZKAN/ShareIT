import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/CommentWidget.dart';
import 'package:flutter_application_1/Components/userText.dart';
import 'package:flutter_application_1/Components/userView.dart';
import 'package:flutter_application_1/Models/PostModel.dart';
import 'package:flutter_application_1/Models/UserModel.dart';
import 'package:flutter_application_1/Provider/UserProvider.dart';
import 'package:flutter_application_1/Resources/firestore_methods.dart';

import 'package:flutter_application_1/Theme/Theme.dart';
import 'package:flutter_application_1/layout/layout.dart';
import 'package:provider/provider.dart';

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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(children: [
          userView(post: widget.post),
          UserText(post: widget.post),
        ]),
        SharingUtility(post: widget.post),
      ],
    );
  }
}

class getIconButton extends StatefulWidget {
  getIconButton({
    super.key,
    required this.selectedIcon,
    this.selectedSize = 35,
    this.route,
    this.function,
  });

  final IconData selectedIcon;
  final double? selectedSize;
  final String? route;
  final void function;

  @override
  State<getIconButton> createState() => _getIconButtonState();
}

class _getIconButtonState extends State<getIconButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pushNamed(context, widget.route ?? "/home").then((_) {
            setState(() {});
          });
        },
        icon: Icon(
          widget.selectedIcon,
          size: widget.selectedSize,
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
  void likePost(userId) {
    FireStoreMethods()
        .likePost(widget.post?.post_Id ?? "", userId, widget.post?.like ?? []);
  }

  @override
  Widget build(BuildContext context) {
    final UserModel? user = Provider.of<UserProvider>(context).getUser;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    (widget.post?.like?.contains(user?.userId) ?? true)
                        ? Icons.favorite_rounded
                        : Icons.favorite_outline_rounded,
                    color: Color(0xff3e003e),
                    size: smallIcon.smallIconSize,
                  ),
                  onPressed: () {
                    likePost(user?.userId);
                  },
                ),
                IconButton(
                    onPressed: () {
                      CommentWidget().CommentSection(
                          context,
                          user?.userId,
                          widget.post?.post_Id,
                          user?.username,
                          user?.name,
                          user?.photo,
                          true);
                    },
                    icon: Icon(
                      Icons.add_comment_outlined,
                      color: Color(0xff3e003e),
                      size: smallIcon.smallIconSize,
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
                    size: smallIcon.smallIconSize,
                    color: Color(0xff3e003e),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                CommentWidget().CommentSection(
                    context,
                    user?.userId,
                    widget.post?.post_Id,
                    user?.username,
                    user?.name,
                    user?.photo,
                    false);
              },
              child: Text("Yorumları göster"),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.only(left: 17),
          alignment: Alignment.topLeft,
          child: Text('${widget.post?.like?.length ?? 0} Beğeni',
              style: ProjectTheme()
                  .theme
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: const Color(0xff3e003e))),
        ),
      ],
    );
  }
}
