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

class ActivityFrom extends StatefulWidget {
  @override
  _ActivityFromState createState() => _ActivityFromState();
}

class _ActivityFromState extends State<ActivityFrom> {
  final _formkey = GlobalKey<FormState>();
  final _fname = TextEditingController();
  final _ftime = TextEditingController();
  final _funit = TextEditingController();
  // final _flatijood = TextEditingController();
  // final _flongtijood = TextEditingController();
  final _fhome = TextEditingController();
  final _fsub = TextEditingController();
  final _fdis = TextEditingController();
  final _fprovin = TextEditingController();
  final _fdetel = TextEditingController();

  String _chosenValue;
  DateTime selectedData;
  DateTime selectedLastData;

  var uId;
  var token;
  PickResult selectedPlace;
  var APIkeys = new Keys();
  static final kInitialPosition = LatLng(-33.8567844, 151.213108);

  // var myFormat = DateFormat('d-MM-yyyy');

  //?เพิ่มรูป------------------------------------------------------------------------------------------------------------------
  //Upload Images อัพโหลดรูปภาพ =====================
  //ตัวแปรเกี่ยวกับ อัพโหลดรูปภาพ
  // File _image;
  // File _camera;
  // String imgstatus = '';
  // String error = 'Error';
  var filename;
  var _urlUpload = '${Connectapi().domain}/uploads';
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
        child: Container(
          height: 90,
          child: images.length <= 0
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Opacity(
                      //     opacity: 0.4,
                      //     child: Image.asset('assets/images/LoGo2.PNG')),
                      Text(
                        'รูปภาพกิจกรรม',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black38,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )
              : GridView.count(
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
      ),
    );
  }

  //LoadAssets
  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 12,
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
  // Widget _addImg() {
  //   return Container(
  //     child: Column(
  //       children: [
  //         FloatingActionButton(
  //           backgroundColor: Colors.blue.shade100,
  //           onPressed: loadAssets,
  //           child: Icon(
  //             Icons.add_photo_alternate_outlined,
  //             color: Colors.black,
  //             size: 40,
  //           ),
  //         ),
  //         SizedBox(
  //           height: 7,
  //         ),
  //         Text(
  //           'เพิ่มรูปภาพ',
  //           // style: TextStyle(fontWeight: FontWeight.bold),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _addImg() {
    return SizedBox(
      height: 40,
      width: 200,
      child: RaisedButton.icon(
        onPressed: () {
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
    uId = prefs.getInt('id');
    print('uId = $uId');
    print('token = $token');
  }

  void _selectactivity(Map<String, dynamic> values) async {
    String url = '${Connectapi().domain}/addactivity/$uId';
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

  @override
  Widget build(BuildContext context) {
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
                    frmname(),
                    frmpdetel(),
                    SizedBox(height: 8),
                    _addImg(),
                    SizedBox(height: 10),
                    buildGridView(),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        frmnumber(),
                        SizedBox(width: 10),
                        frmldate(),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(children: <Widget>[
                      // Expanded(child: Divider()),
                      Text(
                        'วันเวลา',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Expanded(
                          child: Divider(
                        thickness: 1.5,
                        indent: 5,
                        endIndent: 15,
                        color: Colors.white70,
                      )),
                    ]),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        frmdate(),
                        SizedBox(width: 15),
                        frmtime(),
                        SizedBox(width: 15),
                      ],
                    ),
                    // SizedBox(height: 8),
                    // Row(
                    //   children: [
                    //     frmldate(),
                    //   ],
                    // ),
                    SizedBox(height: 8),
                    Row(children: <Widget>[
                      // Expanded(child: Divider()),
                      Text(
                        'สถานที่ทำกิจกรรม',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Expanded(
                          child: Divider(
                        thickness: 1.5,
                        indent: 5,
                        endIndent: 15,
                        color: Colors.white70,
                      )),
                    ]),
                    Padding(
                      padding: EdgeInsets.only(left: 0),
                      child: Row(
                        children: [
                          frmhome(),
                          SizedBox(width: 10),
                          frmsub(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 0),
                      child: Row(
                        children: [
                          frmdis(),
                          SizedBox(width: 10),
                          frmprovin(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    // Divider(
                    //   height: 20,
                    //   thickness: 1,
                    //   indent: 20,
                    //   endIndent: 20,
                    // ),
                    frmap(),
                    SizedBox(
                      height: 8,
                    ),
                    Column(
                      children: [
                        selectedPlace == null
                            ? Container()
                            : Text(
                                selectedPlace.formattedAddress ?? "",
                                style: TextStyle(color: Colors.white),
                              ),
                        selectedPlace == null
                            ? Container()
                            : Text(
                                selectedPlace.geometry.location.toString() ??
                                    "",
                                style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        btssubmit(),
                      ],
                    ),
                    SizedBox(
                      height: 10,
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

  Widget frmname() {
    return Row(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'ชื่อกิจกรรม',
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
            SizedBox(
              height: 5,
            ),
            SizedBox(
              width: 220,
              height: 60,
              child: TextFormField(
                style: TextStyle(),
                validator: (value) {
                  if (value.isEmpty) {
                    return '\u26A0 กรุณากรอกชื่อกิจกรรม';
                  }
                },
                controller: _fname,
                decoration: InputDecoration(
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
        SizedBox(
          width: 5,
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: Container(
            width: 142.0,
            height: 48.0,
            // color: Colors.black12,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              // color: Colors.cyan,
              border: Border.all(
                color: Colors.white,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _chosenValue,
                // elevation: 5,
                // style: TextStyle(color: Colors.black,),
                items: <String>[
                  'จิตอาสาพัฒนา',
                  'จิตอาสาภัยพิบัติ',
                  'จิตอาสาเฉพาะกิจ',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                style: TextStyle(color: Colors.black, fontFamily: 'Kanit'),
                hint: Text(
                  "ประเภทกิจกรรม",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Kanit',
                  ),
                ),
                onChanged: (String value) {
                  setState(() {
                    _chosenValue = value;
                  });
                },
              ),
            ),
          ),
        ),
        // SizedBox(
        //   width: 10,
        // ),
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Row(
        //       children: [
        //         Text(
        //           'จำนวนคนที่ต้องการ',
        //           style: TextStyle(
        //             fontSize: 14,
        //           ),
        //         ),
        //       ],
        //     ),
        //     SizedBox(
        //       height: 5,
        //     ),
        //     SizedBox(
        //       width: 110,
        //       height: 60,
        //       child: TextField(
        //         style: TextStyle(),
        //         controller: _funit,
        //         // obscureText: obsureText,
        //         decoration: InputDecoration(
        //           contentPadding:
        //               EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        //           enabledBorder: OutlineInputBorder(
        //             borderSide: BorderSide(
        //               color: Colors.blue,
        //             ),
        //           ),
        //           border: OutlineInputBorder(
        //               borderSide: BorderSide(color: Colors.red.shade800)),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }

  Widget frmdate() {
    DateFormat("dd-MM-yyyy").format(DateTime.now());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'วันเริ่มทำกิจกรรม',
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
            Container(
              width: 120.0,
              height: 60,
              // color: Colors.black12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                // color: Colors.cyan,
                border: Border.all(
                  color: Colors.blue,
                ),
              ),
              child: DateField(
                firstDate: DateTime.now(),
                onDateSelected: (DateTime value) {
                  setState(() {
                    selectedData = value;
                  });
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                label: 'เลือกวันที่',
                dateFormat: DateFormat("dd-MM-yyyy"),
                // dateFormat: DateFormat.yMMMd(),
                selectedDate: selectedData,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget frmldate() {
    DateFormat("dd-MM-yyyy").format(DateTime.now());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'วันสุดท้ายการเข้าร่วม',
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
            Container(
              width: 120.0,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                // color: Colors.cyan,
                border: Border.all(
                  color: Colors.blue,
                ),
              ),
              child: DateField(
                firstDate: DateTime.now(),
                onDateSelected: (DateTime value) {
                  setState(() {
                    selectedLastData = value;
                  });
                },

                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                label: 'เลือกวันที่',
                dateFormat: DateFormat("dd-MM-yyyy"),
                // dateFormat: DateFormat.yMMMd(),
                selectedDate: selectedLastData,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget frmtime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: <Widget>[
            Text(
              'เวลา',
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
              width: 110,
              height: 60,
              child: TextFormField(
                style: TextStyle(),
                validator: (value) {
                  if (value.isEmpty) {
                    return '\u26A0 กรุณากรอกเวลาในการทำกิจกรรม';
                  }
                },
                controller: _ftime,
                decoration: InputDecoration(
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
            Text(
              ' น.',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  Widget frmnumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: <Widget>[
            Text(
              'จำนวนคน',
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
              width: 100,
              height: 60,
              child: TextFormField(
                style: TextStyle(),
                validator: (value) {
                  if (value.isEmpty) {
                    return '\u26A0 กรุณากรอกจำนวนคนที่รับในการทำกิจกรรม';
                  }
                },
                controller: _funit,
                // obscureText: obsureText,
                decoration: InputDecoration(
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
            Text(
              ' คน',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  Widget frmhome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: <Widget>[
            Text(
              'บ้าน',
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
              width: 175,
              height: 80,
              child: TextFormField(
                style: TextStyle(),
                validator: (value) {
                  if (value.isEmpty) {
                    return '\u26A0 กรุณากรอกบ้าน';
                  }
                },
                controller: _fhome,
                // obscureText: obsureText,
                decoration: InputDecoration(
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

  Widget frmsub() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: <Widget>[
            Text(
              'ตำบล',
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
              width: 175,
              height: 80,
              child: TextFormField(
                style: TextStyle(),
                validator: (value) {
                  if (value.isEmpty) {
                    return '\u26A0 กรุณากรอกตำบล';
                  }
                },
                controller: _fsub,
                // obscureText: obsureText,
                decoration: InputDecoration(
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

  Widget frmdis() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: <Widget>[
            Text(
              'อำเภอ',
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
              width: 175,
              height: 80,
              child: TextFormField(
                style: TextStyle(),
                validator: (value) {
                  if (value.isEmpty) {
                    return '\u26A0 กรุณากรอกอำเภอ';
                  }
                },
                controller: _fdis,
                // obscureText: obsureText,
                decoration: InputDecoration(
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

  Widget frmprovin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: <Widget>[
            Text(
              'จังหวัด',
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
              width: 175,
              height: 80,
              child: TextFormField(
                style: TextStyle(),
                validator: (value) {
                  if (value.isEmpty) {
                    return '\u26A0 กรุณากรอกจังหวัด';
                  }
                },
                controller: _fprovin,
                // obscureText: obsureText,
                decoration: InputDecoration(
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

  Widget frmpdetel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: <Widget>[
            Text(
              'รายละเอียด',
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
                maxLines: 5,
                controller: _fdetel,
                // obscureText: obsureText,
                decoration: InputDecoration(
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

  Widget frmap() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 300,
          height: 45,
          child: RaisedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return PlacePicker(
                      apiKey: APIkeys.apikey,
                      initialPosition: kInitialPosition,
                      useCurrentLocation: true,
                      selectInitialPosition: true,

                      usePlaceDetailSearch: true,
                      onPlacePicked: (result) {
                        selectedPlace = result;
                        Navigator.of(context).pop();
                        setState(() {});
                      },
                      forceSearchOnZoomChanged: true,
                      automaticallyImplyAppBarLeading: true,
                      autocompleteLanguage: "th",
                      region: 'th',
                      // selectInitialPosition: true,
                      // selectedPlaceWidgetBuilder:
                      //     (_, selectedPlace, state, isSearchBarFocused) {
                      //   print("state: $state, isSearchBarFocused: $isSearchBarFocused");
                      //   return isSearchBarFocused
                      //       ? Container()
                      //       : FloatingCard(
                      //           bottomPosition:
                      //               0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                      //           leftPosition: 0.0,
                      //           rightPosition: 0.0,
                      //           width: 500,
                      //           borderRadius: BorderRadius.circular(12.0),
                      //           child: state == SearchingState.Searching
                      //               ? Center(child: CircularProgressIndicator())
                      //               : RaisedButton(
                      //                   child: Text("Pick Here"),
                      //                   onPressed: () {
                      //                     var lat = selectedPlace.geometry.location.lat;
                      //                     var lng = selectedPlace.geometry.location.lng;
                      //                     // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                      //                     //            this will override default 'Select here' Button.
                      //                     print("$lat,$lng");
                      //                     Navigator.of(context).pop();
                      //                   },
                      //                 ),
                      //         );
                      // },
                      // pinBuilder: (context, state) {
                      //   if (state == PinState.Idle) {
                      //     return Icon(Icons.favorite_border);
                      //   } else {
                      //     return Icon(Icons.favorite);
                      //   }
                      // },
                    );
                  },
                ),
              );
            },

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            label: Text(
              'ปักหมุดตำแหน่งที่ตั้งของกิจกรรม',
              style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
            icon: Icon(
              CupertinoIcons.location_solid,
              size: 20,
              color: Colors.black,
            ),
            splashColor: Colors.white,
            color: Colors.white,
            // elevation: 10,
          ),
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
            var lat = selectedPlace.geometry.location.lat;
            var lng = selectedPlace.geometry.location.lng;
            valuse['ac_name'] = _fname.text;
            valuse['ac_type'] = _chosenValue.toString();
            valuse['ac_time'] = _ftime.text;
            valuse['ac_date'] = selectedData.toString();
            valuse['ac_ldate'] = selectedLastData.toString();
            valuse['ac_number'] = _funit.text;
            valuse['ac_home'] = _fhome.text;
            valuse['ac_sub'] = _fsub.text;
            valuse['ac_district'] = _fdis.text;
            valuse['ac_province'] = _fprovin.text;
            valuse['ac_detel'] = _fdetel.text;
            valuse['ac_la'] = lat;
            valuse['ac_long'] = lng;

            _selectactivity(valuse);
            _sendPathImage();
            //  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
            Navigator.pushNamed(context, '/profileactivity');
            // _showber();
          } else {
            _showbererror();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '  ถัดไป',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 5,
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
        color: Colors.greenAccent.shade700,
      ),
    );
  }

  // Widget _showber() {
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
