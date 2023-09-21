import 'package:flutter/material.dart';
import 'package:flutter_application_1/Theme/Theme.dart';

class ImageView extends StatefulWidget {
  const ImageView({super.key});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  int _sharedImageLength = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                BackButton(context),
                _doComment(),
              ],
            ),
          ),
          Expanded(
              flex: 6,
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _sharedImageLength,
                itemBuilder: (context, index) {
                  return UserImage(context);
                },
              )),
          Expanded(
            flex: 2,
            child: ImageButton(),
          )
        ],
      ),
    );
  }

  Container _doComment() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const TextField(
              style: TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                  hintText: "Yorum yap",
                  hintStyle: TextStyle(color: Colors.white),
                  fillColor: Colors.black26,
                  filled: true,
                  constraints: BoxConstraints(maxWidth: 323, maxHeight: 30)),
            ),
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.send_outlined,
                color: ProjectTheme().theme.iconTheme.color,
              ))
        ],
      ),
    );
  }

  Padding BackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 25, 0, 0),
      child: Container(
          alignment: Alignment.topLeft,
          child: TextButton(
            child: Icon(
              Icons.chevron_left_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
    );
  }

  UserImage(context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Image.network(
            "https://cdn.gencraft.com/prod/user/cc51920e-de95-4192-b94a-d7112f255dff/8e0d7bfb-9544-4b12-9886-421edd977103/images/image1_0.jpg?Expires=1702284945&Signature=bMhdQWE3QijsodoO9DahLCXyZtgk7XhquvM4cKbhD9Ps~byHXiBujhPONNuq4MmZPloDGnqqsh8kkDFnJGSXk5Hlq4cjRC058~E-m9TPWCEg8~~0-G6iyzsM7-lbuEbReSqnGxGc9n2zqwXKS9PQ~qSH9Mmfqc9AqBLtJ-l9t23fXay9A5gEAcanvO3ZLsRS~5j2M53UabpRXE5HrNaWiiOc3PUl3nzWvh-IBwK-I51jXrHoDFqgV3EVuXBn9MRhxLlioHtDLNg-ItY0NvVJdFw6q6PlAR8a4I~9Pa9URD5Uhxj4Sa89TbWmftHq~IaxygIpbowEl3wrvBlMo8dDhw__&Key-Pair-Id=K3RDDB1TZ8BHT8"));
  }
}

class ImageButton extends StatefulWidget {
  const ImageButton({
    super.key,
  });

  @override
  State<ImageButton> createState() => _ImageButtonState();
}

class _ImageButtonState extends State<ImageButton> {
  bool _isLiked = false;
  bool _isShared = false;

  void changeLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  void changeShare() {
    setState(() {
      _isShared = !_isShared;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      child: Row(
        children: [
          IconButton(
              onPressed: changeLike,
              icon: Icon(
                _isLiked
                    ? Icons.favorite_rounded
                    : Icons.favorite_outline_outlined,
                color: Colors.white,
              )),
          IconButton(
              onPressed: changeShare,
              icon: Icon(
                _isShared ? Icons.done : Icons.share_outlined,
                color: Colors.white,
              ))
        ],
      ),
    );
  }
}
