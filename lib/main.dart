import 'dart:async';

import 'package:flutter/material.dart';
import 'option.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MySplashPage(),
    );
  }
}

class MySplashPage extends StatefulWidget {
  @override
  _MySplashPageState createState() => _MySplashPageState();
}

class _MySplashPageState extends State<MySplashPage> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3),()=>Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Optin()),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Container(
        color: Colors.black54,
        child: Center(
          child: FlutterLogo(colors: Colors.amber,size: 200,),
        ),
      ),
    );
  }
}
