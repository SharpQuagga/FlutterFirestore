import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';


class BarCodeGenerate extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => BarCodeGenerateState();
}

class BarCodeGenerateState extends State<BarCodeGenerate> {

  static const double _topSectionTopPadding = 50.0;
  static const double _topSectionBottomPadding = 20.0;
  static const double _topSectionHeight = 50.0;

   String _dataString = "1234567898765";
  String _inputErrorText;
  final TextEditingController _textController =  TextEditingController();
  int _grpValue;
  GlobalKey globalKey = new GlobalKey();

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bar Code Generator'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share), 
            onPressed:  _captureAndSharePng,
          )
        ],
      ),
      body: _contentWidget(),
    );
  }


  String filename;  var downloadUrl,file;
  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getApplicationDocumentsDirectory();
      DateTime now = DateTime.now();
      print("$now");
      file = await new File('${tempDir.path}/$now.png').create();
      await file.writeAsBytes(pngBytes);
      filename = file.path;
      print(file);

      upload();
      // final channel = const MethodChannel('channel:me.alfian.share/share');
      // channel.invokeMethod('shareFile', 'image.png');
     } catch(e) {
      print(e.toString());
    }
  }

  Future<String> upload() async  {
    try {
       final StorageReference reference = FirebaseStorage.instance.ref().child(filename);
      final StorageUploadTask uploadTask = reference.putFile(file);

    downloadUrl= await(await uploadTask.onComplete).ref.getDownloadURL();
    print("Download $downloadUrl");
    Fluttertoast.showToast(msg: "Image Uploaded",textColor: Colors.red,toastLength: Toast.LENGTH_LONG,backgroundColor: Colors.white);   
    } catch (e) {
      print(e);
    }
   return downloadUrl;
   } 



  _contentWidget() {
    final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    return  Container(
      color: const Color(0xFFFFFFFF),
      child:  Column(
        children: <Widget>[
         SizedBox(height: 30,),
         Row(
           mainAxisSize: MainAxisSize.max,
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: <Widget>[
             Container(
               width: 190,
               child: TextFormField(
                 autofocus: true,
                 controller: _textController,
                 decoration: InputDecoration(
                   fillColor: Colors.black,
                   labelText: "Enter Some Value"
                 ),
               ),
             ),
             FlatButton(
               child: Text("SUBMIT"),
                onPressed: () {
                  setState(() {
                    if(_textController.text.length==13){
                   _dataString=_textController.text;                       
                    }else{
                    Fluttertoast.showToast(
                        msg: "Input shuold be numeric and should have length of 13 bits",
                        textColor: Colors.red,
                        backgroundColor: Colors.white,
                      );
                    }
                  });
                },
             )
           ],
         ),
         SizedBox(height: 40,),
          Expanded(
            //height: 70,
            child:  Center(
                  child: RepaintBoundary(
                   key: globalKey,
                 child: new BarCodeImage(
                      data: _dataString,              // Code string. (required)
                      codeType: BarCodeType.CodeUPCA,  // Code type (required)
                      lineWidth: 2.0,                // width for a single black/white bar (default: 2.0)
                      barHeight: 90.0,               // height for the entire widget (default: 100.0)
                      hasText: true,                 // Render with text label or not (default: false)
                      onError: (error) {    
                        Fluttertoast.showToast(
                          msg: "$error"+"Invalid Input",
                          toastLength: Toast.LENGTH_SHORT,
                          timeInSecForIos: 3,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white
                        );         // E,rror handler
                        print('error = $error');
                      },
                    )
              ),
            ),
          ),
        ],
      ),
    );
  }

  

}
