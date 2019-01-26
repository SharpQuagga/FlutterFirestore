import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';


class Logged extends StatefulWidget {
  @override
  _LoggedState createState() => _LoggedState();

  final String name,id;
  Logged({Key key , this.name , this.id}) : super(key: key); 
}


class _LoggedState extends State<Logged> with TickerProviderStateMixin{
  
  File sampleImage;
  String filename;
  var downloadUrl,tempImage;

   AnimationController controller;
  Animation<double> animation;

  Future getImage() async{

     tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
         //sampleImage=tempImage;
         filename = tempImage.path;
          print("filename:$filename");
         // sampleImage=tempImage;
          print("filename:$sampleImage");
        });
    upload();
  }
  
 Future<String> upload() async  {
    final StorageReference reference = FirebaseStorage.instance.ref().child(filename);
    final StorageUploadTask uploadTask = reference.putFile(tempImage);

    downloadUrl= await(await uploadTask.onComplete).ref.getDownloadURL();
    print("Download $downloadUrl");

    Firestore.instance.collection('login').document("$widget.id")
  .updateData({ 'photoUrl':downloadUrl });
  print("Data passsssed");

    setState(() {
              });

   return downloadUrl;
   } 


  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(seconds: 2), vsync: this);
    animation = Tween(begin: -900.0, end: 0.0).animate(CurvedAnimation(
      parent: controller,curve: Curves.bounceInOut
    )) ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
      
    controller.forward();  
}

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(
        buttonColor: Colors.blueGrey,
        accentColor: Colors.white70,
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        body: Stack(
                  children:<Widget>[
                    Container(
               child: Image(image: new AssetImage("assets/back.jpg"),
              colorBlendMode: BlendMode.darken,
              fit: BoxFit.fitWidth,
              color: Colors.black38,
              ),
              ),
              Container(
                child:AnimatedBuilder(
                   animation: controller,
            builder: (context,child)=>Transform(
              transform: Matrix4.translationValues(0.0, -animation.value, 0.0),
                  child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
           //crossAxisAlignment: CrossAxisAlignment.baseline,
            children: <Widget>[
              Padding(
               padding: EdgeInsets.fromLTRB(110,50,10,0),
                  child: Text("Hello ${widget.name}",style: TextStyle(color: Colors.purple,fontSize: 30.0,fontWeight: FontWeight.bold,decoration: TextDecoration.underline,decorationStyle: TextDecorationStyle.dashed),),
                  ),
              Padding(
                  padding: EdgeInsets.fromLTRB(110.0,60,0,0),
                  child:CircleAvatar(
                  radius: 70.0,
                  backgroundColor: Colors.teal,
                  backgroundImage: downloadUrl == null ? AssetImage("assets/fush.jpg") : NetworkImage(downloadUrl),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(90,90,0,0),
                    child: CircleAvatar(
                    radius: 20.0,
                   child: FlatButton(onPressed: () {
                     getImage();
                    
                   }, child: new Icon(
                     Icons.add_a_photo
                   ),
                   )
                  ),
                  )
              ) ,
              ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(90,30,0,0),
                    child: Text("User Profile Photo",style: TextStyle(color: Colors.redAccent ,fontSize: 20.0,fontWeight: FontWeight.bold),),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(90,180,0,0),
                    child: Builder(
                      builder: (context)=>
                        RaisedButton(
                      child: Text("Log Out"),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.push(context, 
                new MaterialPageRoute(builder: (context) => MyApp()));
                        },
                  ),
                    ),
                  ),
            ],
          ),
            ),
                ) ,
              )
                  ],
        ),
       ),
    );
  }

}




 // SnackBar , it will run only after onPressed() 
        //  Scaffold.of(context).showSnackBar(
        //                new SnackBar(
        //                  content: Text("photo Uploaded"),
        //                  duration: new Duration(seconds: 3),
        //                )
        //              );