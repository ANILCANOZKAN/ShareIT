import 'package:algolia/algolia.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/Sharing.dart';
import 'package:flutter_application_1/Components/searchStateUsers.dart';
import 'package:flutter_application_1/Database/algolia.dart';
import 'package:flutter_application_1/Models/PostModel.dart';
import 'package:flutter_application_1/Models/UserModel.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => SearchState();
}

class SearchState extends State<Search> {
  static const List<Tab> searchTabs = <Tab>[
    Tab(child: tabBarContainer(text: "Kişiler ve Sayfalar")),
    Tab(child: tabBarContainer(text: "Paylaşımlar")),
  ];

  String searchedText = "";
  int index = 0;
  List<UserModel>? _users;
  List<PostModel>? _posts;
  bool isLoading = true;

  void initState() {
    super.initState();
    getData(searchedText);
  }

  void changeLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  Future<void> getData(String text) async {
    changeLoading();
    if (index == 0) {
      final algolia = AlgoliaInit().algolia;
      AlgoliaQuery query = algolia.instance.index("ShareIT").query(text);
      AlgoliaQuerySnapshot querySnapshot = await query.getObjects();
      List<AlgoliaObjectSnapshot> response = querySnapshot.hits;
      final _fetchedDatas = response.map((doc) => doc.data).toList();
      setState(() {
        _users = _fetchedDatas.map((e) => UserModel.fromJson(e)).toList();
      });
    } else {
      final algolia = AlgoliaInit().algolia;
      AlgoliaQuery query = algolia.instance.index("ShareIT_posts").query(text);
      AlgoliaQuerySnapshot querySnapshot = await query.getObjects();
      List<AlgoliaObjectSnapshot> response = querySnapshot.hits;
      final _fetchedDatas = response.map((doc) => doc.data).toList();

      setState(() {
        _posts = _fetchedDatas.map((e) => PostModel.fromJson(e)).toList();
      });
    }
    changeLoading();
  }

  void changeTabIndex(value) {
    setState(() {
      index = value;
    });
    getData(searchedText);
  }

  void changeSearchText(text) {
    setState(() {
      searchedText = text;
    });
    getData(searchedText);
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
                  Column(children: [
                    isLoading
                        ? Expanded(
                            child: _users?.isEmpty ?? false
                                ? Text(
                                    "Kullanıcı bulunamadı",
                                    style: TextStyle(
                                        color: Color(0xff3e003e),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300),
                                  )
                                : searchStateUsers(_users))
                        : const LinearProgressIndicator()
                  ]),
                  Column(
                    children: [
                      isLoading
                          ? Expanded(
                              child: _posts?.isEmpty ?? false
                                  ? Text(
                                      "Post bulunamadı",
                                      style: TextStyle(
                                          color: Color(0xff3e003e),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w300),
                                    )
                                  : ListView.builder(
                                      itemBuilder: (context, index) {
                                        return PostView(post: _posts?[index]);
                                      },
                                      itemCount: _posts?.length ?? 0,
                                    ),
                            )
                          : const LinearProgressIndicator()
                    ],
                  ),
                ]),
              ),
              Expanded(flex: 1, child: Footer())
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
