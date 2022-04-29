import 'dart:ffi';

import 'package:dashed_circle/dashed_circle.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userproject/model/ConnectAPI.dart';
import 'package:userproject/model/ProfileMember.dart';
import 'package:userproject/model/UserMember.dart';
import 'package:userproject/mywidget/Show_progress.dart';

class ShowDataUser extends StatefulWidget {
  @override
  _ShowDataUserState createState() => _ShowDataUserState();
}

class _ShowDataUserState extends State<ShowDataUser> {
  // String uId;
  Info udata;
  bool load = true;

  var token;
  var userId;
  //connect server api
  Future<Void> _getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    userId = prefs.getInt('id');
    print('uId = $userId');
    print('token = $token');
    var url = '${Connectapi().domain}/getprofile/$userId';
    //conect
    var response = await http.get((url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    //check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      UsersMember members =
          UsersMember.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        udata = members.info;
        load = false;
      });
    }
  }

  Showprofileimg imagemember;

  Future<void> _getUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    userId = prefs.getInt('id');
    print('acId = $userId');
    print('token = $token');
    var url = '${Connectapi().domain}/getuserprofileimg/$userId';
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
    _getProfile();
    _getUserImage();
  }

  Future onGoBack(dynamic value) {
    setState(() {
      _getProfile();
      _getUserImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: AppBar(
          // iconTheme: IconThemeData(
          //   color: Theme.of(context).primaryColorDark,
          // ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              // bottom: Radius.circular(35),
            ),
          ),
          centerTitle: true,
          title: Text(
            'ข้อมูลส่วนตัว',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              // color: Theme.of(context).primaryColorDark,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                // color: Theme.of(context).primaryColorDark,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/eduser', arguments: {
                  'u_id': udata.uId,
                  //'u_user': udata.uUser,
                  //'u_pass': udata.uPass,
                  'u_name': udata.uName,
                  'u_lname': udata.uLname,
                  'u_old': udata.uOld,
                  'u_email': udata.uEmail,
                  'u_tel': udata.uTel,
                }).then((onGoBack));
                // print(udata.uId);
                print(udata.uName);
                print(udata.uLname);
                print(udata.uOld);
                print(udata.uEmail);
                print(udata.uTel);
              },
            )
          ],
          backgroundColor: Theme.of(context).primaryColorDark,
        ),
      ),
      body: load ? ShowProgress() : buildCenter(),
    );
  }

  Center buildCenter() {
    return Center(
      // child: Container(
      child: SingleChildScrollView(
        child: Column(
          // padding: EdgeInsets.all(30), // todo ระยะห่างจากขอบจอ !!
          children: [
            // SizedBox(height: 20),
            Container(
              height: 175,
              width: double.infinity,
              decoration: new BoxDecoration(
                  color: Theme.of(context).primaryColorDark,
                  // color: Colors.grey,
                  borderRadius: new BorderRadius.only(
                      bottomLeft: const Radius.circular(40.0),
                      bottomRight: const Radius.circular(40.0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ProfilePic(),
                ],
              )), //? -- > Profile Picture
            SizedBox(height: 10),
            Container(
              height: 520,
              decoration: new BoxDecoration(
                  // color: Theme.of(context).primaryColorDark,
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(40.0),
                      topRight: const Radius.circular(40.0))),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SizedBox(height: 20),
                        Text(
                          'ชื่อ - นามสกุล',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            // fontWeight: FontWeight.w700
                          ),
                        ),
                        Text(
                          '${udata.uName} ${udata.uLname}',
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Theme.of(context).primaryColorDark,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Divider(
                      height: 20,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'อายุ',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '${udata.uOld} ปี',
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Theme.of(context).primaryColorDark,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Divider(
                      height: 20,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'เบอร์โทร',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '${udata.uTel}',
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Theme.of(context).primaryColorDark,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Divider(
                      height: 20,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'อีเมล',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '${udata.uEmail}',
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Theme.of(context).primaryColorDark,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Divider(
                      height: 20,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // ),
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
            backgroundColor: Colors.transparent,
            radius: 60,
            child: DashedCircle(
              dashes: 5,
              gapSize: 7,
              // strokeWidth: 100,
              // color: Theme.of(context).primaryColorDark,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(600.0),
                  child: Container(
                    child: _checkSendRepairImage(imagemember.iuImg),
                    width: 150,
                    height: 150,
                  ),
                ),
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
