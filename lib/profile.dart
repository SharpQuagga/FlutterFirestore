import 'package:flutter/material.dart';

class Proffile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Pprofile() ,
    );
  }
}

class Pprofile extends StatefulWidget {
  @override
  _PprofileState createState() => _PprofileState();
}

class _PprofileState extends State<Pprofile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Prfile PAge"),
      ),
    );
  }
}