import 'package:flutter/material.dart';
import 'profile.dart';
import 'BarCodeGenerate.dart';
import 'QRgenerate.dart';
import 'Barcode.dart';
import 'TextExtractor.dart';

class Optin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.black54
        )
      ),
      home: OptionPage(),
    );
  }
}

class OptionPage extends StatefulWidget {
  @override
  _OptionPageState createState() => _OptionPageState();
}

class _OptionPageState extends State<OptionPage> {

  Container _optionCntai(String t1,IconData ii,String imaa,Widget tt) {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
       backgroundBlendMode: BlendMode.darken,
       image: DecorationImage(image: AssetImage(imaa),fit: BoxFit.fill,colorFilter:new ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.black,
      ),
      alignment: Alignment.center,
      child: FlatButton(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(ii,size: 20,color: Colors.white,),
              Text(
        "$t1",
        style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ],
          ), onPressed: () {
             Navigator.push(context, MaterialPageRoute(builder: (context)=>tt));
          },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          new SliverAppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            expandedHeight: 150.0,
            floating: false,
            pinned: true,
            flexibleSpace: new FlexibleSpaceBar(
              background: DecoratedBox(decoration: BoxDecoration(
                gradient: LinearGradient(
                   begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft,
                          colors: [
                            Color(0x00000000).withOpacity(0.9),
                            Color(0xff000000).withOpacity(0.01),
                          ],
                )
              ),),
              title: Row(
                children: <Widget>[
                  FlutterLogo(colors: Colors.amber,size: 20,),
                  SizedBox(width: 10,),
                  Text(
                    "Bizz Code",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          new SliverGrid.count(
            crossAxisCount: 2,
            //childAspectRatio: 1.0,
            // crossAxisSpacing: 10.0,
            // mainAxisSpacing: 10.0,
            children: <Widget>[
              _optionCntai("Code Scanner",Icons.bluetooth_searching,"assets/images/payment.jpg",Bbar()),
              _optionCntai("Document Scan",Icons.gesture,"assets/images/timeline.jpeg",Proffile()),                           
              _optionCntai("Bar Code Generator",Icons.question_answer,"assets/images/dashboard.jpg",BarCodeGenerate()),              
              _optionCntai("Qr code Generator",Icons.bluetooth_searching,"assets/images/payment.jpg",GenerateScreen()),
              _optionCntai("Text Extractor",Icons.question_answer,"assets/images/blank.jpg",Ttext()),              
              _optionCntai("Bill Generator",Icons.question_answer,"assets/images/login.jpg",Proffile()),
              _optionCntai("Profile",Icons.verified_user,"assets/images/profile.jpg",Proffile()),
            ],
          )
        ],
      ),
    );
  }
}
