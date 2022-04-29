import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:userproject/model/ConnectAPI.dart';
// import 'dart:convert' as convert;

class ProfileActivityFrom extends StatefulWidget {
  @override
  _ProfileActivityFromState createState() => _ProfileActivityFromState();
}

class _ProfileActivityFromState extends State<ProfileActivityFrom> {
  //Upload Images อัพโหลดรูปภาพ =====================
  //ตัวแปรเกี่ยวกับ อัพโหลดรูปภาพ
  // File _image;
  // File _camera;
  // String imgstatus = '';
  // String error = 'Error';
  var filename;
  var _urlUpload = '${Connectapi().domain}/uploadsprofileac';
  // ตัวแปรเกี่ยวกับ อัพโหลดรูปภาพ

  //multi_image_picker
  List<Asset> images = <Asset>[];
  Asset asset;
  String _error = 'No Error Dectected';

  @override
  void initState() {
    super.initState();
  }

  //สร้าง GridView
  Widget buildGridView() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 1,
          children: List.generate(images.length, (index) {
            // asset = images[index];
            return AssetThumb(
              asset: images[index],
              width: 300,
              height: 300,
            );
          }),
        ),
      ),
    );
  }

  //LoadAssets
  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      images = resultList;
      print('path : ${images.length}');
      _error = error;
    });
  }

//multi_image_picker
  Future<String> _multiUploadimage(ast) async {
// create multipart request
    MultipartRequest request =
        http.MultipartRequest("POST", Uri.parse(_urlUpload));
    ByteData byteData = await ast.getByteData();
    List<int> imageData = byteData.buffer.asUint8List();

    http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
      'picture', //key of the api
      imageData,
      filename: 'some-file-name.jpg',
      contentType: MediaType("image",
          "jpg"), //this is not nessessory variable. if this getting error, erase the line.
    );
// add file to multipart
    request.files.add(multipartFile);
// send
    var response = await request.send();
    return response.reasonPhrase;
  }

  //Loop รูปภาพ
  Future<void> _sendPathImage() async {
    print('path : ${images.length}');
    for (int i = 0; i < images.length; i++) {
      asset = images[i];
      print('image : $i');
      var res = _multiUploadimage(asset);
    }
  }

// add gallery
  Widget _addImg() {
    return SizedBox(
      width: 120,
      height: 40,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        onPressed: loadAssets,
        child: Text(
          'เลือกรูปภาพ',
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.greenAccent.shade700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Card(
                    color: Colors.grey.shade200,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Image.asset(
                        'assets/images/ShowAc.png',
                        // color: Theme.of(context).primaryColor,
                        width: 250,
                        height: 400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error,
                          size: 15,
                        ),
                        Text(
                            'เลือกรูปภาพเพื่อใช้เป็นภาพปกของกิจกรรมเหมือนตัวอย่างข้างบน'),
                      ],
                    ),
                  ),
                  _addImg(),
                  SizedBox(
                    height: 5,
                  ),
                  Container(width: 400, height: 250, child: buildGridView()),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      btnSubmit(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget btnSubmit() {
    return SizedBox(
      width: 120,
      height: 40,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Text(
          'สร้างกิจกรรม',
          style: TextStyle(color: Colors.white),
        ),
        color: Theme.of(context).primaryColorDark,
        onPressed: () {
          _sendPathImage();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SplashScreen()),
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = Duration(seconds: 3);
    return Timer(duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);

    _showber();
  }

  Widget _showber() {
    return Center(
      child: Flushbar(
        message: "สร้างกิจกรรมสำเร็จแล้ว",
        icon: Icon(
          Icons.done,
          size: 28.0,
          color: Colors.white,
        ),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        duration: Duration(seconds: 2),
        // leftBarIndicatorColor: Colors.blue[300],
        backgroundColor: Colors.greenAccent.shade700.withOpacity(0.8),
      )..show(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //       image: AssetImage('assets/images/BG2021.png'), fit: BoxFit.cover),
        //   // gradient: LinearGradient(
        //   //     colors: [Colors.white, Colors.white],
        //   //     begin: Alignment.topCenter,
        //   //     end: Alignment.center)
        // ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              CircleAvatar(
                radius: 120,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('assets/images/LoGo2.PNG'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 100, right: 100),
                child: Center(
                    child: LinearProgressIndicator(
                  backgroundColor: Colors.greenAccent.shade700,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                )),
              ),
              Text(
                'กำลังสร้างกิจกรรม...',
                style: TextStyle(fontSize: 18, color: Colors.black45),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
