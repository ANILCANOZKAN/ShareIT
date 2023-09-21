import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/Sharing.dart';
import 'package:flutter_application_1/Components/projectTitle.dart';
import 'package:flutter_application_1/Models/PostModel.dart';
import 'package:flutter_application_1/Models/UserModel.dart';
import 'package:flutter_application_1/Theme/Theme.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  bool _isShowUserAbout = false;
  List<PostModel>? _posts;
  UserModel? _user;

  void _accountSettings() {}

  @override
  void initState() {
    super.initState();
    getData();
  }

  String userid = "HfodpEPyhv7YMl792rpM";

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userid)
          .get();
      if (userSnap.data() != null) {
        _user = UserModel.fromJson(userSnap.data() as Map<String, dynamic>);
      }

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('user_Id', isEqualTo: userid)
          .get();
      final _fetchedPosts = postSnap.docs.map((doc) => doc.data()).toList();
      if (_fetchedPosts is List) {
        setState(() {
          _posts = _fetchedPosts.map((e) => PostModel.fromJson(e)).toList();
        });
      }
      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap.data()!['followers'].contains(userid);
      setState(() {});
    } catch (e) {
      SnackBar(
        content: Text(e.toString()),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        endDrawer: Drawer(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Column(
              children: [
                Container(
                  color: Colors.red,
                )
              ],
            )),
        appBar: AppBar(title: projectTitle().appBarTitle("ShareIT")),
        body: isLoading
            ? LinearProgressIndicator()
            : Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(5, 8, 5, 0),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _userPP(photo: _user?.photo ?? ""),
                            UserStatics(context, "Gönderiler", postLen),
                            UserStatics(context, "Takipçi", followers),
                            UserStatics(context, "Takip", following),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                                alignment: Alignment.topLeft,
                                child: UserInfo(context, _user?.username ?? "",
                                    _user?.bio ?? "", _user?.username ?? ""))
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(5),
                                    minimumSize: Size(150, 20),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    textStyle: ProjectTheme()
                                        .theme
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(fontSize: 15)),
                                child: const Text('Takip et'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, "/message");
                                },
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(5),
                                    minimumSize: Size(150, 20),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    textStyle: ProjectTheme()
                                        .theme
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(fontSize: 15)),
                                child: const Text('Mesaj'),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        Text(
                          "Paylaşımlar",
                          style: TextStyle(
                              fontSize: 24,
                              color: Color(0xff3e003e),
                              fontWeight: FontWeight.w500),
                        ),
                      ]),
                    ),
                  ),
                  Expanded(
                      flex: 7,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return PostView(post: _posts?[index]);
                        },
                        itemCount: _posts?.length ?? 0,
                      )),
                  Expanded(
                    child: Footer(),
                    flex: 1,
                  )
                ],
              ));
  }

  Column UserStatics(BuildContext context, String text, int number) {
    return Column(
      children: [
        Text(number.toString(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Color(0xff3e003e),
                fontWeight: FontWeight.w700,
                fontSize: 15)),
        Text(text,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Color(0xff3e003e), fontSize: 15)),
      ],
    );
  }

  Column UserInfo(
      BuildContext context, String Name, String bio, String username) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Text(Name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Color(0xff3e003e),
                      fontWeight: FontWeight.w700,
                      fontSize: 14)),
            ),
            SizedBox(
              width: 20,
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Text("@" + username,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Color.fromARGB(119, 62, 0, 62),
                      fontWeight: FontWeight.w700,
                      fontSize: 14)),
            ),
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.topLeft,
          child: TextButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero)),
              onPressed: _showUserAbout,
              child: AnimatedCrossFade(
                crossFadeState: _isShowUserAbout
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: Duration(milliseconds: 200),
                firstChild: Text(bio,
                    maxLines: 3,
                    overflow: TextOverflow.fade,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Color(0xff3e003e), fontSize: 14)),
                secondChild: Text(bio,
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Color(0xff3e003e), fontSize: 14)),
              )),
        ),
      ],
    );
  }

  void _showUserAbout() {
    setState(() {
      _isShowUserAbout = !_isShowUserAbout;
    });
  }
}

class _userPP extends StatelessWidget {
  _userPP({
    super.key,
    required this.photo,
  });

  String photo;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 80,
      child: CircleAvatar(minRadius: 50, backgroundImage: NetworkImage(photo)),
    );
  }
}
