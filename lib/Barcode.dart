import 'dart:async';
import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Bbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BarCode(),
      
    );
  }
}
class BarCode extends StatefulWidget {
  @override
  _BarCodeState createState() => _BarCodeState();
}

class _BarCodeState extends State<BarCode> {
  ImageSource _imageSource;
  File _file; bool imageLoaded=false; String _extractedBarCode;

  Future _getImage() async{
    var pickedImage = await ImagePicker.pickImage(source: _imageSource);
    setState(() {
     _file=pickedImage; 
     imageLoaded=true;
    });
  }

  Future _readText() async{
    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(_file);
    BarcodeDetector barcodeDetector =FirebaseVision.instance.barcodeDetector( );
    final List<Barcode> barcodes = await barcodeDetector.detectInImage(visionImage);

    for (Barcode barcode in barcodes) {

  final String rawValue = barcode.rawValue;
  final BarcodeValueType valueType = barcode.valueType;
  setState(() {
   _extractedBarCode =rawValue; 
  });
}

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        children: <Widget>[
          SizedBox(height:40),
          Text("Pick Sourece :"),
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
            child: Text("Extract BarCode Info"),
            onPressed: (){
              _readText();
            },
          ),
          SizedBox(height: 30,),
          Text("$_extractedBarCode"),
        ],
      )

    );
  }
}