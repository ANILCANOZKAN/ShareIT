import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/PostModel.dart';
import 'package:flutter_application_1/Usage/Account.dart';
import 'package:flutter_application_1/Usage/Search.dart';
import 'package:flutter_application_1/Usage/Trends.dart';
import 'package:flutter_application_1/Usage/addPost.dart';
import 'package:flutter_application_1/Usage/home.dart';

class drawLayout extends StatefulWidget {
  drawLayout({this.page = 0, this.sharedPost, super.key});
  int page;
  PostModel? sharedPost;
  @override
  State<drawLayout> createState() => _drawLayoutState();
}

class _drawLayoutState extends State<drawLayout> {
  int _page = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.page);
    _page = widget.page;
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: [
          home(),
          Search(),
          addPost(
            currentUserId: FirebaseAuth.instance.currentUser!.uid,
            sharedPost: widget.sharedPost,
          ),
          trendsView(),
          Account(
            userId: FirebaseAuth.instance.currentUser!.uid,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        onTap: navigationTapped,
        currentIndex: _page,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              activeIcon: Icon(Icons.home_rounded),
              icon: Icon(
                Icons.home_outlined,
              ),
              label: "Anasayfa"),
          BottomNavigationBarItem(
              activeIcon: Icon(Icons.search_rounded),
              icon: Icon(
                Icons.search_outlined,
              ),
              label: "Ara"),
          BottomNavigationBarItem(
              activeIcon: Icon(Icons.add_circle_rounded),
              icon: Icon(
                Icons.add_circle_outline_rounded,
              ),
              label: "Paylaş"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.trending_up_rounded,
              ),
              label: "Trendler"),
          BottomNavigationBarItem(
              activeIcon: Icon(Icons.account_circle_rounded),
              icon: Icon(
                Icons.account_circle_outlined,
              ),
              label: "Profil"),
        ],
      ),
    );
  }
}
