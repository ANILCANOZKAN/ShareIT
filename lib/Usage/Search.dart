import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/searchStateUsers.dart';
import 'package:flutter_application_1/Database/algolia.dart';
import 'package:flutter_application_1/Models/PostModel.dart';
import 'package:flutter_application_1/Models/UserModel.dart';
import 'package:flutter_application_1/View/SharedPostView.dart';

class Search extends StatefulWidget {
  Search({super.key});

  @override
  State<Search> createState() => SearchState();
}

class SearchState extends State<Search> {
  static const List<Tab> searchTabs = <Tab>[
    Tab(child: tabBarContainer(text: "Kişiler")),
    Tab(child: tabBarContainer(text: "Paylaşımlar")),
  ];

  String searchedText = "";
  int index = 0;
  bool isLoading = true;
  final algolia = AlgoliaInit().algolia;

  void changeLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void changeTabIndex(value) {
    setState(() {
      index = value;
    });
  }

  void changeSearchText(text) {
    setState(() {
      searchedText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(65),
              child: AppBar(
                automaticallyImplyLeading: false,
                bottom: TabBar(
                    onTap: (value) {
                      changeTabIndex(value);
                    },
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: searchTabs),
              ),
            ),
            body: Column(children: [
              searchField(),
              Divider(),
              Expanded(
                flex: 9,
                child: TabBarView(children: [
                  searchUserWidget(text: searchedText),
                  searchPostWidget(text: searchedText)
                ]),
              ),
            ])));
  }

  Padding searchField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: TextField(
          onChanged: (text) {
            changeSearchText(text);
          },
          cursorHeight: 15,
          style: TextStyle(height: 1),
          decoration: InputDecoration(
            suffixIcon: Icon(
              Icons.search_outlined,
              color: Color(0xff3e003e),
            ),
            hintText: " Ara",
          )),
    );
  }
}

class searchPostWidget extends StatelessWidget {
  searchPostWidget({super.key, required this.text});

  String text;

  final algolia = AlgoliaInit().algolia;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
            algolia.index("ShareIT_posts").query(text).getObjects().asStream(),
        builder: (context, posts) {
          if (posts.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          final response = posts.data;
          List<PostModel>? _posts =
              response?.hits.map((e) => PostModel.fromJson(e.data)).toList();
          return Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    SharedPostView(postId: _posts?[index].post_Id),
                    Divider()
                  ],
                );
              },
              itemCount: _posts?.length ?? 0,
            ),
          );
        });
  }
}

class searchUserWidget extends StatelessWidget {
  searchUserWidget({super.key, required this.text});
  String text;
  final algolia = AlgoliaInit().algolia;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: algolia.index("ShareIT").query(text).getObjects().asStream(),
        builder: (context, searchedUsers) {
          if (searchedUsers.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          final response = searchedUsers.data;
          List<UserModel>? _users =
              response?.hits.map((e) => UserModel.fromJson(e.data)).toList();
          return Expanded(child: searchStateUsers(_users));
        });
  }
}

class tabBarContainer extends StatefulWidget {
  const tabBarContainer({super.key, required this.text});
  final String text;

  @override
  State<tabBarContainer> createState() => _tabBarContainerState();
}

class _tabBarContainerState extends State<tabBarContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        alignment: Alignment.center,
        child: Text(
          widget.text,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Color(0xff3e003e), fontSize: 20),
        ));
  }
}
