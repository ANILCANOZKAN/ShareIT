import 'package:flutter/material.dart';
import 'package:flutter_application_1/Database/Firebase.dart';
import 'package:flutter_application_1/FullScreen/ImageView.dart';
import 'package:flutter_application_1/Register/login.dart';
import 'package:flutter_application_1/Register/signup.dart';
import 'package:flutter_application_1/Theme/Theme.dart';
import 'package:flutter_application_1/Usage/DM.dart';
import 'package:flutter_application_1/Usage/Message.dart';
import 'package:flutter_application_1/Usage/Search.dart';
import 'package:flutter_application_1/Usage/home.dart';
import 'package:flutter_application_1/Usage/Account.dart';
import 'package:flutter_application_1/Usage/Trends.dart';
import 'package:flutter_application_1/testWidget.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ProjectTheme().theme,
      home: signUp(),
      routes: <String, WidgetBuilder>{
        //register
        '/login': (BuildContext context) => const login(),
        '/signup': (BuildContext context) => signUp(),

        '/search': (BuildContext context) => const Search(),
        '/home': (BuildContext context) => home(),
        '/account': (BuildContext context) => const Account(),
        '/dm': (BuildContext context) => const DM(),
        '/image': (BuildContext context) => const ImageView(),
        '/trends': (BuildContext context) => trendsView(),
        '/message': (BuildContext context) => const MessageView(),
      },
    );
  }
}
