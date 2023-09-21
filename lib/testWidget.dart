import 'package:flutter/material.dart';

class testWidget extends StatefulWidget {
  const testWidget({super.key});

  @override
  State<testWidget> createState() => _testState();
}

class _testState extends State<testWidget> {
  DateTime today = DateTime.now();
  @override
  Widget build(BuildContext context) {
    DateTime _firstDayOfTheweek = today.subtract(Duration(days: 30));
    return Scaffold(
        appBar: AppBar(
          title: const Text('Algolia & Flutter'),
        ),
        body: Center(
            child: Column(children: <Widget>[
          SizedBox(
            height: 44,
            child: Text(_firstDayOfTheweek.toString()),
          ),
        ])));
  }
}
