import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_application_1/Register/registerComponents/textField.dart";
import "package:flutter_application_1/Resources/auth_methods.dart";
import "package:flutter_application_1/Usage/home.dart";
import "package:google_fonts/google_fonts.dart";

class signUp extends StatefulWidget {
  signUp({super.key});

  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _usernameController = TextEditingController();

  bool _isLoading = true;

  String response = "";

  void changeLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _usernameController.dispose();
  }

  Future<void> signupUser() async {
    changeLoading();
    response = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
        username: _usernameController.text);
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
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
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
                  icon: Icons.mail_outline_rounded,
                  controller: _emailController,
                ),
                _sizedBox(),
                textField(
                  str: "Kullanıcı Adı",
                  icon: Icons.account_circle_outlined,
                  controller: _usernameController,
                ),
                _sizedBox(),
                textField(
                  str: "İsim Soyisim",
                  icon: Icons.abc_outlined,
                  controller: _nameController,
                ),
                _sizedBox(),
                textField(
                  str: "Parola",
                  icon: Icons.lock_outline_rounded,
                  controller: _passwordController,
                ),
                _sizedBox(),
                ElevatedButton(
                  onPressed: signupUser,
                  style: ButtonStyle(
                      minimumSize: MaterialStatePropertyAll(Size(300, 20)),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)))),
                  child: _isLoading
                      ? Text("Kayıt ol")
                      : CircularProgressIndicator.adaptive(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Hesabın var mı?"),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/login");
                        },
                        child: Text("Giriş yap"))
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
      height: 26,
    );
  }
}
