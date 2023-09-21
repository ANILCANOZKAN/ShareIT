import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/Sharing.dart';

class DM extends StatefulWidget {
  const DM({super.key});

  @override
  State<DM> createState() => _DMState();
}

class _DMState extends State<DM> {
  @override
  final _title = "Kullanıcı Adı";
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: appBarTitle(_title),
          actions: [
            getIconButton(
              selectedIcon: Icons.add,
              selectedSize: 30,
            ),
          ],
        ),
        body: Column(children: [
          SearchField(),
          Expanded(
              flex: 9,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return SearchedUsers();
                },
                itemCount: 10,
              )),
          Expanded(flex: 1, child: Footer()),
        ]));
  }
}

Text appBarTitle(String _title) {
  return Text(
    _title,
    style: const TextStyle(color: Color(0xff3e003e), fontSize: 25),
  );
}

class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: TextField(
          cursorHeight: 15,
          style: TextStyle(height: 1),
          decoration: InputDecoration(
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
  const SearchedUsers({super.key});

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
            onPressed: () {
              Navigator.pushNamed(context, "/message");
            },
            child: Row(children: [
              FloatingActionButton(
                  backgroundColor: Colors.transparent,
                  shape: CircleBorder(),
                  onPressed: () {},
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        "https://img.freepik.com/free-psd/3d-illustration-human-avatar-profile_23-2150671165.jpg?w=740&t=st=1693987133~exp=1693987733~hmac=d59c6628bca34f4556bfd7e10a557a70472e2a57b441bcc34ce238c58070f8b1"),
                  )),
              SizedBox(
                width: 30,
              ),
              Text(
                "Kullanıcı adı",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Color(0xff3e003e), fontWeight: FontWeight.w700),
              ),
              Container(
                  padding: EdgeInsets.only(left: 160),
                  alignment: Alignment.centerRight,
                  child: getIconButton(
                    selectedIcon: Icons.add_a_photo_outlined,
                    selectedSize: 25,
                  ))
            ]),
          )),
          Divider(),
        ],
      ),
    );
  }
}
