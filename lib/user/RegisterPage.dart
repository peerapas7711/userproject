import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart';
import 'package:userproject/model/ConnectAPI.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _uid = GlobalKey<FormState>();
  final _uuser = TextEditingController();
  final _upass = TextEditingController();
  final _uname = TextEditingController();
  final _ulname = TextEditingController();
  final _uold = TextEditingController();
  final _uemail = TextEditingController();
  final _utel = TextEditingController();

//?---------------------------------------------------------------------------------------
  //?เพิ่มรูป------------------------------------------------------------------------------------------------------------------
  //Upload Images อัพโหลดรูปภาพ =====================
  //ตัวแปรเกี่ยวกับ อัพโหลดรูปภาพ
  // File _image;
  // File _camera;
  // String imgstatus = '';
  // String error = 'Error';
  var filename;
  var _urlUpload = '${Connectapi().domain}/uploadsimguser';
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
    return GridView.count(
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
      width: 130,
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
          'รูปโปรไฟล์',
          style: TextStyle(
              fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w500),
        ),
        icon: Icon(
          Icons.add_photo_alternate,
          size: 20,
          color: Colors.black,
        ),
        splashColor: Colors.white,
        color: Colors.white,
        // elevation: 10,
      ),
      // validator: (values) {
      //   if (values.isEmpty) return 'กรุณากรอกชื่อผู้ใช้';
      // },
    );
  }
//?--------------------------------------------------------------------------------------------

  void _register(Map<String, dynamic> values) async {
    String url = '${Connectapi().domain}/register';
    var response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: convert.jsonEncode(values));

    if (response.statusCode == 200) {
      print('Register Success');

      // Navigator.pop(context, true);
    } else {
      print('Register not Success!!');
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(55.0),
      //   child: AppBar(
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.vertical(
      //         bottom: Radius.circular(35),
      //       ),
      //     ),
      //     centerTitle: true,
      //     title: Text(
      //       'สมัครสมาชิก',
      //       style: TextStyle(
      //         fontSize: 18.0,
      //         color: Colors.white,
      //       ),
      //     ),
      //     backgroundColor: Theme.of(context).primaryColorDark,
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            children: [
              Text(
                'สมัครสมาชิก',
                style: TextStyle(fontSize: 25),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // if you need this
                    // side: BorderSide(
                    //   color: Colors.blueAccent, //withOpacity(0.2),
                    //   width: 1,
                    // ),
                  ),
                  color: Theme.of(context).primaryColorDark,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Form(
                      key: _uid,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    frmusername(),
                                    SizedBox(height: 5),
                                    frmpassword(),
                                  ],
                                ),
                              ],
                            ),
                            Divider(
                              height: 20,
                              thickness: 1,
                              indent: 20,
                              endIndent: 20,
                              color: Colors.white70,
                            ),
                            Container(
                                width: 150,
                                height: 180,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: buildGridView(),
                                )),
                            _addImg(),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                frmname(),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                frmold(),
                                SizedBox(width: 10),
                                frmtel(),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                frmemail(),
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                btnSubmit(),
                                SizedBox(width: 8),
                                btnback(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget frmusername() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: <Widget>[
            Row(
              children: [
                Icon(
                  CupertinoIcons.person_add_solid,
                  color: Colors.white,
                ),
                Text(
                  ' ชื่อผู้ใช้',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
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
              width: 300,
              height: 50,
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'กรุณากรอกชื่อผู้ใช้';
                  }
                },
                controller: _uuser,
                // obscureText: obsureText,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'กรอกชื่อผู้ใช้',
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


  Widget frmpassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: <Widget>[
            Row(
              children: [
                Icon(
                  Icons.vpn_key,
                  color: Colors.white,
                ),
                Text(
                  ' รหัสผ่าน',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
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
              width: 300,
              height: 50,
              child: TextFormField(
                style: TextStyle(),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'กรุณากรอกรหัสผ่าน';
                  }
                  if (value.length < 8) {
                    return 'กรุณากรอกรหัสผ่านไม่น้อยกว่า 8 ตัวอักษร';
                  }
                  if (!RegExp(r'[a-zA-Z]').hasMatch(value) ||
                      !RegExp(r'[0-9]').hasMatch(value)) {
                    return 'รหัสผ่านของคุณต้องมีอักษร a-z A-Z และตัวเลขอย่างน้อย 1 ตัวเลข';
                  }
                  return null;
                },
                controller: _upass,
                // obscureText: obsureText,
                decoration: InputDecoration(
                  hintText: 'กรอกรหัสผ่าน',
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

  Widget frmname() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: <Widget>[
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                Text(
                  ' ชื่อ - นามสกุล',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
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
              width: 177,
              height: 50,
              child: TextFormField(
                style: TextStyle(),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'กรุณากรอกชื่อ';
                  }
                },
                controller: _uname,
                // obscureText: obsureText,
                decoration: InputDecoration(
                  hintText: 'กรอกชื่อ',
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
            SizedBox(width: 8),
            SizedBox(
              width: 177,
              height: 50,
              child: TextFormField(
                style: TextStyle(),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'กรุณากรอกนามสกุล';
                  }
                },
                controller: _ulname,
                // obscureText: obsureText,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'กรอกนามสกุล',
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

  Widget frmold() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: <Widget>[
            Row(
              children: [
                Icon(
                  Icons.outlet_sharp,
                  color: Colors.white,
                ),
                Text(
                  ' อายุ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
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
              width: 120,
              height: 50,
              child: TextFormField(
                style: TextStyle(),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'กรุณากรอกอายุ';
                  }
                },
                controller: _uold,
                // obscureText: obsureText,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'กรอกอายุ',
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

  Widget frmtel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: <Widget>[
            Row(
              children: [
                Icon(
                  Icons.phone,
                  color: Colors.white,
                ),
                Text(
                  ' เบอร์โทร',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
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
              width: 230,
              height: 50,
              child: TextFormField(
                // maxLength: 10,
                // maxLengthEnforced: false,
                // maxLengthEnforcement: MaxLengthEnforcement.enforced,
                style: TextStyle(),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'กรุณากรอกเบอร์โทร';
                  }
                  if (value.length < 10) {
                    return 'กรุณากรอกเบอร์โทรให้ครบ';
                  }
                  if (value.length > 10) {
                    return 'คุณกรอกเบอร์โทรเกินจำนวน';
                  }
                  if (!RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$')
                      .hasMatch(value)) {
                    return 'กรุณากรอกเบอร์โทรให้ถูกต้อง';
                  }
                  return null;
                },
                controller: _utel,
                // obscureText: obsureText,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'กรอกเบอร์โทร',
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

  Widget frmemail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: <Widget>[
            Row(
              children: [
                Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                Text(
                  ' อีเมล',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
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
              width: 360,
              height: 50,
              child: TextFormField(
                style: TextStyle(),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'กรุณากรอกอีเมล';
                  }
                  if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                      .hasMatch(value)) {
                    return 'กรุณากรอกอีเมลให้ถูกต้อง';
                  }
                  return null;
                },
                controller: _uemail,
                // obscureText: obsureText,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'กรอกอีเมล',
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
      width: 115,
      height: 40,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Text(
          'สมัครสมาชิก',
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.greenAccent.shade400,
        onPressed: () {
          if (_uid.currentState.validate()) {
            Map<String, dynamic> valuse = Map();
            valuse['u_user'] = _uuser.text;
            valuse['u_pass'] = _upass.text;
            valuse['u_name'] = _uname.text;
            valuse['u_lname'] = _ulname.text;
            valuse['u_old'] = _uold.text;
            valuse['u_email'] = _uemail.text;
            valuse['u_tel'] = _utel.text;

            print(_uuser.text);
            print(_upass.text);
            print(_uname.text);
            print(_ulname.text);
            print(_uold.text);
            print(_uemail.text);
            print(_utel.text);

            _register(valuse);
            _sendPathImage();
            Navigator.pop(context, '/login');
            _showber();
          } else {
            _showbererror();
          }
        },
      ),
    );
  }

  Widget btnback() {
    return SizedBox(
      width: 115,
      height: 40,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Text(
          'กลับหน้าหลัก',
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.redAccent,
        onPressed: () {
          Navigator.pop(context, '/login');
        },
      ),
    );
  }

  Widget _showber() {
    return Center(
      child: Flushbar(
        message: "สมัครสมาชิกสำเร็จแล้ว",
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

  Widget _showbererror() {
    return Center(
      child: Flushbar(
        message: "สมัครสมาชิกไม่สำเร็จ",
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
