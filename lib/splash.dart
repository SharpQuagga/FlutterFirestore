import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'main.dart';
import 'dart:async';
import 'package:flutter/animation.dart';


class Splash extends StatefulWidget {
  @override
  Animationss createState() => Animationss();

}

class Animationss extends State<Splash> with SingleTickerProviderStateMixin {

  Animation<double> animation;
  AnimationController controller;

  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(seconds: 2), vsync: this);
    animation = Tween(begin: -300.0, end: 0.0).animate(CurvedAnimation(
      curve: Curves.elasticInOut,parent: controller
    )) ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
      
    controller.forward();

    Timer(Duration(seconds: 5),()=>print("TIme up"));
  
  }


  Widget build(BuildContext context) {
    return MaterialApp(
          home: Scaffold(
            backgroundColor: Colors.blue,
        body: AnimatedBuilder(
          animation: controller,
          builder: (context, child) => Transform(
                transform:
                //Matrix4.rotationX(animation.value),
                    Matrix4.translationValues(animation.value , 0.0, 0.0),
                child:Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 60.0,
                        child: new Icon(
                          Icons.alarm,
                          size: 50.0,
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(10.0),),
                      Text(
                        "My Splash Screen",style: TextStyle(fontSize: 20.0,color: Colors.white,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                ),
             Builder(
                builder: (context)=>FlatButton(onPressed: () {
                Navigator.push(context, 
                new MaterialPageRoute(builder: (context) => MyApp()));
                },
              child: new Icon(
                 Icons.arrow_right
              ),
              ),
              )
              ],
            ),  
          ),
        ],
      ), 
     ),
   ),
  ),
 );
}
}
