import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:userproject/model/ConnectAPI.dart';

class EditUsAc extends StatefulWidget {
  // const EditUsAc({Key key}) : super(key: key);

  @override
  _EditUsAcState createState() => _EditUsAcState();
}

class _EditUsAcState extends State<EditUsAc> {
  final _pproid = GlobalKey<FormState>();

  var _acId;
  TextEditingController _acname;
  TextEditingController _actype;
  TextEditingController _acdate;
  TextEditingController _acldate;
  TextEditingController _actime;
  TextEditingController _acnamber;
  TextEditingController _achome;
  TextEditingController _acsub;
  TextEditingController _acdistrict;
  TextEditingController _acprovince;
  TextEditingController _acdetel;
  // TextEditingController _acla;
  // TextEditingController _aclong;

  String _chosenValue;
  DateTime selectedData;

  Map<String, dynamic> _rec_member;
  var idUser;
  var token;
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
    var _urlUpload = '${Connectapi().domain}/editimgactivity/$_acId';
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
          _deleteimg();
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

  Future getUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    idUser = prefs.getInt('id');
    print('acId = $idUser');
    print('token = $token');
  }

  Future<void> _updateMember(Map<String, dynamic> values) async {
    var url = '${Connectapi().domain}/updateactivity/$_acId';
    print(_acId);
    var response = await http.put(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: convert.jsonEncode(values));
    print(values);
    if (response.statusCode == 200) {
      print('Update Success!');
      // Navigator.pop(context, true);
    } else {
      print('Update Fail!!');
    }
  }

  Future<void> _deleteimg() async {
    var url = '${Connectapi().domain}/deleteimg/$_acId';
    print(_acId);
    var response = await http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      print('delete Success!');
      // Navigator.pop(context, true);
    } else {
      print('delete Fail!!');
    }
  }

  Future getInfo() {
    _rec_member = ModalRoute.of(context).settings.arguments;
    _acId = _rec_member['_acId'];
    _acname = TextEditingController(text: _rec_member['_facname']);
    // _chosenValue = _rec_member['_factype'];
    _actime = TextEditingController(text: _rec_member['_factime']);
    _acdate = TextEditingController(text: _rec_member['_facdate']);
    _acldate = TextEditingController(text: _rec_member['_facldate']);
    _acnamber = TextEditingController(text: _rec_member['_facnamber']);
    _achome = TextEditingController(text: _rec_member['_fachome']);
    _acsub = TextEditingController(text: _rec_member['_facsub']);
    _acdistrict = TextEditingController(text: _rec_member['_facdistrict']);
    _acprovince = TextEditingController(text: _rec_member['_facprovince']);
    _acdetel = TextEditingController(text: _rec_member['_facdetel']);
    // _acla = TextEditingController(text: _rec_member['_facla']);
    // _aclong = TextEditingController(text: _rec_member['_faclong']);
    print(_acId);
  }

  @override
  Widget build(BuildContext context) {
    getInfo();
    getUpdate();

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
            'แก้ไขข้อมูลกิจกรรม',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          backgroundColor: Theme.of(context).primaryColorDark,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // if you need this
            side: BorderSide(
              color: Colors.blueAccent, //withOpacity(0.2),
              width: 1,
            ),
          ),
          color: Colors.blue.shade50,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Form(
              key: _pproid,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Text(
                    //   'แก้ไขข้อมูล',
                    //   style: TextStyle(fontSize: 30),
                    // ),
                    // SizedBox(height: 15),
                    frmname(),
                    frmtype(),
                    SizedBox(height: 8),
                    frmpdetel(),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.warning,
                          color: Colors.red,
                          size: 18,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          'ถ้าต้องการแก้ไขรูปภาพ รูปภาพที่เพิ่มก่อนหน้าจะถูกลบ',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    _addImg(),
                    SizedBox(height: 10),
                    buildGridView(),

                    frmnumber(),
                    SizedBox(height: 8),
                    Row(children: <Widget>[
                      // Expanded(child: Divider()),
                      Text(
                        'วันเวลา',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Expanded(
                          child: Divider(
                        thickness: 1.5,
                        indent: 5,
                        endIndent: 15,
                      )),
                    ]),
                    Row(
                      children: [
                        frmdate(),
                        SizedBox(width: 20),
                        frmtime(),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        frmldate(),
                        SizedBox(width: 10),
                      ],
                    ),
                    Row(children: <Widget>[
                      // Expanded(child: Divider()),
                      Text(
                        'สถานที่ทำกิจกรรม',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Expanded(
                          child: Divider(
                        thickness: 1.5,
                        indent: 5,
                        endIndent: 15,
                      )),
                    ]),
                    SizedBox(height: 8),

                    Row(
                      children: [
                        frmhome(),
                        SizedBox(width: 10),
                        frmsub(),
                      ],
                    ),
                    Row(
                      children: [
                        frmdis(),
                        SizedBox(width: 10),
                        frmprovin(),
                      ],
                    ),
                    SizedBox(height: 8),
                    //     // frmap(),
                    // SizedBox(
                    //   height: 8,
                    // ),
                    // Column(
                    //   children: [
                    //     selectedPlace == null
                    //         ? Container()
                    //         : Text(selectedPlace.formattedAddress ?? ""),
                    //     selectedPlace == null
                    //         ? Container()
                    //         : Text(
                    //             selectedPlace.geometry.location.toString() ?? ""),
                    //   ],
                    // ),

                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        btnSubmit(),
                      ],
                    ),
                    SizedBox(height: 10),
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
        // Container(
        //   width: 300.0,
        //   padding: EdgeInsets.all(5.0),
        //   child: TextFormField(
        //     style: TextStyle(),
        //     validator: (value) {
        //       if (value.isEmpty) {
        //         return '\u26A0 กรุณากรอกชื่อกิจกรรม';
        //       }
        //     },
        //     controller: _fname,
        //     decoration: InputDecoration(
        //         fillColor: Colors.black12,
        //         filled: true,
        //         labelText: 'ชื่อกิจกรรม',
        //         border: OutlineInputBorder(
        //             borderRadius: BorderRadius.circular(5.0))),
        //   ),
        // ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'ชื่อกิจกรรม',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              width: 360,
              height: 60,
              child: TextField(
                style: TextStyle(),
                controller: _acname,
                // obscureText: obsureText,
                decoration: InputDecoration(
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

  Widget frmtype() {
    return Row(
      children: <Widget>[
        Column(
          children: [
            Container(
              width: 240,
              height: 48.0,
              // color: Colors.black12,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                // color: Colors.cyan,
                border: Border.all(
                  color: Colors.blue,
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
                    "กรุณาเลือกประเภทกิจกรรมใหม่",
                    style: TextStyle(
                      color: Colors.red,
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
          ],
        ),
      ],
    );
  }

  Widget frmdate() {
    DateFormat("dd-MM-yyyy").format(DateTime.now());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Text(
              'วันเริ่มทำกิจกรรม',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
        // Row(
        //   children: [
        //     Container(
        //       width: 150.0,
        //       height: 56.7,
        //       // color: Colors.black12,
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(5.0),
        //         // color: Colors.cyan,
        //         border: Border.all(
        //           color: Colors.blue,
        //         ),
        //       ),
        //       child: DateField(
        //         onDateSelected: (DateTime value) {
        //           setState(() {
        //             selectedData = value;
        //           });
        //         },
        //         decoration: InputDecoration(
        //           border: OutlineInputBorder(
        //               // borderSide: BorderSide(color: Colors.yellow),
        //               ),
        //         ),
        //         // label: 'ว/ด/ป',
        //         dateFormat: DateFormat("dd-MM-yyyy"),
        //         selectedDate: selectedData,
        //       ),
        //     ),
        //   ],
        // ),
        Row(
          children: [
            SizedBox(
              width: 120,
              height: 56.7,
              child: TextField(
                style: TextStyle(),
                controller: _acdate,
                // obscureText: obsureText,
                decoration: InputDecoration(
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

  Widget frmldate() {
    DateFormat("dd-MM-yyyy").format(DateTime.now());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Text(
              'วันสิ้นสุดการเข้าร่วม',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ],
        ),
        // Row(
        //   children: [
        //     Container(
        //       width: 150.0,
        //       height: 56.7,
        //       // color: Colors.black12,
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(5.0),
        //         // color: Colors.cyan,
        //         border: Border.all(
        //           color: Colors.blue,
        //         ),
        //       ),
        //       child: DateField(
        //         onDateSelected: (DateTime value) {
        //           setState(() {
        //             selectedData = value;
        //           });
        //         },
        //         decoration: InputDecoration(
        //           border: OutlineInputBorder(
        //               // borderSide: BorderSide(color: Colors.yellow),
        //               ),
        //         ),
        //         // label: 'ว/ด/ป',
        //         dateFormat: DateFormat("dd-MM-yyyy"),
        //         selectedDate: selectedData,
        //       ),
        //     ),
        //   ],
        // ),
        Row(
          children: [
            SizedBox(
              width: 120,
              height: 56.7,
              child: TextField(
                style: TextStyle(),
                controller: _acldate,
                // obscureText: obsureText,
                decoration: InputDecoration(
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
              ),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 110,
              height: 55,
              child: TextField(
                style: TextStyle(),
                controller: _actime,
                // obscureText: obsureText,
                decoration: InputDecoration(
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
              style: TextStyle(fontSize: 16),
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
                fontSize: 15,
              ),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 80,
              height: 50,
              child: TextField(
                style: TextStyle(),
                controller: _acnamber,
                // obscureText: obsureText,
                decoration: InputDecoration(
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
              style: TextStyle(fontSize: 16),
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
              ),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 175,
              height: 40,
              child: TextField(
                style: TextStyle(),
                controller: _achome,
                // obscureText: obsureText,
                decoration: InputDecoration(
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
              ),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 175,
              height: 40,
              child: TextField(
                style: TextStyle(),
                controller: _acsub,
                // obscureText: obsureText,
                decoration: InputDecoration(
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
              ),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 175,
              height: 40,
              child: TextField(
                style: TextStyle(),
                controller: _acdistrict,
                // obscureText: obsureText,
                decoration: InputDecoration(
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
              ),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 175,
              height: 40,
              child: TextField(
                style: TextStyle(),
                controller: _acprovince,
                // obscureText: obsureText,
                decoration: InputDecoration(
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

  // // Widget frmap() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       SizedBox(
  //         width: 300,
  //         height: 45,
  //         child: RaisedButton.icon(
  //           onPressed: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) {
  //                   return PlacePicker(
  //                     apiKey: APIkeys.apikey,
  //                     initialPosition: kInitialPosition,
  //                     useCurrentLocation: true,
  //                     selectInitialPosition: true,

  //                     //usePlaceDetailSearch: true,
  //                     onPlacePicked: (result) {
  //                       selectedPlace = result;
  //                       Navigator.of(context).pop();
  //                       setState(() {});
  //                     },
  //                     //forceSearchOnZoomChanged: true,
  //                     automaticallyImplyAppBarLeading: true,
  //                     autocompleteLanguage: "th",
  //                     region: 'au',
  //                     // selectInitialPosition: true,
  //                     // selectedPlaceWidgetBuilder:
  //                     //     (_, selectedPlace, state, isSearchBarFocused) {
  //                     //   print("state: $state, isSearchBarFocused: $isSearchBarFocused");
  //                     //   return isSearchBarFocused
  //                     //       ? Container()
  //                     //       : FloatingCard(
  //                     //           bottomPosition:
  //                     //               0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
  //                     //           leftPosition: 0.0,
  //                     //           rightPosition: 0.0,
  //                     //           width: 500,
  //                     //           borderRadius: BorderRadius.circular(12.0),
  //                     //           child: state == SearchingState.Searching
  //                     //               ? Center(child: CircularProgressIndicator())
  //                     //               : RaisedButton(
  //                     //                   child: Text("Pick Here"),
  //                     //                   onPressed: () {
  //                     //                     var lat = selectedPlace.geometry.location.lat;
  //                     //                     var lng = selectedPlace.geometry.location.lng;
  //                     //                     // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
  //                     //                     //            this will override default 'Select here' Button.
  //                     //                     print("$lat,$lng");
  //                     //                     Navigator.of(context).pop();
  //                     //                   },
  //                     //                 ),
  //                     //         );
  //                     // },
  //                     // pinBuilder: (context, state) {
  //                     //   if (state == PinState.Idle) {
  //                     //     return Icon(Icons.favorite_border);
  //                     //   } else {
  //                     //     return Icon(Icons.favorite);
  //                     //   }
  //                     // },
  //                   );
  //                 },
  //               ),
  //             );
  //           },

  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(
  //               Radius.circular(10),
  //             ),
  //           ),
  //           label: Text(
  //             'ปักหมุดตำแหน่งที่ตั้งของกิจกรรม',
  //             style: TextStyle(
  //                 fontSize: 14.0,
  //                 color: Colors.black,
  //                 fontWeight: FontWeight.w500),
  //           ),
  //           icon: Icon(
  //             Icons.map,
  //             size: 20,
  //             color: Colors.black,
  //           ),
  //           splashColor: Colors.white,
  //           color: Colors.blue.shade100,
  //           // elevation: 10,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget frmpdetel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: <Widget>[
            Text(
              'รายระเอียด',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
        Row(
          children: [
            SizedBox(
              width: 360,
              // height: 200,
              child: TextField(
                style: TextStyle(),
                maxLines: 5,
                controller: _acdetel,
                // obscureText: obsureText,
                decoration: InputDecoration(
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

  Widget btnSubmit() {
    return SizedBox(
      width: 170,
      height: 45,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child:
            Text('ยืนยันการแก้ไขข้อมูล', style: TextStyle(color: Colors.white)),
        color: Colors.greenAccent.shade700,
        onPressed: () {
          Map<String, dynamic> valuse = Map();
          // var _acla = selectedPlace.geometry.location.lat;
          // var _aclong = selectedPlace.geometry.location.lng;
          valuse['ac_id'] = _acId;
          valuse['ac_name'] = _acname.text;
          valuse['ac_type'] = _chosenValue.toString();
          valuse['ac_time'] = _actime.text;
          valuse['ac_date'] = _acdate.text.toString();
          valuse['ac_ldate'] = _acldate.text.toString();
          valuse['ac_number'] = _acnamber.text.toString();
          valuse['ac_home'] = _achome.text;
          valuse['ac_sub'] = _acsub.text;
          valuse['ac_district'] = _acdistrict.text;
          valuse['ac_province'] = _acprovince.text;
          valuse['ac_detel'] = _acdetel.text;
          // valuse['ac_la'] = _acla.toDouble();
          // valuse['ac_long'] = _aclong.toDouble();

          print(_acId);
          print(_acname.text);
          print(_chosenValue.toString());
          print(_actime.text);
          print(_acdate.text);
          print(_acldate.text);
          print(_acnamber.text);
          print(_achome.text);
          print(_acsub.text);
          print(_acdistrict.text);
          print(_acprovince.text);
          print(_acdetel.text);
          // print(_acla.toDouble);
          // print(_aclong.toDouble);

          _sendPathImage();
          _updateMember(valuse);

          // Navigator.popUntil(context, (route) => false)(context, '/usacpage');
          Navigator.popUntil(context, ModalRoute.withName('/usacpage'));

          // Navigator.pushNamedAndRemoveUntil(context, '/edit', (route) => false);
          // _showbar();
        },
      ),
    );
  }
}
