import 'dart:ffi';

import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Components/Sharing.dart';
import 'package:flutter_application_1/Components/projectTitle.dart';
import 'package:flutter_application_1/Database/algolia.dart';
import 'package:flutter_application_1/Models/PostModel.dart';
import 'package:flutter_application_1/Models/UserModel.dart';
import 'package:flutter_application_1/Theme/Theme.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class home extends StatefulWidget {
  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  List<PostModel>? _posts;
  bool isLoading = true;
  void initState() {
    super.initState();
    getPosts();
  }

  void changeLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  Future<void> getPosts() async {
    changeLoading();
    final algolia = AlgoliaInit().algolia;
    AlgoliaQuery query = algolia.instance.index("ShareIT_posts");
    AlgoliaQuerySnapshot querySnapshot = await query.getObjects();
    List<AlgoliaObjectSnapshot> response = querySnapshot.hits;
    final _fetchedDatas = response.map((doc) => doc.data).toList();

    if (_fetchedDatas is List) {
      setState(() {
        _posts = _fetchedDatas.map((e) => PostModel.fromJson(e)).toList();
      });
    }
    changeLoading();
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
            body: Column(mainAxisSize: MainAxisSize.min, children: [
              Expanded(
                  flex: 9,
                  child: isLoading
                      ? ListView.builder(
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return PostView(post: _posts?[index]);
                          },
                          itemCount: _posts?.length ?? 0,
                        )
                      : LinearProgressIndicator()),
              Expanded(flex: 1, child: Footer())
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
