import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/timeFormat.dart';
import 'package:flutter_application_1/Models/PostModel.dart';
import 'package:flutter_application_1/Models/UserModel.dart';
import 'package:flutter_application_1/Theme/Theme.dart';

class sharedPostCard extends StatelessWidget {
  sharedPostCard({super.key, this.sharedPost});
  PostModel? sharedPost;
  @override
  Widget build(BuildContext context) {
    List created = timeFormat().timeFormatter(sharedPost?.created_at ?? 0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.zero,
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
              child: Column(
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(sharedPost?.userId)
                          .snapshots(),
                      builder: (context, user) {
                        if (user.connectionState == ConnectionState.waiting) {
                          return LinearProgressIndicator();
                        }
                        UserModel _user =
                            UserModel.fromJson(user.data!.data()!);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 30,
                                child: CircleAvatar(
                                    minRadius: 15,
                                    backgroundImage: NetworkImage((_user
                                                    .photo?.length ??
                                                0) ==
                                            0
                                        ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlzWGeKBgGeQ_zA2_-P89bHLjOVxE0JQA0jQ&usqp=CAU"
                                        : _user.photo ?? "")),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text(
                                _user.name ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Color(0XFF3e003e),
                                      fontSize: 14,
                                    ),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text(
                                "@${_user.username ?? ""}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Color.fromARGB(119, 62, 0, 62),
                                      fontSize: 12,
                                    ),
                              ),
                              timeText(created[1], created[0], context),
                            ],
                          ),
                        );
                      }),
                  Text(
                    sharedPost?.body ?? "",
                    style: ProjectTheme()
                        .theme
                        .textTheme
                        .bodyLarge
                        ?.copyWith(height: 1.5, fontSize: 12),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
            (sharedPost?.media?.imageUrl?.isEmpty ?? true)
                ? SizedBox()
                : SizedBox(
                    child: Card(
                      child: ClipRRect(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(15)),
                          child: Image.network(sharedPost?.media?.imageUrl?[0],
                              errorBuilder: (context, error, stackTrace) =>
                                  imageError())),
                      margin: EdgeInsets.zero,
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget imageError() {
    return Container(
      color: Colors.black,
      child: SizedBox(
        height: 100,
        child: Center(
            child: Text(
          "Resim bulunamadı",
          style: TextStyle(color: Colors.white),
        )),
      ),
    );
  }

  Text timeText(created, d, BuildContext context) {
    return Text(" - " + (created.toString()) + d,
        style: TextStyle(
          color: Color.fromARGB(119, 62, 0, 62),
          fontSize: 12,
        ));
  }
}
