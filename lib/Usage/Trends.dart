import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/Sharing.dart';
import 'package:flutter_application_1/Components/projectTitle.dart';
import 'package:flutter_application_1/Models/PostModel.dart';
import 'package:flutter_application_1/Models/UserModel.dart';
import 'package:flutter_application_1/Resources/auth_methods.dart';
import 'package:flutter_application_1/Theme/Theme.dart';
import 'package:flutter_application_1/Usage/Notifications.dart';
import 'package:flutter_application_1/Usage/Search.dart';

class trendsView extends StatefulWidget {
  @override
  State<trendsView> createState() => _trendsViewState();
}

class _trendsViewState extends State<trendsView> {
  List<PostModel>? _posts;
  int index = 0;
  bool isLoading = true;
  DateTime today = DateTime.now();
  int timeQuery = DateTime(2022, 8, 30, 00, 00).millisecondsSinceEpoch;
  bool isNot = false;

  UserModel? user;

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

  void changeIndex(value) {
    setState(() {
      index = value;
    });

    if (index == 1) {
      //bu ay
      setState(() {
        timeQuery =
            today.subtract(new Duration(days: 30)).millisecondsSinceEpoch;
      });
    } else if (index == 2) {
      //bu hafta
      setState(() {
        timeQuery =
            today.subtract(new Duration(days: 7)).millisecondsSinceEpoch;
      });
    } else {
      setState(() {
        timeQuery = DateTime(2022, 8, 30, 00, 00).millisecondsSinceEpoch;
      });
    }
  }

  void initState() {
    super.initState();
    getUser();
  }

  void changeLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  getPosts(tabIndex) async {}

  @override
  Widget build(BuildContext context) {
    const String _title = "ShareIT";

    return DefaultTabController(
      length: 3,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (BuildContext, bool isScrolled) {
                return [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    title: projectTitle().appBarTitle(_title),
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
                                      builder: (context) =>
                                          NotificationsView()));
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
                                    constraints: BoxConstraints(
                                        maxHeight: 8, maxWidth: 8),
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
              body: Column(
                children: [
                  TabBar(
                      onTap: (value) {
                        changeIndex(value);
                      },
                      tabs: const [
                        tabBarContainer(text: "Tüm zamanlar"),
                        tabBarContainer(text: "Bu ay"),
                        tabBarContainer(text: "Bu hafta")
                      ]),
                  Expanded(
                    flex: 9,
                    child: Column(children: [
                      Expanded(
                        flex: 9,
                        child: TabBarView(children: [
                          trendPosts(),
                          trendPosts(),
                          trendPosts()
                        ]),
                      ),
                    ]),
                  ),
                ],
              ))),
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> trendPosts() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("posts")
          .where("created_at", isGreaterThanOrEqualTo: timeQuery)
          .limit(100)
          .snapshots(),
      builder: (context, posts) {
        if (posts.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        List _fetchedPost =
            posts.data?.docs.map((e) => e.data()).toList() ?? [];
        if (_fetchedPost.isNotEmpty) {
          _posts = _fetchedPost.map((e) => PostModel.fromJson(e)).toList();
          return trendsTabViews(isLoading: isLoading, posts: _posts);
        } else {
          return Text("Post bulunamadı");
        }
      },
    );
  }
}

class trendsTabViews extends StatelessWidget {
  const trendsTabViews({
    super.key,
    required this.isLoading,
    required List<PostModel>? posts,
  }) : _posts = posts;

  final bool isLoading;
  final List<PostModel>? _posts;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child: isLoading
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [PostView(post: _posts?[index]), Divider()],
                    );
                  },
                  itemCount: _posts?.length ?? 0,
                )
              : LinearProgressIndicator()),
    ]);
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
