import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProjectTheme {
  final _themeColors = _ThemeColors();
  late ThemeData theme;
  ProjectTheme() {
    theme = ThemeData(
      //input
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.white)),
        outlineBorder: BorderSide(color: _themeColors.lightColor),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _themeColors.lightColor),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
        constraints: BoxConstraints(maxHeight: 30, maxWidth: 300),
        fillColor: Colors.black.withOpacity(0.08),
        filled: true,
        border: OutlineInputBorder(
            gapPadding: 5, borderRadius: BorderRadius.all(Radius.circular(10))),
      ),

      //main Theme
      primarySwatch: Colors.deepPurple,
      appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: _themeColors.mainColor),
          color: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.dark
              .copyWith(statusBarColor: Colors.transparent)),
      scaffoldBackgroundColor: _themeColors.lightColor,
      dividerColor: _themeColors.mainColor,
      navigationBarTheme: NavigationBarThemeData(),

      //icon
      iconTheme: IconThemeData(color: _themeColors.lightColor),

      drawerTheme: DrawerThemeData(),

      //text
      textTheme: TextTheme(),

      //button
      iconButtonTheme: IconButtonThemeData(style: ButtonStyle()),

      textButtonTheme: TextButtonThemeData(style: ButtonStyle()),

      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        elevation: 2.0,
        shape: BeveledRectangleBorder(),
        padding: EdgeInsets.all(10),
        backgroundColor: _themeColors.mainColor,
        textStyle: TextStyle(
            color: _themeColors.lightColor, height: 1.5, fontSize: 17),
      )),
    );
  }
}

class _ThemeColors {
  final Color mainColor = Color.fromARGB(255, 64, 0, 64);
  final Color lightColor = Colors.white.withOpacity(0.982);
}
