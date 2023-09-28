import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Components/projectTitle.dart';
import 'package:flutter_application_1/Models/UserModel.dart';
import 'package:flutter_application_1/Register/registerComponents/textField.dart';
import 'package:flutter_application_1/Resources/auth_methods.dart';
import 'package:flutter_application_1/Utils/utils.dart';
import 'package:flutter_application_1/layout/layout.dart';
import 'package:image_picker/image_picker.dart';

class editAccount extends StatefulWidget {
  const editAccount({super.key});

  @override
  State<editAccount> createState() => _editAccountState();
}

class _editAccountState extends State<editAccount> {
  UserModel? _user;
  bool isLoading = true;
  bool isUpdated = true;
  String response = "";
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _bioController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;

  void initState() {
    super.initState();
    getUser();
  }

  void dispose() {
    _bioController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  getUser() async {
    setState(() {
      isLoading = false;
    });
    var userSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    if (userSnap.data() != null) {
      _user = UserModel.fromJson(userSnap.data() as Map<String, dynamic>);
      _emailController.text = _user?.email ?? "";
      _nameController.text = _user?.name ?? "";
      _usernameController.text = _user?.username ?? "";
      _bioController.text = _user?.bio ?? "";
    }
    setState(() {
      isLoading = true;
    });
  }

  Future<void> selectImage() async {
    var selectedImage = await pickImage(ImageSource.gallery);
    setState(() {
      _image = selectedImage;
    });
  }

  Future<void> updateUser() async {
    setState(() {
      isUpdated = false;
    });
    response = await AuthMethods().updateUser(
        _emailController.text,
        _usernameController.text,
        _nameController.text,
        _bioController.text,
        _image,
        _user?.userId ?? "");
    if (response == "Güncelleme Başarılı") {
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => layout(
                    page: 4,
                  )),
          (route) => false,
        );
      }
    }
    setState(() {
      isUpdated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: projectTitle().appBarTitleWithSize("Profilini yönet", 30),
      ),
      body: Padding(
          padding: EdgeInsets.all(10),
          child: isLoading
              ? ListView(children: [
                  Column(
                    children: [
                      Stack(
                        children: [
                          Center(
                            child: SizedBox(
                              width: 100,
                              child: (_image != null)
                                  ? CircleAvatar(
                                      minRadius: 50,
                                      backgroundImage: MemoryImage(_image!))
                                  : CircleAvatar(
                                      minRadius: 50,
                                      backgroundImage: NetworkImage((_user
                                                  ?.photo?.isEmpty ??
                                              true)
                                          ? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlzWGeKBgGeQ_zA2_-P89bHLjOVxE0JQA0jQ&usqp=CAU"
                                          : _user?.photo ?? ""),
                                    ),
                            ),
                          ),
                          Positioned(
                            left: 200,
                            top: 60,
                            child: IconButton(
                                onPressed: selectImage,
                                icon: Icon(
                                  Icons.add_a_photo_outlined,
                                  color: Color.fromARGB(255, 233, 233, 233),
                                  size: 30,
                                )),
                          )
                        ],
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                response,
                                style: TextStyle(color: textField().errColor()),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            editAccountTextField(
                                controller: _emailController, text: "E-mail"),
                            _sizedBox(),
                            editAccountTextField(
                                controller: _usernameController,
                                text: "Kullanıcı adı"),
                            _sizedBox(),
                            editAccountTextField(
                                controller: _nameController,
                                text: "İsim Soyisim"),
                            _sizedBox(),
                            editAccountTextField(
                                controller: _bioController, text: "Biyografi"),
                            _sizedBox(),
                            ElevatedButton(
                              onPressed: updateUser,
                              style: ButtonStyle(
                                  minimumSize:
                                      MaterialStatePropertyAll(Size(300, 20)),
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)))),
                              child: isUpdated
                                  ? Text("Güncelle")
                                  : CircularProgressIndicator(
                                      color: Colors.white),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ])
              : Center(
                  child: CircularProgressIndicator.adaptive(),
                )),
    );
  }

  SizedBox _sizedBox() {
    return SizedBox(
      height: 26,
    );
  }
}

class editAccountTextField extends StatelessWidget {
  editAccountTextField({
    super.key,
    required this.controller,
    required this.text,
  });
  TextEditingController controller;
  String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        TextField(
            controller: controller,
            decoration: const InputDecoration(
              constraints: BoxConstraints(maxHeight: 60, maxWidth: 250),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    style: BorderStyle.solid,
                    color: Color.fromARGB(123, 62, 0, 62)),
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(123, 62, 0, 62))),
              fillColor: Colors.transparent,
            )),
      ],
    );
  }
}
