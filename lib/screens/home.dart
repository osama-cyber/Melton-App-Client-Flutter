import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
//    return Container();
    return Scaffold(
      body: Column(
        children: [
          Text("HOME"),
          Image.asset("assets/UN_SDG/sdg_1.png"),
        ],
      ),
    );
  }
}
