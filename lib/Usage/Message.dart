import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Models/UserModel.dart';
import 'package:flutter_application_1/Resources/firestore_methods.dart';
import 'package:provider/provider.dart';

class MessageView extends StatefulWidget {
  MessageView({super.key, required this.user});
  UserModel user;
  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  TextEditingController _textController = TextEditingController();
  @override
  Future<void> sendMessage() async {
    await FireStoreMethods().sendMessage(FirebaseAuth.instance.currentUser!.uid,
        widget.user.userId!, _textController.text);
    setState(() {
      _textController.text = "";
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            children: [
              CircleAvatar(
                  backgroundImage: NetworkImage((widget.user.photo?.length ??
                              0) ==
                          0
                      ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlzWGeKBgGeQ_zA2_-P89bHLjOVxE0JQA0jQ&usqp=CAU"
                      : widget.user.photo ?? "")),
              SizedBox(
                width: 10,
              ),
              Text(
                widget.user.name!,
                style: TextStyle(color: Color(0xff3e003e)),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: Column(
              children: [fetchMessages(), messageField(context)],
            ),
          ),
        ));
  }

  Row messageField(BuildContext context) {
    return Row(
      children: [
        TextField(
          controller: _textController,
          decoration: InputDecoration(
            constraints: BoxConstraints(
                maxWidth: (MediaQuery.sizeOf(context).width - 68),
                minHeight: 30),
          ),
        ),
        IconButton(
            onPressed: sendMessage,
            icon: Icon(
              Icons.send_outlined,
              color: Color(0xff3e003e),
            ))
      ],
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> fetchMessages() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("messages")
            .doc(widget.user.userId)
            .collection("msgList")
            .orderBy("send_time")
            .snapshots(),
        builder: (context, messages) {
          if (messages.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          var _messages = messages.data?.docs.map((e) => e.data()).toList();
          return Expanded(
            flex: 9,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: userMessage(
                      user: widget.user, message: _messages?[index]),
                );
              },
              itemCount: _messages?.length ?? 0,
            ),
          );
        });
  }
}

class userMessage extends StatefulWidget {
  userMessage({super.key, required this.user, this.message});

  final UserModel user;
  Map<String, dynamic>? message;

  @override
  State<userMessage> createState() => _userMessageState();
}

class _userMessageState extends State<userMessage> {
  Alignment alignment = Alignment.topLeft;
  Color color = Color.fromARGB(255, 157, 118, 193);
  bool control = false;

  @override
  Widget build(BuildContext context) {
    if (widget.message?['user_id'] == FirebaseAuth.instance.currentUser!.uid) {
      setState(() {
        alignment = Alignment.topRight;
        color = Color.fromARGB(255, 113, 58, 190);
        control = true;
      });
    }
    return Row(
      children: [
        control
            ? Row(
                children: [
                  SizedBox(
                    width: (MediaQuery.sizeOf(context).width / 2),
                  ),
                  Container(
                    alignment: alignment,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: color,
                    ),
                    width: ((MediaQuery.sizeOf(context).width / 2) - 20),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.message?['text'].toString() ?? "",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              )
            : Container(
                alignment: alignment,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: color,
                ),
                width: ((MediaQuery.sizeOf(context).width / 2) - 20),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.message?['text'].toString() ?? "",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
      ],
    );
  }
}
