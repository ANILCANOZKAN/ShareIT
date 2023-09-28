import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/PostModel.dart';
import 'package:flutter_application_1/Models/UserModel.dart';
import 'package:flutter_application_1/Register/registerComponents/textField.dart';
import 'package:flutter_application_1/Resources/firestore_methods.dart';
import 'package:flutter_application_1/Utils/utils.dart';
import 'package:flutter_application_1/layout/layout.dart';
import 'package:flutter_application_1/sharedPostCard.dart';
import 'package:image_picker/image_picker.dart';

class addPost extends StatefulWidget {
  addPost({super.key, required this.currentUserId, this.sharedPost});

  String currentUserId;
  PostModel? sharedPost;
  @override
  State<addPost> createState() => _addPostState();
}

// ignore: camel_case_types
class _addPostState extends State<addPost> {
  UserModel? _user;
  bool isLoading = true;
  bool isPosting = true;
  String response = "";
  List<Uint8List?> _images = [];
  final TextEditingController textController = TextEditingController();

  void initState() {
    super.initState();
    getUser(widget.currentUserId);
  }

  void dispose() {
    super.dispose();
    textController.dispose();
  }

  void changePosting() {
    setState(() {
      isPosting = !isPosting;
    });
  }

  void changeLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  Future<void> getUser(user_id) async {
    changeLoading();
    var user =
        await FirebaseFirestore.instance.collection("users").doc(user_id).get();

    if (user.data() != null) {
      setState(() {
        _user = UserModel.fromJson(user.data() as Map<String, dynamic>);
      });
    }
    changeLoading();
  }

  Future<void> postContent() async {
    changePosting();
    response = await FireStoreMethods().uploadPost(textController.text,
        _user?.userId ?? "", widget.sharedPost?.post_Id, _images);

    if (response == 'success') {
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => layout()),
            (route) => false);
      }
    }
    changePosting();
  }

  Future<void> selectImage() async {
    var selectedImages = await pickMultipleImage();
    setState(() {
      _images = selectedImages;
    });
  }

  @override
  Widget build(BuildContext context) {
    double imageSize = 60;
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            isLoading
                ? userInfoSection(imageSize)
                : const LinearProgressIndicator(),
            Text(
              response,
              style: TextStyle(color: const textField().errColor()),
            ),
            addPostTextField(
                textController, (widget.sharedPost != null ? true : false)),
            (widget.sharedPost != null ?? false)
                ? Stack(
                    children: [
                      sharedPostCard(sharedPost: widget.sharedPost),
                      Positioned(
                          left: MediaQuery.sizeOf(context).width - 90,
                          child: IconButton(
                            icon: Icon(Icons.close_rounded),
                            color: Color(0xff3e003e),
                            onPressed: () {
                              setState(() {
                                widget.sharedPost = null;
                              });
                            },
                          ))
                    ],
                  )
                : _images.isEmpty
                    ? SizedBox()
                    : SizedBox(
                        height: 200,
                        child: Center(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return uploadedImages(_images[index], index);
                            },
                            itemCount: _images.length,
                          ),
                        ),
                      ),
            const SizedBox(
              height: 10,
            ),
            sendButton(context)
          ],
        ),
      ),
    ));
  }

  Row userInfoSection(double imageSize) {
    return Row(
      children: [
        SizedBox(
          width: imageSize,
          height: imageSize,
          child: CircleAvatar(
              backgroundImage: NetworkImage((_user?.photo?.isEmpty ?? false)
                  ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlzWGeKBgGeQ_zA2_-P89bHLjOVxE0JQA0jQ&usqp=CAU"
                  : _user?.photo ?? "")),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: postText(_user?.name),
        ),
        postText(_user?.username, sub: true)
      ],
    );
  }

  ElevatedButton sendButton(BuildContext context) {
    return ElevatedButton(
        onPressed: postContent,
        style: ButtonStyle(
            minimumSize: MaterialStatePropertyAll(
                Size(MediaQuery.sizeOf(context).width, 20)),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)))),
        child:
            isPosting ? Text("Gönder") : CircularProgressIndicator.adaptive());
  }

  Stack addPostTextField(controller, isPostShared) {
    return Stack(children: [
      TextField(
        controller: controller,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10),
            constraints:
                BoxConstraints(minWidth: MediaQuery.of(context).size.width),
            fillColor: Colors.transparent,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff3e003e), width: 3),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.transparent, width: 3)),
            hintStyle: const TextStyle(
                fontSize: 17, color: Color.fromARGB(123, 62, 0, 62)),
            hintText: "Düşüncelerini  paylaş"),
        maxLines: 8,
      ),
      isPostShared
          ? SizedBox()
          : Positioned(
              left: MediaQuery.sizeOf(context).width - 90,
              top: 125,
              child: IconButton(
                  color: const Color.fromARGB(131, 62, 0, 62),
                  icon: const Icon(Icons.add_a_photo_outlined),
                  onPressed: () {
                    selectImage();
                  }))
    ]);
  }

  Stack uploadedImages(_image, index) {
    return Stack(
      children: [
        Card(
            margin: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Image(
                image: MemoryImage(_image!),
              ),
            )),
        Positioned(
            left: 22,
            top: 155,
            child: IconButton(
                onPressed: () {
                  setState(() {
                    _images.removeAt(index);
                  });
                },
                icon: Icon(
                  Icons.close_rounded,
                  color: Color(0xff3e003e),
                  size: 20,
                )))
      ],
    );
  }

  Text postText(text, {bool sub = false}) {
    return Text(
      // ignore: prefer_interpolation_to_compose_strings
      sub ? "@" + text : text,
      style: TextStyle(
          color: sub
              ? const Color.fromARGB(123, 62, 0, 62)
              : const Color(0xff3e003e),
          fontSize: 17,
          fontWeight: FontWeight.w500),
    );
  }
}

class addPostTextField extends StatelessWidget {
  addPostTextField({
    super.key,
    required this.controller,
    required this.isPostShared,
  });
  TextEditingController controller;
  bool isPostShared;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      TextField(
        controller: controller,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10),
            constraints:
                BoxConstraints(minWidth: MediaQuery.of(context).size.width),
            fillColor: Colors.transparent,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff3e003e), width: 3),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.transparent, width: 3)),
            hintStyle: const TextStyle(
                fontSize: 17, color: Color.fromARGB(123, 62, 0, 62)),
            hintText: "Düşüncelerini  paylaş"),
        maxLines: 8,
      ),
      isPostShared
          ? SizedBox()
          : Positioned(
              left: MediaQuery.sizeOf(context).width - 90,
              top: 125,
              child: IconButton(
                  color: const Color.fromARGB(131, 62, 0, 62),
                  icon: const Icon(Icons.add_a_photo_outlined),
                  onPressed: () {
                    _addPostState().selectImage();
                  }))
    ]);
  }
}
