



// Text Extraction & Document Scanning will take place with the help of Cistom ML Function deployed on the Cloud

import 'dart:async';
import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Ttext extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TextExt(),
      
    );
  }
}
class TextExt extends StatefulWidget {
  @override
  _TextExtState createState() => _TextExtState();
}

class _TextExtState extends State<TextExt> {
  ImageSource _imageSource;
  File _file; bool imageLoaded=false; String _extractedText="sdf";


  Future _getImage() async{
    var pickedImage = await ImagePicker.pickImage(source: _imageSource);
    setState(() {
     _file=pickedImage; 
     imageLoaded=true;
    });
  }

  Future _readText() async{
    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(_file);
    TextRecognizer textRecognizer =FirebaseVision.instance.textRecognizer();
    VisionText visionText = await textRecognizer.processImage(visionImage);
  for(TextBlock block in visionText.blocks){
    for(TextLine line in block.lines){
      _extractedText =line.text + _extractedText;
      print(line.text);
    }
    setState(() {
      
    });
  }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
              child: Column(
          children: <Widget>[
            SizedBox(height:40),
            Text("Pick Source :"),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  onPressed: (){
                    setState(() {
                     _imageSource=ImageSource.camera;
                    });
                    _getImage();
                  },
                  child: Text("CAMERA"),
                ),
                RaisedButton(
                  onPressed: (){
                    setState(() {
                     _imageSource=ImageSource.gallery;
                    });
                    _getImage();
                  },
                  child: Text("GALLERY"),
                ),
              ],
            ),
            SizedBox(height: 30,),
            imageLoaded ? Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(image: FileImage(_file,),fit: BoxFit.contain),
              ),
            ):Container(),
            SizedBox(height: 30,),
            RaisedButton(
              child: Text("Extract Text"),
              onPressed: (){
                _readText();
              },
            ),
            SizedBox(height: 30,),
            Container(
              margin: EdgeInsets.all(8),
              child: Text("$_extractedText")),
          ],
        ),
      )

    );
  }
}