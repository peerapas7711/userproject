import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userproject/model/ConnectAPI.dart';
import 'package:userproject/user/ShowDataUser.dart';

class UploadImgUsert extends StatefulWidget {
  // UploadImgUsert({Key? key}) : super(key: key);

  @override
  _UploadImgUsertState createState() => _UploadImgUsertState();
}

class _UploadImgUsertState extends State<UploadImgUsert> {
  //Upload Images อัพโหลดรูปภาพ =====================
  //ตัวแปรเกี่ยวกับ อัพโหลดรูปภาพ
  // File _image;
  // File _camera;
  // String imgstatus = '';
  // String error = 'Error';
  var filename;
  var token;
  var userId;
  // ตัวแปรเกี่ยวกับ อัพโหลดรูปภาพ

  //multi_image_picker
  List<Asset> images = <Asset>[];
  Asset asset;
  String _error = 'No Error Dectected';

  Future _getprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    userId = prefs.getInt('id');
    print('uId = $userId');
    print('token = $token');
  }

  //สร้าง GridView
  Widget buildGridView() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // if you need this
        // side: BorderSide(
        //   color: Colors.blueAccent, //withOpacity(0.2),
        //   width: 1,
        // ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          primary: false,
          shrinkWrap: true,
          crossAxisCount: 1,
          children: List.generate(images.length, (index) {
            // asset = images[index];
            return AssetThumb(
              asset: images[index],
              width: 200,
              height: 200,
            );
          }),
        ),
      ),
    );
  }

  // ? LoadAssets
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
    var _urlUpload = '${Connectapi().domain}/uploadsuser/$userId';
// create multipart request
    MultipartRequest request =
        http.MultipartRequest("PUT", Uri.parse(_urlUpload));
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
        color: Theme.of(context).primaryColorDark,
      ),
    );
  }

  //  Container(
  //     child: Column(
  //       children: [
  //         FloatingActionButton(
  //           backgroundColor: Colors.red,
  //           onPressed: loadAssets,
  //           child: Icon(
  //             Icons.add_photo_alternate_outlined,
  //             size: 40,
  //           ),
  //         ),
  //         SizedBox(
  //           height: 7,
  //         ),
  //         Text(
  //           'เพิ่มรูปภาพ',
  //           style: TextStyle(fontWeight: FontWeight.bold),
  //         ),
  //       ],
  //     ),
  //   );

  @override
  void initState() {
    super.initState();
    _getprefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(35),
            ),
          ),
          centerTitle: true,
          title: Text(
            'แก้ไขรูปโปรไฟล์',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          backgroundColor: Theme.of(context).primaryColorDark,
        ),
      ),
      backgroundColor: Colors.grey.shade300,
      body: Center(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.only(
                bottom: 250, left: 30, right: 30, top: 150),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // if you need this
                // side: BorderSide(
                //   color: Colors.blueAccent, //withOpacity(0.2),
                //   width: 1,
                // ),
              ),
              elevation: 10,
              color: Colors.blue.shade50,
              child: Container(
                padding:
                    EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 20),
                child: Column(
                  children: [
                    Text(
                      'เลือกรูปโปรไฟล์ใหม่',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(width: 150, height: 150, child: buildGridView()),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _addImg(),
                        btnSubmit(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget btnSubmit() {
    return SizedBox(
      width: 130,
      height: 40,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Text(
          'ยืนยันการแก้ไข',
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.greenAccent.shade700,
        onPressed: () {
          _sendPathImage();

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SplashScreen()),
          );
          // Navigator.pushNamed(context, '/eduser');
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
    var duration = Duration(seconds: 2);
    return Timer(duration, navigationPage);
  }

  void navigationPage() {
    int count = 0;
    Navigator.of(context).popUntil((_) => count++ >= 3);
    // Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);

    // _showber();
  }
  //  Widget _showber() {
  //   return Center(
  //     child: Flushbar(
  //       message: "สร้างกิจกรรมสำเร็จแล้ว",
  //       icon: Icon(
  //         Icons.done,
  //         size: 28.0,
  //         color: Colors.white,
  //       ),
  //       margin: EdgeInsets.all(8),
  //       borderRadius: BorderRadius.circular(8),
  //       duration: Duration(seconds: 2),
  //       // leftBarIndicatorColor: Colors.blue[300],
  //       backgroundColor: Colors.greenAccent.shade700.withOpacity(0.8),
  //     )..show(context),
  //   );
  // }

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
                'กำลังโหลด...',
                style: TextStyle(fontSize: 18, color: Colors.black45),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
