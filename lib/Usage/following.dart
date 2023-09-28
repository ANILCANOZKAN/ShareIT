import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/projectTitle.dart';
import 'package:flutter_application_1/Models/UserModel.dart';
import 'package:flutter_application_1/Usage/Message.dart';
import 'package:flutter_application_1/View/searchedUsers.dart';

class followersView extends StatefulWidget {
  const followersView({super.key});

  @override
  State<followersView> createState() => _followersViewState();
}

class _followersViewState extends State<followersView> {
  void initState() {
    super.initState();
    getData();
  }

  bool isLoading = true;

  List<UserModel> _users = [];
  List<UserModel> _filteredUsers = [];
  UserModel user = new UserModel();

  getData() async {
    changeLoading();
    var dummy = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    user = UserModel.fromJson(dummy.data()!);
    if (user.following?.isNotEmpty ?? false) {
      await getUsers();
      _filteredUsers = _users;
    }
    changeLoading();
  }

  void changeLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  getUsers() async {
    for (int i = 0; i < user.following!.length; i++) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.following?[i])
          .get()
          .then((value) => _users.add(UserModel.fromJson(value.data()!)));
    }
  }

  changeText(String text) {
    _filteredUsers = _users;
    setState(() {
      _filteredUsers = _filteredUsers
          .where((user) =>
              (user.username!.toLowerCase().contains(text.toLowerCase())) ||
              (user.name!.toLowerCase().contains(text.toLowerCase())))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        centerTitle: true,
        title: projectTitle().appBarTitleWithSize("Takip ettiklerin", 30),
      ),
      body: Column(children: [
        SearchField(),
        isLoading
            ? Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return SearchedUsers(user: _filteredUsers[index]);
                  },
                  itemCount: _users.length,
                ),
              )
            : Center(
                child: CircularProgressIndicator.adaptive(),
              )
      ]),
    );
  }

  Padding SearchField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: TextField(
          onChanged: (value) {
            changeText(value);
          },
          cursorHeight: 15,
          style: const TextStyle(height: 1),
          decoration: const InputDecoration(
              constraints: BoxConstraints(maxHeight: 30, maxWidth: 300),
              contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
              suffixIcon: Icon(
                Icons.search_outlined,
                color: Color(0xff3e003e),
              ),
              hintText: " Ara",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  gapPadding: 5))),
    );
  }
}

class SearchedUsers extends StatefulWidget {
  SearchedUsers({super.key, required this.user});
  UserModel user;
  @override
  State<SearchedUsers> createState() => _SearchedUsersState();
}

class _SearchedUsersState extends State<SearchedUsers> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
              child: TextButton(
            style:
                ButtonStyle(padding: MaterialStatePropertyAll(EdgeInsets.zero)),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessageView(user: widget.user),
                  ));
            },
            child: Row(children: [
              SizedBox(
                height: 60,
                child: CircleAvatar(
                    minRadius: 30,
                    backgroundImage: NetworkImage((widget.user.photo?.length ??
                                0) ==
                            0
                        ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlzWGeKBgGeQ_zA2_-P89bHLjOVxE0JQA0jQ&usqp=CAU"
                        : widget.user.photo ?? "")),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  widget.user.name ?? "",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      color: Color(0xff3e003e),
                      fontWeight: FontWeight.w700),
                ),
              ),
              Flexible(
                child: Text(
                  "@${widget.user.username}" ?? "",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Color.fromARGB(132, 62, 0, 62),
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ]),
          )),
          Divider(),
        ],
      ),
    );
  }
}
