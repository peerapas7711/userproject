import 'package:another_flushbar/flushbar.dart';
// import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userproject/model/ConnectAPI.dart';
import 'package:userproject/model/ProfileMember.dart';
import 'package:userproject/mywidget/Show_progress.dart';

class EditdataPage extends StatefulWidget {
  @override
  _EditdataPageState createState() => _EditdataPageState();
}

class _EditdataPageState extends State<EditdataPage> {
  final _pproid = GlobalKey<FormState>();
  // TextEditingController _id;
  // TextEditingController _user;
  // TextEditingController _password;
  TextEditingController u_name;
  TextEditingController u_lname;
  TextEditingController u_old;
  TextEditingController u_email;
  TextEditingController u_tel;

  Map<String, dynamic> _rec_member;
  var uId;
  var token;
  bool load = true;

  Future getUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    uId = prefs.getInt('id');
    print('uId = $uId');
    print('token = $token');
  }

  Future<void> _updateMember(Map<String, dynamic> values) async {
    var url = '${Connectapi().domain}/updateuser/$uId';
    print(uId);
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

  

  Future getInfo() {
    _rec_member = ModalRoute.of(context).settings.arguments;
    uId = _rec_member['id'];
    //_user = TextEditingController(text: _rec_member['u_user']);
    //_password = TextEditingController(text: _rec_member['u_pass']);
    u_name = TextEditingController(text: _rec_member['u_name']);
    u_lname = TextEditingController(text: _rec_member['u_lname']);
    u_old = TextEditingController(text: _rec_member['u_old']);
    u_email = TextEditingController(text: _rec_member['u_email']);
    u_tel = TextEditingController(text: _rec_member['u_tel']);
  }

  Showprofileimg imagemember;

  Future<void> _getUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    uId = prefs.getInt('id');
    print('acId = $uId');
    print('token = $token');
    var url = '${Connectapi().domain}/getuserprofileimg/$uId';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    //check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      ProfileMember images =
          ProfileMember.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        imagemember = images.showprofileimg;
        // print(imagemember.length);
        load = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //call _getAPI
     _getUserImage();
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
            'ข้อมูลส่วนตัว',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          backgroundColor: Theme.of(context).primaryColorDark,
        ),
      ),
      body: Container(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _pproid,
                child: SingleChildScrollView(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // if you need this
                      // side: BorderSide(
                      //   color: Colors.blueAccent, //withOpacity(0.2),
                      //   width: 1,
                      // ),
                    ),
                    elevation: 2,
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          
                          Text(
                            'แก้ไขข้อมูล',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 5),
                          ProfilePic(), //? -- > Profile Picture
                          TextButton(
                            onPressed: (){
                              Navigator.pushNamed(context, '/imguserupdate');
                            },
                            child: Text('แก้ไขรูปโปร์ไฟล์',style: TextStyle(color: Colors.blueAccent),),
                          ),
                          // SizedBox(height: 50),
                          SizedBox(height: 8),
                          frmp4(),
                          SizedBox(height: 10),
                          frmp5(),
                          SizedBox(height: 10),
                          frmp6(),
                          SizedBox(height: 10),
                          frmp7(),
                          SizedBox(height: 10),
                          frmp8(),
                          SizedBox(height: 10),
                          btnSubmit(),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      // load ? ShowProgress : editdata(),
    );
  }

  // Center editdata() {
  //   return Center(
  //     child: Container(
  //         child: Center(
  //           child: Padding(
  //             padding: EdgeInsets.all(20.0),
  //             child: Form(
  //               key: _pproid,
  //               child: SingleChildScrollView(
  //                 child: Card(
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(20), // if you need this
  //                     // side: BorderSide(
  //                     //   color: Colors.blueAccent, //withOpacity(0.2),
  //                     //   width: 1,
  //                     // ),
  //                   ),
  //                   elevation: 2,
  //                   color: Colors.blue.shade50,
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(10.0),
  //                     child: Column(
  //                       children: [
                          
  //                         Text(
  //                           'แก้ไขข้อมูล',
  //                           style: TextStyle(fontSize: 20),
  //                         ),
  //                         SizedBox(height: 5),
  //                         ProfilePic(), //? -- > Profile Picture
  //                         TextButton(
  //                           onPressed: (){
  //                             Navigator.pushNamed(context, '/imguserupdate');
  //                           },
  //                           child: Text('แก้ไขรูปโปร์ไฟล์',style: TextStyle(color: Colors.blueAccent),),
  //                         ),
  //                         // SizedBox(height: 50),
  //                         SizedBox(height: 8),
  //                         frmp4(),
  //                         SizedBox(height: 10),
  //                         frmp5(),
  //                         SizedBox(height: 10),
  //                         frmp6(),
  //                         SizedBox(height: 10),
  //                         frmp7(),
  //                         SizedBox(height: 10),
  //                         frmp8(),
  //                         SizedBox(height: 10),
  //                         btnSubmit(),
  //                         SizedBox(height: 8),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //   );
  // }

  Widget frmp4() {
    return TextFormField(
      controller: u_name,
      decoration: InputDecoration(
        labelText: 'ชื่อ',
        hintText: 'กรอกชื่อ',
        icon: Icon(Icons.person),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: (values) {
        if (values.isEmpty) {
          return 'กรุณากรอกชื่อ';
        }
      },
    );
  }

  Widget frmp5() {
    return TextFormField(
      controller: u_lname,
      decoration: InputDecoration(
        labelText: 'นามสกุล',
        hintText: 'กรอกนามสกุล',
        icon: Icon(Icons.person),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: (values) {
        if (values.isEmpty) {
          return 'กรุณากรอกนามสกุล';
        }
      },
    );
  }

  Widget frmp6() {
    return TextFormField(
      controller: u_old,
      decoration: InputDecoration(
        labelText: 'อายุ',
        hintText: 'กรอกอายุ',
        icon: Icon(Icons.outlet_sharp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: (values) {
        if (values.isEmpty) {
          return 'กรุณากรอกอายุ';
        }
      },
    );
  }

  Widget frmp7() {
    return TextFormField(
      controller: u_email,
      decoration: InputDecoration(
        labelText: 'อีเมลล์',
        hintText: 'กรอกอีเมลล์',
        icon: Icon(Icons.email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: (values) {
        if (values.isEmpty) {
          return 'กรุณากรอกอีเมลล์';
        }
      },
    );
  }

  Widget frmp8() {
    return TextFormField(
      controller: u_tel,
      decoration: InputDecoration(
        labelText: 'เบอร์โทร',
        hintText: 'กรอกเบอร์โทร',
        icon: Icon(Icons.phone),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: (values) {
        if (values.isEmpty) {
          return 'กรุณากรอกเบอร์โทร';
        }
      },
    );
  }

  Widget btnSubmit() {
    return SizedBox(
      width: 150,
      height: 45,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Text('ยืนยันการแก้ไข', style: TextStyle(color: Colors.white)),
        color: Colors.greenAccent.shade700,
        onPressed: () {
          Map<String, dynamic> valuse = Map();
          valuse['u_id'] = uId;
          //valuse['u_user'] = _user.text;
          //valuse['u_pass'] = _password.text;
          valuse['u_name'] = u_name.text;
          valuse['u_lname'] = u_lname.text;
          valuse['u_old'] = u_old.text;
          valuse['u_email'] = u_email.text;
          valuse['u_tel'] = u_tel.text;

          print(u_name.text);
          print(u_lname.text);
          print(u_old.text);
          print(u_email.text);
          print(u_tel.text);

          _updateMember(valuse);
          Navigator.pop(context, '/edit');

          // Navigator.pushNamedAndRemoveUntil(context, '/edit', (route) => false);
          _showber();
        },
      ),
    );
  }

  SizedBox ProfilePic() {
    return SizedBox(
      height: 120,
      width: 120,
      child: Stack(
        overflow: Overflow.visible,
        // fit: StackFit.expand,
        children: [
          CircleAvatar(
              backgroundColor: Colors.yellow.shade50,
              radius: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(600.0),
                child: Container(
                  child: _checkSendRepairImage(imagemember.iuImg),
                  width: 150,
                  height: 150,
                ),
              ),
            ),
          
          // Positioned(
          //   right: 120,
          //   bottom: 0,
          //   child: SizedBox(
          //     height: 30,
          //     width: 30,
          //     child: FlatButton(
          //         padding: EdgeInsets.zero,
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(50),
          //           // side: BorderSide(color: Colors.black),
          //         ),
          //         color: Colors.blueAccent,
          //         onPressed: () {
          //           Navigator.pushNamed(context, '/imguserupdate');
          //         },
          //         child: Icon(
          //           Icons.add_a_photo,
          //           size: 18,
          //           color: Colors.white,
          //         )),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget _showber() {
    return Center(
      child: Flushbar(
        message: "แก้ไขข้อมูลสำเร็จแล้ว",
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

  Widget _checkSendRepairImage(imageName) {
    Widget child;
    print('Imagename : $imageName');
    if (imageName != null) {
      child = Image.network('${Connectapi().userprofile}${imageName}',
          fit: BoxFit.cover);
    } else {
      child = Image.asset('assets/images/noimg.jpg', fit: BoxFit.cover);
    }
    return new Container(child: child);
  }
}
