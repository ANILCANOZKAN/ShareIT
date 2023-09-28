import 'package:flutter/material.dart';

class textField extends StatelessWidget {
  const textField({super.key, this.str, this.icon, this.controller});

  final str;
  final icon;
  final controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          style: TextStyle(height: 1.5),
          decoration: InputDecoration(
              filled: false,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff3e003e))),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff3e003e))),
              labelText: str,
              labelStyle: TextStyle(fontSize: 20),
              constraints: BoxConstraints(maxHeight: 40)),
        ),
      ],
    );
  }

  Color errColor() {
    return Color.fromARGB(255, 170, 32, 22);
  }
}
