import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/Register/registerComponents/textField.dart';
import 'package:flutter_application_1/Resources/auth_methods.dart';
import 'package:flutter_application_1/Usage/home.dart';
import 'package:google_fonts/google_fonts.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = true;
  String response = "";

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void changeLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  Future<void> loginUser() async {
    changeLoading();
    response = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (response == "success") {
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => home()), (route) => false);
      }
    }
    changeLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 0),
          child: AppBar(
            backgroundColor: Color(0xff3e003e),
            shadowColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle.light,
          )),
      backgroundColor: Color.fromARGB(243, 255, 255, 255),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                  color: Color(0xff3e003e),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(40))),
              child: Text("ShareIT",
                  style: GoogleFonts.pacifico(
                      fontSize: 50, color: Color.fromARGB(255, 255, 255, 255))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  response,
                  style: TextStyle(color: textField().errColor()),
                ),
                SizedBox(
                  height: 5,
                ),
                textField(
                  str: "E-mail",
                  controller: _emailController,
                  icon: Icons.email_outlined,
                ),
                _sizedBox(),
                textField(
                    str: "Parola",
                    icon: Icons.lock_outline_rounded,
                    controller: _passwordController),
                _sizedBox(),
                ElevatedButton(
                  onPressed: loginUser,
                  style: ButtonStyle(
                      minimumSize: MaterialStatePropertyAll(Size(300, 20)),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)))),
                  child: _isLoading
                      ? Text("Giriş yap")
                      : CircularProgressIndicator.adaptive(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Hesabın yok mu?"),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/signup");
                        },
                        child: Text("Kayıt ol"))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  SizedBox _sizedBox() {
    return SizedBox(
      height: 16,
    );
  }
}

class _texField extends StatelessWidget {
  const _texField({
    super.key,
    this.str,
    required this.controller,
  });

  final str;
  final controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 2, vertical: 3),
          child: Text(
            str,
            style: TextStyle(
                color: Color(0xff3e003e),
                fontSize: 17,
                fontWeight: FontWeight.w600),
          ),
        ),
        TextField(
          controller: controller,
          style: TextStyle(height: 1.5),
          decoration: InputDecoration(
              filled: false,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff3e003e))),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff3e003e))),
              hintText: str,
              constraints: BoxConstraints(maxHeight: 40)),
        ),
      ],
    );
  }
}
