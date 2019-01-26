import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/animation.dart';
import 'LoggedIn.dart';
import 'splash.dart';

void main() => runApp(Splash());


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}



class _MyAppState extends State<MyApp> with TickerProviderStateMixin{
  
  AnimationController controller;
  Animation<double> animation;      String id;

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

  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;


  Future<FirebaseUser> _sighIn() async{
    FirebaseUser user = await _auth.createUserWithEmailAndPassword(
      email: emailController.text ,password:passController.text  );
     id = user.uid;
      _toast("User Registered with uid $id");
      _firestore();
    print("User Name: ${user.displayName} ");
    return user;
  }

   final DocumentReference documentReference = Firestore.instance.document("Data/Login");


  void _firestore(){
    Firestore.instance.collection('login').document(id)
  .setData({ 'Name': nameController.text , 'Email': emailController.text,'photoUrl':'abc' });
    _toast("User added in firestore");
    nxtScreen();
  }


   @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: new ThemeData(
        accentColorBrightness: Brightness.light,
        accentColor: Colors.deepPurpleAccent,
        brightness: Brightness.dark,
      ),
      home: new Scaffold(   
        backgroundColor: Colors.blue[200],
        body: Container(
              child:new Center(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
               child: Image(image: new AssetImage("assets/back.jpg"),
              colorBlendMode: BlendMode.darken,
              fit: BoxFit.fitWidth,
              color: Colors.black38,
              ),
              ),
              Container(
                child: AnimatedBuilder(
                  animation: controller,
            builder: (context,child)=>Transform(
              transform: Matrix4.translationValues(0.0, animation.value, 0.0),
                  child: SingleChildScrollView(
                          child: new Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(110,50,10,0),
                        child: Text("Login Page",style: TextStyle(color: Colors.purple,fontSize: 30.0,fontWeight: FontWeight.bold,decoration: TextDecoration.underline,decorationStyle: TextDecorationStyle.dashed),),
                      ),
                      Padding(
                         child:  new FlutterLogo(
                         size: 100.0,
                     ), padding: EdgeInsets.only(top: 60.0),
                     ),
                      Padding(
                         padding: EdgeInsets.fromLTRB(30, 10, 30,0),
                        child:Form(
                        child: new Column(
                          children: <Widget>[
                            new TextFormField(
                              decoration: new InputDecoration(labelText: "Name"),
                               keyboardType: TextInputType.text,
                               controller: nameController,
                             ),
                            new TextFormField(
                              decoration: new InputDecoration(labelText: "Email"),
                               keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                             ),
                            TextFormField(
                              decoration: new InputDecoration(labelText: "Password"),
                              obscureText: true,
                              controller: passController,
                            ),
                          ],
                        )
                      ),
                      ),
                      Padding(
                      padding: EdgeInsets.all(25.0),
                      child: Builder(
                        builder: (context)=>RaisedButton(onPressed: () {
                        _sighIn().then((FirebaseUser user)=>print(user)).catchError((e)=>_toast(e));
                        Navigator.push(context, 
                        new MaterialPageRoute(builder: (context) => Logged(name: nameController.text,id: id,)));
                        },
                      child: new Icon(
                    Icons.arrow_right
                      ),
                      // shape: StadiumBorder(
                      //   side: BorderSide(color: Colors.yellow,width: 2)
                      // ),
                      // shape: UnderlineInputBorder(
                      //   borderRadius: BorderRadius.circular(30),
                      //   borderSide: BorderSide(color: Colors.yellow,width: 7,style: BorderStyle.solid),
                      // ),
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(20)
                      // ),
                      shape: BeveledRectangleBorder(
                        side: BorderSide(color: Colors.yellow,width: 2),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      elevation: 30,
                      highlightColor: Colors.indigo,
                      ),
             )
             ),
                      ],
                      ),
                  ),
            ),
                ),
              )
          ],
          )
            ) ,
        )
        ),
    );
  }


  void nxtScreen(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Logged()),
    );
  }

}


void _toast(str){
  Fluttertoast.showToast(
        msg: str,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.lightBlueAccent,
        textColor: Colors.white
  );
}

