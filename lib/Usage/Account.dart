import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/Sharing.dart';
import 'package:flutter_application_1/Components/projectTitle.dart';
import 'package:flutter_application_1/Models/PostModel.dart';
import 'package:flutter_application_1/Models/UserModel.dart';
import 'package:flutter_application_1/Register/login.dart';
import 'package:flutter_application_1/Resources/auth_methods.dart';
import 'package:flutter_application_1/Resources/firestore_methods.dart';
import 'package:flutter_application_1/Theme/Theme.dart';
import 'package:flutter_application_1/Usage/DM.dart';
import 'package:flutter_application_1/Usage/Message.dart';
import 'package:flutter_application_1/Usage/editAccount.dart';

class Account extends StatefulWidget {
  Account({super.key, required this.userId});
  String userId;
  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowRequest = false;
  bool isLoading = false;
  bool _isShowUserAbout = false;
  UserModel? _user;
  bool isFollowing = false;

  void _accountSettings() {}

  @override
  void initState() {
    super.initState();
    getData();
  }

  void signOut() async {
    await AuthMethods().signOut();
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const login()));
    }
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();
      if (userSnap.data() != null) {
        _user = UserModel.fromJson(userSnap.data() as Map<String, dynamic>);
      }
      getUserFollowRequest();
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('user_Id', isEqualTo: widget.userId)
          .orderBy("created_at", descending: true)
          .get();
      final _fetchedPosts = postSnap.docs.map((doc) => doc.data()).toList();
      postLen = _fetchedPosts.length;
      followers = _user?.followers?.length ?? 0;
      following = _user?.following?.length ?? 0;
      isFollowing =
          _user?.followers?.contains(FirebaseAuth.instance.currentUser!.uid) ??
              true;
      isFollowRequest = _user?.notifications?.follow
              ?.contains(FirebaseAuth.instance.currentUser!.uid) ??
          false;
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
        appBar: AppBar(title: projectTitle().appBarTitle("ShareIT")),
        body: isLoading
            ? LinearProgressIndicator()
            : Column(
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height / 3.5,
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
                                child: UserInfo(context, _user?.name ?? "",
                                    _user?.bio ?? "", _user?.username ?? ""))
                          ],
                        ),
                        (widget.userId ==
                                FirebaseAuth.instance.currentUser!.uid)
                            ? myButtons(context)
                            : userButtons(context),
                        Divider(),
                        const Text(
                          "Paylaşımlar",
                          style: TextStyle(
                              fontSize: 24,
                              color: Color(0xff3e003e),
                              fontWeight: FontWeight.w500),
                        ),
                      ]),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height / 1.88,
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("posts")
                            .where("user_Id", isEqualTo: _user?.userId)
                            .snapshots(),
                        builder: (context, posts) {
                          if (posts.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                          }
                          var fetchedPosts =
                              posts.data?.docs.map((e) => e.data()).toList();
                          if (fetchedPosts != null) {
                            List<PostModel> _posts = fetchedPosts
                                .map((e) => PostModel.fromJson(e))
                                .toList();
                            return ListView.builder(
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    PostView(post: _posts[index]),
                                    Divider()
                                  ],
                                );
                              },
                              itemCount: _posts.length,
                            );
                          }
                          return Text("${_user?.name} henüz post paylaşmamış");
                        }),
                  ),
                ],
              ));
  }

  bool isLoadingFollow = true;

  void changeLoadingFollow() {
    setState(() {
      isLoadingFollow = !isLoadingFollow;
    });
  }

  Future<void> addNotifications() async {
    changeLoadingFollow();
    await AuthMethods().addNotification(
        FirebaseAuth.instance.currentUser!.uid, _user!.userId!, true);
    setState(() {
      isFollowRequest = !isFollowRequest;
    });
    changeLoadingFollow();
  }

  Future<void> addFollow() async {
    changeLoadingFollow();
    await FireStoreMethods()
        .followUser(FirebaseAuth.instance.currentUser!.uid, _user!.userId!);
    changeLoadingFollow();
  }

  bool isFollowRequestSend = false;

  getUserFollowRequest() async {
    var dummy = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    UserModel currentUser = UserModel.fromJson(dummy.data()!);
    if (currentUser.notifications?.follow?.contains(_user!.userId) ?? false) {
      setState(() {
        isFollowRequestSend = true;
      });
    }
  }

  Row userButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        isFollowing
            ? removeFollowers()
            : isFollowRequestSend
                ? acceptRequestButton()
                : isFollowRequest
                    ? requestSendButton()
                    : followButton(),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MessageView(user: _user!)));
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
    );
  }

  ElevatedButton removeFollowers() {
    return ElevatedButton(
        onPressed: () {
          addFollow();
          setState(() {
            isFollowRequestSend = false;
            isFollowing = false;
          });
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: EdgeInsets.all(5),
            minimumSize: Size(150, 20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textStyle: ProjectTheme().theme.textTheme.bodySmall?.copyWith(
                  fontSize: 15,
                )),
        child: isLoadingFollow
            ? Text('Takipten çık', style: TextStyle(color: Color(0xff3e003e)))
            : SizedBox(
                height: 10,
                width: 10,
                child: CircularProgressIndicator.adaptive()));
  }

  ElevatedButton acceptRequestButton() {
    return ElevatedButton(
        onPressed: () {
          addFollow();
          setState(() {
            isFollowRequestSend = false;
            isFollowing = true;
          });
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: EdgeInsets.all(5),
            minimumSize: Size(150, 20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textStyle: ProjectTheme().theme.textTheme.bodySmall?.copyWith(
                  fontSize: 15,
                )),
        child: isLoadingFollow
            ? Text('İsteği kabul et',
                style: TextStyle(color: Color(0xff3e003e)))
            : SizedBox(
                height: 10,
                width: 10,
                child: CircularProgressIndicator.adaptive()));
  }

  ElevatedButton followButton() {
    return ElevatedButton(
        onPressed: addNotifications,
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(5),
            minimumSize: Size(150, 20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textStyle: ProjectTheme()
                .theme
                .textTheme
                .bodySmall
                ?.copyWith(fontSize: 15)),
        child: isLoadingFollow
            ? Text('Takip et')
            : SizedBox(
                height: 10,
                width: 10,
                child: CircularProgressIndicator.adaptive(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white))));
  }

  ElevatedButton requestSendButton() {
    return ElevatedButton(
        onPressed: addNotifications,
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: EdgeInsets.all(5),
            minimumSize: Size(150, 20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textStyle: ProjectTheme().theme.textTheme.bodySmall?.copyWith(
                  fontSize: 15,
                )),
        child: isLoadingFollow
            ? Text('İstek gönderildi',
                style: TextStyle(color: Color(0xff3e003e)))
            : SizedBox(
                height: 10,
                width: 10,
                child: CircularProgressIndicator.adaptive()));
  }

  Row myButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const editAccount(),
              )),
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
          child: const Text('Profili düzenle'),
        ),
        ElevatedButton(
          onPressed: signOut,
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
          child: const Text('Çıkış yap'),
        ),
      ],
    );
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
              width: 10,
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
          padding: EdgeInsets.only(top: 5),
          alignment: Alignment.topLeft,
          child: Text(bio,
              maxLines: 3,
              overflow: TextOverflow.fade,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Color(0xff3e003e), fontSize: 14)),
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
      child: CircleAvatar(
          minRadius: 50,
          backgroundImage: NetworkImage(photo.length == 0
              ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlzWGeKBgGeQ_zA2_-P89bHLjOVxE0JQA0jQ&usqp=CAU"
              : photo)),
    );
  }
}
