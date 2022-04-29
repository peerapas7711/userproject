import 'dart:ffi';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
// import 'package:like_button/like_button.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:userproject/model/CommentMember.dart';
import 'package:userproject/model/ConnectAPI.dart';

import 'dart:convert' as convert;

import 'package:userproject/model/CountJoinModel.dart';
import 'package:userproject/model/ImagesMember.dart';
import 'package:userproject/model/ProfileMember.dart';
import 'package:userproject/model/UserCountJoinMember.dart';
import 'package:userproject/mywidget/Show_progress.dart';

class NoLogShowAc extends StatefulWidget {
  @override
  _NoLogShowAcState createState() => _NoLogShowAcState();
}

class _NoLogShowAcState extends State<NoLogShowAc> {
  // var _joinY = 'เข้าร่วมได้';
  // var _joinN = 'เข้าร่วมไม่ได้';

  final _facid = GlobalKey<FormState>();
  var _facname;
  var _factype;
  var _factime;
  var _facdate;
  var _facldate;
  var _facnamber;
  // var _facnumberjoin;
  var _fachome;
  var _facsub;
  var _facdistrict;
  var _facprovince;
  var _facdetel;
  var _funame;
  var _fulname;
  var _femail;
  var _ftel;
  // var _fuimg;

  Map<String, dynamic> _rec_member;
  var _acId;
  // var token;
  var token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IjEiLCJpYXQiOjE2MzM5NTU2NzYsImV4cCI6MTYzNDA0MjA3Nn0.wk_Jyw4P9P5Ls8PB95GvGPyzj91Q6h-_8xRLlh_8iCM';
  var idUser;
  var _format = DateFormat('dd/MM/y');
  var _datefor = DateFormat('dd/MM/y');
  // var _timefor = DateFormat('HH:mm น.');

  Position userLocation;
  Set<Marker> _markers = {};
  double _aclat, _aclng;
  bool load = true;
  GoogleMapController mapController;

  Future<Null> findLatLan() async {
    Position position = await findPosition();
    setState(() {
      _aclat = position.latitude;
      _aclng = position.longitude;
      load = false;
    });
    print('lat = $_aclat, lng = $_aclng, load = $load');
  }

  Future<Position> findPosition() async {
    try {
      userLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      userLocation = null;
    }
    return userLocation;
  }

  void _onMapCreated(GoogleMapController controller) {
    // controller.setMapStyle(Utils.mapStyle);
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('id'),
          position: LatLng(_aclat, _aclng),
          infoWindow: InfoWindow(
              title: '${_facname}',
              snippet:
                  '${_fachome} ${_facsub} ${_facdistrict} ${_facprovince}'),
        ),
      );
    });
  }

  // infoWindow: InfoWindow(
  //               title: '${_facname}',
  //               snippet:
  //                   '${_fachome} ${_facsub} ${_facdistrict} ${_facprovince}')),

  // Future getprefs() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   token = prefs.getString('token');
  //   idUser = prefs.getInt('id');
  //   print('idUser = $idUser');
  //   print('token = $token');
  // }

  //ถูกใจกิจกรรม
  void _followActivity(Map<String, dynamic> values) async {
    String url = '${Connectapi().domain}/followac';
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: convert.jsonEncode(values));

    if (response.statusCode == 200) {
      print('Register Success');

      // Navigator.pop(context, true);
    } else {
      print('Register not Success!!');
      print(response.body);
    }
  }

//เข้าร่วมกิจกรรม
  void _joinActivity(Map<String, dynamic> values) async {
    String url = '${Connectapi().domain}/joinac';
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: convert.jsonEncode(values));

    if (response.statusCode == 200) {
      print('Register Success');

      // Navigator.pop(context, true);
    } else {
      print('Register not Success!!');
      print(response.body);
    }
  }

  final _frmcomment = TextEditingController();

//แสดงความคิดเห็น
  void _comment(Map<String, dynamic> values) async {
    String url = '${Connectapi().domain}/addcomment/$idUser';
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: convert.jsonEncode(values));

    if (response.statusCode == 200) {
      print('Register Success');

      // Navigator.pop(context, true);
    } else {
      print('Register not Success!!');
      print(response.body);
    }
  }

//   List<Showcomment> commentmember = [];
// //Show ความคิดเห็นทั้งหมด
//   Future<void> _getComment() async {
//     // SharedPreferences prefs = await SharedPreferences.getInstance();
//     // token = prefs.getString('token');
//     // idUser = prefs.getInt('id');
//     print('acId = $idUser');
//     print('token = $token');
//     var url = '${Connectapi().domain}/showcomment/$_acId';
//     //conect
//     var response = await http.get(Uri.parse(url), headers: {
//       'Connect-type': 'application/json',
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token',
//     });
//     //check response
//     if (response.statusCode == 200) {
//       //แปลงjson ให้อยู่ในรูปแบบ model members
//       CommentMember comment =
//           CommentMember.fromJson(convert.jsonDecode(response.body));
//       //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
//       setState(() {
//         commentmember = comment.showcomment;
//         print(commentmember.length);
//         // load = false;
//       });
//     }
//   }

  Showprofileimg userimagemember;

  Future<void> _getUserImage() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // token = prefs.getString('token');
    // idUser = prefs.getInt('id');
    print('acId = $idUser');
    print('token = $token');
    var url = '${Connectapi().domain}/getuserprofileimg/$idUser';
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
        userimagemember = images.showprofileimg;
        // print(imagemember.length);
        // load = false;
      });
    }
  }

  // List<Showactivitimg> imagemember = [];

  // Future<void> _getAcImage() async {
  //   // SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // token = prefs.getString('token');
  //   // idUser = prefs.getInt('id');
  //   print('acId = $idUser');
  //   print('token = $token');
  //   var url = '${Connectapi().domain}/showactivitimg/$_acId';
  //   //conect
  //   var response = await http.get(Uri.parse(url), headers: {
  //     'Connect-type': 'application/json',
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer $token',
  //   });
  //   //check response
  //   if (response.statusCode == 200) {
  //     //แปลงjson ให้อยู่ในรูปแบบ model members
  //     ImagesMembers images =
  //         ImagesMembers.fromJson(convert.jsonDecode(response.body));
  //     //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
  //     setState(() {
  //       imagemember = images.showactivitimg;
  //       print(imagemember.length);
  //       // load = false;
  //     });
  //   }
  // }

//   CountJoin _countJoin;

// //จำนวนคนเข้าร่วม
//   Future<void> _countjoinMember() async {
//     // SharedPreferences prefs = await SharedPreferences.getInstance();
//     // token = prefs.getString('token');
//     // idUser = prefs.getInt('id');
//     print('acId = $idUser');
//     print('token = $token');
//     var url = '${Connectapi().domain}/useractivitycount/$_acId';
//     //conect
//     var response = await http.get(Uri.parse(url), headers: {
//       'Connect-type': 'application/json',
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token',
//     });
//     //check response
//     if (response.statusCode == 200) {
//       //แปลงjson ให้อยู่ในรูปแบบ model members
//       CountJoinModel countmember =
//           CountJoinModel.fromJson(convert.jsonDecode(response.body));
//       //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
//       setState(() {
//         _countJoin = countmember.countJoin;
//         // print(imagemember.length);
//         load = false;
//       });
//     }
//   }

  // CountJoinUser _countJoinUser;

  // //!เช็คว่าเข้าร่วมยัง
  // Future<void> _countjoinUserChack() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   token = prefs.getString('token');
  //   idUser = prefs.getInt('id');
  //   print('acId = $idUser');
  //   print('token = $token');
  //   var url = '${Connectapi().domain}/useractivitycountjoin/$_acId';
  //   //conect
  //   var response = await http.get(Uri.parse(url), headers: {
  //     'Connect-type': 'application/json',
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer $token',
  //   });
  //   //check response
  //   if (response.statusCode == 200) {
  //     //แปลงjson ให้อยู่ในรูปแบบ model members
  //     UserCountJoinMember countmemberUser =
  //         UserCountJoinMember.fromJson(convert.jsonDecode(response.body));
  //     //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
  //     setState(() {
  //       _countJoinUser = countmemberUser.countJoinUser;
  //       print("mak = ${_countJoinUser.countJoinUser}");
  //       load = false;
  //     });
  //   }
  // }

  Future getInfoActivity() {
    _rec_member = ModalRoute.of(context).settings.arguments;
    _acId = _rec_member['ac_id'];
    _facname = _rec_member['ac_name'];
    _factype = _rec_member['ac_type'];
    _factime = _rec_member['ac_time'];
    _facdate = _rec_member['ac_date'];
    _facldate = _rec_member['ac_ldate'];
    _facnamber = _rec_member['ac_number'];
    // _facnumberjoin = _rec_member['ac_numberjoin'];
    _fachome = _rec_member['ac_home'];
    _facsub = _rec_member['ac_sub'];
    _facdistrict = _rec_member['ac_district'];
    _facprovince = _rec_member['ac_province'];
    _facdetel = _rec_member['ac_detel'];
    _aclat = _rec_member['ac_la'];
    _aclng = _rec_member['ac_long'];
    _funame = _rec_member['u_name'];
    _fulname = _rec_member['u_lname'];
    _femail = _rec_member['u_email'];
    _ftel = _rec_member['u_tel'];

    // _fuimg = _rec_member['u_img'];
    print(_acId);
  }

  Future onGoBack(dynamic value) {
    setState(() {
      getInfoActivity();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _getAcImage();
    findLatLan();
    // _countjoinMember();
    // _getComment();
    _getUserImage();
    // _countjoinUserChack();
  }

  @override
  Widget build(BuildContext context) {
    getInfoActivity();
    // getprefs();

    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text(
          'ข้อมูลกิจกรรม',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColorDark,
      body: load ? ShowProgress() : buildCenter(),
    );
  }

  Center buildCenter() {
    DateTime orDate = DateTime.parse(_facdate);
    DateTime orlDate = DateTime.parse(_facldate);
    return Center(
      child: Container(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 8,
              ),
              Expanded(
                // shrinkWrap: true,
                flex: 6,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      // color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                  // child: Padding(
                  //   padding: const EdgeInsets.all(25),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              left: 10, bottom: 10, right: 10, top: 10),
                          child: Center(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.warning,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                      Text(
                                        'ถ้าต้องการเข้าร่วมกิจกรรมต้องเข้าสู่ระบบก่อน',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.red,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      TextButton(
                                        child: Text(
                                          "เข้าสู่ระบบ",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              decoration:
                                                  TextDecoration.underline),
                                        ),
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, '/login');
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                // SizedBox(
                                //   height: 10,
                                // ),
                                Text(
                                  '${_facname}',
                                  // maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text('ประเภท : ',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                        )),
                                    Text('${_factype}',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                        )),
                                  ],
                                ),
                                Container(
                                  // color: Colors.black,
                                  width: 500,
                                  height: 250,
                                  child: Image.asset(
                                    'assets/images/noimg.jpg',
                                    // color: Theme.of(context).primaryColor,
                                    // width: 500,
                                    // height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                // Container(
                                //   height:
                                //       MediaQuery.of(context).size.height * 0.3,
                                //   width: double.infinity,
                                //   child: Swiper(
                                //     // autoplay: true,
                                //     // loop: true,
                                //     pagination: SwiperPagination(
                                //       margin: EdgeInsets.only(
                                //         bottom: 5,
                                //       ),
                                //       builder: DotSwiperPaginationBuilder(
                                //           color: Colors.white,
                                //           activeColor: Colors.blue),
                                //     ),
                                //     itemBuilder:
                                //         (BuildContext context, int index) {
                                //       return
                                //           // Container(
                                //           //   child:
                                //           ClipRRect(
                                //         borderRadius:
                                //             BorderRadius.circular(5.0),
                                //         child: _checkSendRepairImage(
                                //             imagemember[index].imImg),
                                //       );
                                //       // );
                                //     },
                                //     itemCount: imagemember.length,
                                //     itemWidth: 300.0,
                                //     layout: SwiperLayout.DEFAULT,
                                //   ),
                                // ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.error),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'รายละเอียด',
                                      // maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        // fontStyle: FontStyle.italic
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${_facdetel}',
                                  // maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    color: Colors.black,
                                    // fontStyle: FontStyle.italic,
                                  ),
                                ),
                                Divider(
                                  height: 30,
                                  thickness: 1,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.timelapse),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'วันเวลาการทำกิจกรรม',
                                      // maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 390,
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    // border:
                                    //     Border.all(color: Colors.black, width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.shade50,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'วันที่ : ',
                                            // maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            '${_format.format(orDate)}',
                                            // maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          Text(
                                            'เวลา : ',
                                            // maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            '${_factime}น.',
                                            // maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // SizedBox(width: 18,),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'วันสุดท้ายในการเข้าร่วมกิจกรรม : ',
                                        // maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 15.0, color: Colors.grey),
                                      ),
                                      Text(
                                        '${_format.format(orlDate)}',
                                        // maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 15.0, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.maps_home_work),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'สถานที่ทำกิจกรรม',
                                      // maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),

                                Container(
                                  width: 390,
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    // border:
                                    //     Border.all(color: Colors.black, width: 4),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.shade50,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'บ้าน : ',
                                                // maxLines: 2,
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                              Text(
                                                '${_fachome}',
                                                // maxLines: 2,
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Theme.of(context)
                                                      .primaryColorLight,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'ตำบล : ',
                                                // maxLines: 2,
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                ),
                                              ),
                                              Text(
                                                '${_facsub}',
                                                // maxLines: 2,
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Theme.of(context)
                                                      .primaryColorLight,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'อำเภอ : ',
                                            // maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            '${_facdistrict}',
                                            // maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          Text(
                                            'จังหวัด : ',
                                            // maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            '${_facprovince}',
                                            // maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // SizedBox(
                                //       width: 8,
                                //     ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: SizedBox(
                                        width: 145,
                                        height: 25,
                                        child: RaisedButton.icon(
                                          // onPressed: () {
                                          //   Navigator.push(context,
                                          //       MaterialPageRoute(
                                          //           builder: (context) {
                                          //     return Card(
                                          //       child: Stack(
                                          //         children: [
                                          //           Container(
                                          //             margin: EdgeInsets.all(2),
                                          //             color: Colors.black45,
                                          //             height: double.infinity,
                                          //             child: GoogleMap(
                                          //                 markers: _markers,
                                          //                 onMapCreated:
                                          //                     _onMapCreated,
                                          //                 initialCameraPosition:
                                          //                     CameraPosition(
                                          //                   target: LatLng(
                                          //                       _aclat, _aclng),
                                          //                   zoom: 17,
                                          //                 )),
                                          //           ),
                                          //           SafeArea(
                                          //             child: Padding(
                                          //               // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                          //               padding:
                                          //                   const EdgeInsets
                                          //                           .only(
                                          //                       left: 16,
                                          //                       top: 6),
                                          //               child: Row(
                                          //                 mainAxisAlignment:
                                          //                     MainAxisAlignment
                                          //                         .spaceBetween,
                                          //                 crossAxisAlignment:
                                          //                     CrossAxisAlignment
                                          //                         .start,
                                          //                 children: <Widget>[
                                          //                   InkWell(
                                          //                     borderRadius:
                                          //                         BorderRadius
                                          //                             .circular(
                                          //                                 50),
                                          //                     onTap: () {
                                          //                       Navigator.pop(
                                          //                           context);
                                          //                     },
                                          //                     child: Row(
                                          //                       children: [
                                          //                         Container(
                                          //                           width: 30,
                                          //                           height: 30,
                                          //                           decoration:
                                          //                               BoxDecoration(
                                          //                             borderRadius:
                                          //                                 BorderRadius.circular(
                                          //                                     30),
                                          //                             color: Theme.of(
                                          //                                     context)
                                          //                                 .primaryColorDark,
                                          //                             // color: Colors.white70,
                                          //                           ),
                                          //                           child: Icon(
                                          //                             CupertinoIcons
                                          //                                 .arrow_left_circle,
                                          //                             size: 30,
                                          //                             color: Colors
                                          //                                 .white,
                                          //                           ),
                                          //                         ),
                                          //                         SizedBox(
                                          //                           width: 5,
                                          //                         ),
                                          //                         Text(
                                          //                           'กลับ',
                                          //                           style: TextStyle(
                                          //                               fontSize:
                                          //                                   18,
                                          //                               fontWeight:
                                          //                                   FontWeight.w500),
                                          //                         ),
                                          //                       ],
                                          //                     ),
                                          //                   ),
                                          //                 ],
                                          //               ),
                                          //             ),
                                          //           ),
                                          //         ],
                                          //       ),
                                          //     );
                                          //   }));
                                          // },
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20),
                                            ),
                                          ),
                                          label: Text(
                                            'การนำทาง',
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Theme.of(context)
                                                    .canvasColor,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          icon: Icon(
                                            Icons.gps_fixed_sharp,
                                            size: 20,
                                            color:
                                                Theme.of(context).canvasColor,
                                          ),
                                          splashColor: Colors.white,
                                          color: Colors.red,
                                          // elevation: 10,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${_aclat},',
                                            // maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 11.0,
                                                color: Colors.grey),
                                          ),
                                          // SizedBox(width: 5,),
                                          Text(
                                            '${_aclng}',
                                            // maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 11.0,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Icon(CupertinoIcons.person_2_fill),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'จำนวนคนที่ต้องการ',
                                      // maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 390,
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    // border:
                                    //     Border.all(color: Colors.black, width: 4),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.shade50,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'จำนวน : ',
                                            // maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            '${_facnamber} คน',
                                            // maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Row(
                                      //   children: [
                                      //     Text(
                                      //       'คนเข้าร่วม : ',
                                      //       // maxLines: 2,
                                      //       style: TextStyle(
                                      //         fontSize: 15.0,
                                      //       ),
                                      //     ),
                                      //     Text(
                                      //       '${_countJoin.countJoin} คน',
                                      //       // maxLines: 2,
                                      //       style: TextStyle(
                                      //         fontSize: 16.0,
                                      //         color: Colors.green,
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  height: 3,
                                ),

                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.,
                                  children: [
                                    Container(
                                      width: 250,
                                      padding: EdgeInsets.all(5),
                                      margin: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        // border:
                                        //     Border.all(color: Colors.black, width: 4),
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blue.shade50,
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(CupertinoIcons
                                                  .profile_circled),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                'ผู้สร้างกิจกรรม',
                                                // maxLines: 2,
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'ชื่อ : ',
                                                // maxLines: 2,
                                                style: TextStyle(
                                                  fontSize: 13.0,
                                                ),
                                              ),
                                              Text(
                                                '${_funame}  ',
                                                // maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                '${_fulname}',
                                                // maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'อีเมล : ',
                                                // maxLines: 2,
                                                style: TextStyle(
                                                  fontSize: 13.0,
                                                ),
                                              ),
                                              Text(
                                                '${_femail}',
                                                // maxLines: 2,
                                                style: TextStyle(
                                                  fontSize: 13.0,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'เบอร์โทร : ',
                                                // maxLines: 2,
                                                style: TextStyle(
                                                  fontSize: 13.0,
                                                ),
                                              ),
                                              Text(
                                                '${_ftel}',
                                                // maxLines: 2,
                                                style: TextStyle(
                                                  fontSize: 13.0,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                Divider(
                                  height: 20,
                                  thickness: 1,
                                  indent: 10,
                                  endIndent: 10,
                                ),
                                // Form(key: _facid, child: faccomment()),
                                // SizedBox(
                                //   width: 10,
                                // ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    top: 5,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        'ความคิดเห็น',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'ไม่สามารถดูความคิดเห็นได้',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),

                                // _commentShow(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //
                  // ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget faccomment() {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Row(
  //       children: [
  //         SizedBox(
  //           width: 290,
  //           // height: 40,
  //           child: TextFormField(
  //             style: TextStyle(),
  //             maxLines: 3,
  //             controller: _frmcomment,
  //             // obscureText: obsureText,
  //             decoration: InputDecoration(
  //               // labelText: 'แสดงความคิดเห็น',
  //               hintText: 'แสดงความคิดเห็น',
  //               contentPadding:
  //                   EdgeInsets.symmetric(vertical: 0, horizontal: 10),
  //               enabledBorder: OutlineInputBorder(
  //                 borderSide: BorderSide(
  //                   color: Colors.black,
  //                 ),
  //               ),
  //               border: OutlineInputBorder(
  //                 borderSide: BorderSide(color: Colors.red.shade800),
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //             ),
  //           ),
  //         ),
  //         // SizedBox(width: 5,),
  //         IconButton(
  //           icon: Icon(
  //             Icons.send_rounded,
  //             size: 25,
  //           ),
  //           onPressed: () {
  //             // Navigator.pushNamedAndRemoveUntil(
  //             //     context, '/home', (route) => false);

  //             // .then((onGoBack))
  //             Map<String, dynamic> valuse = Map();
  //             valuse['u_id'] = idUser;
  //             valuse['ac_id'] = _acId;
  //             valuse['com_message'] = _frmcomment.text;

  //             print(valuse);
  //             _comment(valuse);
  //             setState(() {
  //               _getComment();
  //             });
  //             _facid.currentState.reset();
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _commentShow() {
  //   return Container(
  //     child: commentmember.length <= 0
  //         ? Padding(
  //             padding: const EdgeInsets.only(top: 20),
  //             child: Text('ไม่สามารถดูความคิดเห็นได้'),
  //           )
  //         : ListView.builder(
  //             primary: false,
  //             shrinkWrap: true,
  //             itemCount: commentmember.length,
  //             itemBuilder: (context, index) {
  //               DateTime orDate =
  //                   DateTime.parse('${commentmember[index].comDate}');
  //               // DateTime orTime = DateTime.parse('${commentmember[index].comTime}');
  //               return Center(
  //                 // widthFactor: 200,
  //                 child: Padding(
  //                   padding: EdgeInsets.all(3.0),
  //                   child: Card(
  //                     elevation: 2,
  //                     color: Colors.lightBlue.shade50,
  //                     clipBehavior: Clip.antiAlias,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(10),
  //                     ),
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.start,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Padding(
  //                             padding: EdgeInsets.all(3),
  //                             child: Row(
  //                               // mainAxisAlignment: MainAxisAlignment.start,
  //                               // crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 // Icon(
  //                                 //   Icons.portrait,
  //                                 //   size: 30,
  //                                 // ),
  //                                 CircleAvatar(
  //                                   radius: 18,
  //                                   child: ClipRRect(
  //                                     child: Container(
  //                                       color: Colors.yellow.shade50,
  //                                       child: _checkSendRepairImageUser(
  //                                           '${commentmember[index].iuImg}'),
  //                                       width: 150,
  //                                       height: 150,
  //                                     ),
  //                                     borderRadius: BorderRadius.circular(100),
  //                                   ),
  //                                 ),
  //                                 // CircleAvatar(
  //                                 //   radius: 18,
  //                                 //   child: ClipRRect(
  //                                 //     child: Container(
  //                                 //       color: Colors.white,
  //                                 //       child: Image.asset('assets/images/person.png',color: Colors.black,),
  //                                 //       width: 150,
  //                                 //       height: 150,
  //                                 //     ),
  //                                 //     borderRadius: BorderRadius.circular(100),
  //                                 //   ),
  //                                 // ),
  //                                 Text(
  //                                   '  ${commentmember[index].uName}  ${commentmember[index].uLname}',
  //                                   style: TextStyle(
  //                                     fontSize: 14.0,
  //                                     color: Colors.black,
  //                                     // color: Colors.black,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                           Column(
  //                             mainAxisAlignment: MainAxisAlignment.start,
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Padding(
  //                                 padding: EdgeInsets.all(3.0),
  //                                 child: Text(
  //                                   '${commentmember[index].comMessage}',
  //                                   maxLines: 10,
  //                                   style: TextStyle(
  //                                     fontSize: 14.0,
  //                                     fontStyle: FontStyle.italic,
  //                                     // fontWeight: FontWeight.w500,
  //                                     color:
  //                                         Theme.of(context).primaryColorLight,
  //                                     // color: Colors.black,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           Padding(
  //                             padding: EdgeInsets.all(3.0),
  //                             child: Row(
  //                               mainAxisAlignment: MainAxisAlignment.start,
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 Text(
  //                                   '${_datefor.format(orDate)}',
  //                                   style: TextStyle(
  //                                     fontSize: 12.0,
  //                                     color: Colors.grey,
  //                                     // color: Colors.black,
  //                                   ),
  //                                 ),
  //                                 Text(
  //                                   ' ${commentmember[index].comTime}',
  //                                   style: TextStyle(
  //                                     fontSize: 12.0,
  //                                     color: Colors.grey,
  //                                     // color: Colors.black,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             },
  //           ),
  //   );
  // }

  // Widget _checkBody(count) {
  //   Widget child;
  //   print('count : $count');
  //   if (count == 0) {
  //     child = Scaffold(
  //       body: load ? ShowProgress() : buildCenter(),
  //       floatingActionButton: FloatingActionButton.extended(
  //         onPressed: () {
  //           if (_countJoin.countJoin < _facnamber) {
  //             Navigator.pushNamedAndRemoveUntil(
  //                 context, '/home', (route) => false);
  //             Map<String, dynamic> valuse = Map();
  //             valuse['u_id'] = idUser;
  //             valuse['ac_id'] = _acId;
  //             print(valuse);
  //             _joinActivity(valuse);
  //             _showber();
  //           } else {
  //             _showbernot();
  //           }
  //         },
  //         label: Text(
  //           "เข้าร่วมกิจกรรม",
  //           style: TextStyle(),
  //         ),
  //         backgroundColor: Theme.of(context).primaryColorDark,
  //         // icon: Icon(Icons.save,),
  //       ),
  //     );
  //   } else {
  //     child = load ? ShowProgress() : buildCenter();
  //   }
  //   return new Container(child: child);
  // }

  Widget _checkSendRepairImage(imageName) {
    Widget child;
    print('Imagename : $imageName');
    if (imageName != null) {
      child = Image.network(
        '${Connectapi().imgmemberdomain}${imageName}',
        fit: BoxFit.cover,
      );
    } else {
      child = Image.asset('assets/images/noimg.jpg');
    }
    return new Container(child: child);
  }

  Widget _checkSendRepairImageUser(imageName) {
    Widget child;
    print('Imagename : $imageName');
    if (imageName != null) {
      child = Image.network('${Connectapi().userprofile}${imageName}',
          fit: BoxFit.cover);
    } else {
      child = Image.asset('assets/images/noimg.jpg');
    }
    return new Container(child: child);
  }

  Widget _showber() {
    return Center(
      child: Flushbar(
        message: "เข้าร่วมกิจกรรมแล้ว",
        icon: Icon(
          Icons.done,
          size: 28.0,
          color: Colors.white,
        ),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        duration: Duration(seconds: 1),
        // leftBarIndicatorColor: Colors.blue[300],
        backgroundColor: Colors.blueAccent.shade700.withOpacity(0.8),
      )..show(context),
    );
  }

  Widget _showbernot() {
    return Center(
      child: Flushbar(
        message: "ไม่สามารถเข้าร่วมได้",
        icon: Icon(
          Icons.clear,
          size: 28.0,
          color: Colors.white,
        ),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        duration: Duration(seconds: 1),
        // leftBarIndicatorColor: Colors.blue[300],
        backgroundColor: Colors.redAccent.shade700.withOpacity(0.8),
      )..show(context),
    );
  }

  Widget _showberlike() {
    return Center(
      child: Flushbar(
        message: "ถูกใจกิจกรรมแล้ว",
        icon: Icon(
          Icons.done,
          size: 28.0,
          color: Colors.white,
        ),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        duration: Duration(seconds: 1),
        // leftBarIndicatorColor: Colors.blue[300],
        backgroundColor: Colors.black.withOpacity(0.8),
      )..show(context),
    );
  }
}
