import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Components/Sharing.dart';
import 'package:flutter_application_1/Components/projectTitle.dart';
import 'package:flutter_application_1/Models/PostModel.dart';
import 'package:flutter_application_1/Models/UserModel.dart';
import 'package:flutter_application_1/Provider/UserProvider.dart';
import 'package:flutter_application_1/Resources/auth_methods.dart';
import 'package:flutter_application_1/Theme/Theme.dart';
import 'package:flutter_application_1/Usage/Notifications.dart';
import 'package:provider/provider.dart';

class home extends StatefulWidget {
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  List<PostModel>? _posts;
  UserModel? user;
  bool isNot = false;
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    user = await AuthMethods().getUserDetails();
    if (user!.notification!) {
      setState(() {
        isNot = true;
      });
    }
  }

  changeNot() {
    setState(() {
      isNot = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String _title = "ShareIT";
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (BuildContext, bool isScrolled) {
              return [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  title: projectTitle().appBarTitle(_title),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(15)),
                      side: BorderSide(color: Color(0xff3e003e))),
                  actions: [
                    Stack(
                      children: [
                        IconButton(
                          icon: Icon(Icons.notifications_none_rounded),
                          iconSize: 30,
                          onPressed: () async {
                            String refresh = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NotificationsView()));
                            if (refresh == "refresh") {
                              changeNot();
                            }
                          },
                        ),
                        isNot
                            ? Positioned(
                                left: 30,
                                top: 10,
                                child: Container(
                                  constraints:
                                      BoxConstraints(maxHeight: 8, maxWidth: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: const Color.fromARGB(
                                          255, 138, 28, 20)),
                                ))
                            : SizedBox()
                      ],
                    ),
                    getIconButton(
                      selectedIcon: Icons.message_outlined,
                      selectedSize: 30,
                      route: "/dm",
                    ),
                  ],
                ),
              ];
            },
            body: Column(mainAxisSize: MainAxisSize.min, children: [
              Expanded(
                  flex: 9,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("posts")
                          .orderBy("created_at", descending: true)
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              posts) {
                        if (posts.connectionState == ConnectionState.waiting) {
                          return LinearProgressIndicator();
                        }
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            var _fetchedPosts = posts.data?.docs
                                .map((doc) => doc.data())
                                .toList();
                            if (_fetchedPosts != null) {
                              _posts = _fetchedPosts
                                  .map(
                                    (element) => PostModel.fromJson(element),
                                  )
                                  .toList();
                            }
                            return Column(
                              children: [
                                PostView(post: _posts?[index]),
                                Divider(),
                              ],
                            );
                          },
                          itemCount: posts.data?.docs.length ?? 0,
                        );
                      }))
            ])));
  }
}

class UserCommentSection extends StatefulWidget {
  const UserCommentSection({super.key});

  @override
  State<UserCommentSection> createState() => _UserCommentSectionState();
}

class _UserCommentSectionState extends State<UserCommentSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 380,
          child: Row(
            children: [
              SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 15,
                child: Text(
                  "Kullanıcı paylaşım yorumu",
                  style: ProjectTheme().theme.textTheme.labelMedium,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 15,
        )
      ],
    );
  }
}

class textPadding {
  static EdgeInsetsGeometry paddingSize = EdgeInsets.only(left: 15);
}
