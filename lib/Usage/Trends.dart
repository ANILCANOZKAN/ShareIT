import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/Sharing.dart';
import 'package:flutter_application_1/Components/projectTitle.dart';
import 'package:flutter_application_1/Models/PostModel.dart';
import 'package:flutter_application_1/Theme/Theme.dart';
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

  void changeIndex(value) {
    setState(() {
      index = value;
    });
    getPosts(index);
  }

  void initState() {
    super.initState();
    getPosts(index);
  }

  void changeLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  getPosts(tabIndex) async {
    changeLoading();
    DateTime timeQuery = DateTime(2022, 8, 30, 00, 00);
    if (tabIndex == 1) {
      //bu ay
      timeQuery = today.subtract(new Duration(days: 30));
    } else if (tabIndex == 2) {
      //bu hafta
      timeQuery = today.subtract(new Duration(days: 7));
    }
    var db = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await db
        .collection("posts")
        .where("created_at", isGreaterThanOrEqualTo: timeQuery)
        .limit(100)
        .get();
    final _fetchedDatas = querySnapshot.docs.map((doc) => doc.data()).toList();

    if (_fetchedDatas is List) {
      setState(() {
        _posts = _fetchedDatas.map((e) => PostModel.fromJson(e)).toList();
        _posts?.sort((a, b) => b.like!.compareTo(a.like!.toInt()));
      });
    }
    changeLoading();
  }

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
                      getIconButton(
                        selectedIcon: Icons.notifications_none_rounded,
                        selectedSize: 30,
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
                        tabBarContainer(text: "Tüm Zamanlar"),
                        tabBarContainer(text: "Bu ay"),
                        tabBarContainer(text: "Bu hafta")
                      ]),
                  Expanded(
                    flex: 9,
                    child: Column(children: [
                      Expanded(
                        flex: 9,
                        child: TabBarView(children: [
                          trendsTabViews(isLoading: isLoading, posts: _posts),
                          trendsTabViews(isLoading: isLoading, posts: _posts),
                          trendsTabViews(isLoading: isLoading, posts: _posts),
                        ]),
                      ),
                    ]),
                  ),
                  Expanded(flex: 1, child: Footer())
                ],
              ))),
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
                    return PostView(post: _posts?[index]);
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
