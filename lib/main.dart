import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Provider/UserProvider.dart';
import 'package:flutter_application_1/Register/login.dart';
import 'package:flutter_application_1/Register/signup.dart';
import 'package:flutter_application_1/Theme/Theme.dart';
import 'package:flutter_application_1/Usage/DM.dart';
import 'package:flutter_application_1/Usage/Notifications.dart';
import 'package:flutter_application_1/layout/layout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

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
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ProjectTheme().theme,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return layout();
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            return login();
          },
        ),
        routes: {
          "/signup": (context) => signUp(),
          "/login": (context) => login(),
          "/dm": (context) => DM(),
          "/notifications": (context) => NotificationsView(),
        },
      ),
    );
  }
}
