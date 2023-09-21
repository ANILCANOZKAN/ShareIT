import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessageView extends StatefulWidget {
  const MessageView({super.key});

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
            alignment: Alignment.centerRight,
            child: Text(
              "Mesajlaşılan kullanıcı adı",
              style: TextStyle(color: Color(0xff3e003e)),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
          child: Column(
            children: [
              Container(
                child: Row(children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://img.freepik.com/free-psd/3d-illustration-human-avatar-profile_23-2150671165.jpg?w=740&t=st=1693987133~exp=1693987733~hmac=d59c6628bca34f4556bfd7e10a557a70472e2a57b441bcc34ce238c58070f8b1"),
                  ),
                  Card(child: Text("es in 953ms (compile: 21 ms, reload: 34"))
                ]),
              )
            ],
          ),
        ));
  }
}
