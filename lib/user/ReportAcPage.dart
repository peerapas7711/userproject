import 'package:another_flushbar/flushbar.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
// import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:userproject/keys.dart';
import 'package:userproject/model/ConnectAPI.dart';

class ReportAcPage extends StatefulWidget {
  @override
  _ReportAcPageState createState() => _ReportAcPageState();
}

class _ReportAcPageState extends State<ReportAcPage> {
  final _formkey = GlobalKey<FormState>();

  final _fdetel = TextEditingController();

  var acId;
  var token;

  // var myFormat = DateFormat('d-MM-yyyy');

  var filename;

  // var APIkeys = new Keys();
  // PickResult selectedPlace;
  // static final kInitialPosition = LatLng(-33.8567844, 151.213108);
  //เพิ่มรูป------------------------------------------------------------------------------------------------------------------
  //Upload Images อัพโหลดรูปภาพ =====================
  //ตัวแปรเกี่ยวกับ อัพโหลดรูปภาพ
  // File _image;
  // File _camera;
  // String imgstatus = '';
  // String error = 'Error';

  //multi_image_picker
  Future<String> _multiUploadimage(ast) async {
    var _urlUpload = '${Connectapi().domain}/reportimgactivity/$acId';
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
      color: Colors.cyan.shade50,
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
          crossAxisCount: 4,
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

  //LoadAssets
  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 100,
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

  //Loop รูปภาพ
  Future<void> _sendPathImage() async {
    print('path : ${images.length}');
    for (int i = 0; i < images.length; i++) {
      asset = images[i];
      print('image : $i');
      var res = _multiUploadimage(asset);
    }
  }

  Widget _addImg() {
    return SizedBox(
      height: 40,
      width: 200,
      child: RaisedButton.icon(
        onPressed: () {
          // _deleteimg();
          loadAssets();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        label: Text(
          'เพิ่มรูปภาพกิจกรรม',
          style: TextStyle(
              fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w500),
        ),
        icon: Icon(
          Icons.add_photo_alternate,
          size: 20,
          color: Colors.black,
        ),
        splashColor: Colors.white,
        color: Colors.blue.shade100,
        // elevation: 10,
      ),
      // validator: (values) {
      //   if (values.isEmpty) return 'กรุณากรอกชื่อผู้ใช้';
      // },
    );
  }

  //!-----------------------------------------------------------------------------------------------------------------------

  Future getAc() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // acId = prefs.getInt('id');
    // print('acId = $acId');
    print('token = $token');
  }

  void _selectactivity(Map<String, dynamic> values) async {
    String url = '${Connectapi().domain}/reportac/$acId';
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: convert.jsonEncode(values));

    if (response.statusCode == 200) {
      print('Activity Success');

      // Navigator.pop(context, true);
    } else {
      print('Activity not Success!!');
      print(response.body);
    }
  }

  Map<String, dynamic> _rec_member;
  Future getInfoActivity() {
    _rec_member = ModalRoute.of(context).settings.arguments;
    acId = _rec_member['_acId'];

    // _fuimg = _rec_member['u_img'];
    print(acId);
  }

  @override
  Widget build(BuildContext context) {
    getInfoActivity();
    getAc();
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
            'สร้างกิจกรรม',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          backgroundColor: Theme.of(context).primaryColorDark,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // if you need this
            side: BorderSide(
              color: Colors.blueAccent, //withOpacity(0.2),
              width: 1,
            ),
          ),
          color: Theme.of(context).primaryColorDark,
          // color: Colors.black,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Form(
              key: _formkey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildGridView(),
                    SizedBox(height: 10),
                    _addImg(),
                    SizedBox(height: 10),
                    frmpdetel(),
                    SizedBox(height: 8),
                    btssubmit(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget frmpdetel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: <Widget>[
            Text(
              'รายละเอียดการทำกิจกรรม',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            Text(
              '*',
              style: TextStyle(
                fontSize: 16,
                color: Colors.yellow,
              ),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 365,
              // height: 200,
              child: TextFormField(
                style: TextStyle(),
                validator: (value) {
                  if (value.isEmpty) {
                    return '\u26A0 กรุณากรอกรายละเอียด';
                  }
                },
                maxLines: 10,
                controller: _fdetel,
                // obscureText: obsureText,
                decoration: InputDecoration(
                  hintText:
                      'กรอกรายละเอียดการทำกิจกรรม เช่น ทำอะไรบ้าง หรือใช้เงินไปเท่าไหร่ เป็นต้น',
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red.shade800)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  //ปุ่มบันทึก--------------------------------------------------
  Widget btssubmit() {
    return SizedBox(
      width: 100,
      height: 40,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        onPressed: () {
          if (_formkey.currentState.validate()) {
            Map<String, dynamic> valuse = Map();
            valuse['ac_id'] = acId;
            valuse['re_detel'] = _fdetel.text;

            _selectactivity(valuse);
            _sendPathImage();
            //  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
            Navigator.pop(context, '/showreport');
            // _showber();
          } else {
            _showbererror();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'บันทึก',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 5,
            ),
            // Icon(
            //   Icons.arrow_forward_ios,
            //   color: Colors.white,
            //   size: 16,
            // ),
          ],
        ),
        color: Colors.greenAccent.shade700,
      ),
    );
  }

  Widget _showbererror() {
    return Center(
      child: Flushbar(
        message: "กรุณากรอกข้อมูลให้ครบ",
        icon: Icon(
          Icons.clear,
          size: 28.0,
          color: Colors.white,
        ),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        duration: Duration(seconds: 2),
        // leftBarIndicatorColor: Colors.blue[300],
        backgroundColor: Colors.orangeAccent.shade700.withOpacity(0.8),
      )..show(context),
    );
  }
}
