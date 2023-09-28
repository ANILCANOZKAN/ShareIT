import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/PostModel.dart';
import 'package:flutter_application_1/Provider/UserProvider.dart';
import 'package:flutter_application_1/layout/drawLayout.dart';
import 'package:provider/provider.dart';

class layout extends StatefulWidget {
  layout({Key? key, this.page, this.sharedPost}) : super(key: key);
  int? page;
  PostModel? sharedPost;
  @override
  State<layout> createState() => _layout();
}

class _layout extends State<layout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return drawLayout(page: widget.page ?? 0, sharedPost: widget.sharedPost);
  }
}
