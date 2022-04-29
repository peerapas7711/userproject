import 'dart:ffi';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:userproject/model/CommentMember.dart';
import 'package:userproject/model/ConnectAPI.dart';

import 'dart:convert' as convert;

import 'package:userproject/model/CountJoinModel.dart';
import 'package:userproject/model/ImagesMember.dart';
import 'package:userproject/mywidget/Show_progress.dart';

class ShowHistoryPage extends StatefulWidget {
  @override
  _ShowHistoryPageState createState() => _ShowHistoryPageState();
}

class _ShowHistoryPageState extends State<ShowHistoryPage> {
  final _facid = GlobalKey<FormState>();
  var _facname;
  var _factype;
  var _factime;
  var _facdate;
  var _facldate;
  var _facnamber;
  var _facnumberjoin;
  var _fachome;
  var _facsub;
  var _facdistrict;
  var _facprovince;
  var _facdetel;
  var _funame;
  var _fulname;
  var _femail;
  var _ftel;

  CountJoin _countJoin;

  Map<String, dynamic> _rec_member;
  var _acId;
  var token;
  var idUser;
  var _format = DateFormat('dd/MM/y');
  var _datefor = DateFormat('dd/MM/y');

  Position userLocation;
  Set<Marker> _markers = {};
  double _lat, _lng;
  bool load = true;
  GoogleMapController mapController;

  Future<Null> findLatLan() async {
    Position position = await findPosition();
    setState(() {
      _lat = position.latitude;
      _lng = position.longitude;
      load = false;
    });
    print('lat = $_lat, lng = $_lng, load = $load');
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
          position: LatLng(_lat, _lng),
        ),
      );
    });
  }

  Future getprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    idUser = prefs.getInt('id');
    print('idUser = $idUser');
    print('token = $token');
  }

  // void _joinActivity(Map<String, dynamic> values) async {
  //   String url = '${Connectapi().domain}/joinac';
  //   var response = await http.post(url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: convert.jsonEncode(values));

  //   if (response.statusCode == 200) {
  //     print('Register Success');

  //     // Navigator.pop(context, true);
  //   } else {
  //     print('Register not Success!!');
  //     print(response.body);
  //   }
  // }

  var _joinId;

  // Future getjoinnum() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // token = prefs.getString('token');
  //   _joinId = prefs.getInt('jId');
  //   print('idJoin = $_joinId');
  //   print('token = $token');
  // }

  Future<void> _canceljoin() async {
    var url = '${Connectapi().domain}/canceljoin/$_joinId';
    // print(_joinId);
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

    List<Showcomment> commentmember = [];
//Show ความคิดเห็นทั้งหมด
  Future<void> _getComment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    idUser = prefs.getInt('id');
    print('acId = $idUser');
    print('token = $token');
    var url = '${Connectapi().domain}/showcomment/$_acId';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    //check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      CommentMember comment =
          CommentMember.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        commentmember = comment.showcomment;
        print(commentmember.length);
        // load = false;
      });
    }
  }


  List<Showactivitimg> imagemember = [];

  Future<void> _getAcImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    idUser = prefs.getInt('id');
    print('acId = $idUser');
    print('token = $token');
    var url = '${Connectapi().domain}/showactivitimg/$_acId';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    //check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      ImagesMembers images =
          ImagesMembers.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        imagemember = images.showactivitimg;
        print(imagemember.length);
        // load = false;
      });
    }
  }

  // void _showbar() {
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     content: Text(
  //       '\u2611 เข้าร่วมกิจกรรมสำเร็จ !',
  //       style: TextStyle(
  //         color: Colors.white,
  //         fontFamily: 'Kanit',
  //       ),
  //     ),
  //     backgroundColor: Colors.blue.shade800,
  //   ));
  // }

  Future<void> _countjoinMember() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    idUser = prefs.getInt('id');
    print('acId = $idUser');
    print('token = $token');
    var url = '${Connectapi().domain}/useractivitycount/$_acId';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    //check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      CountJoinModel countmember =
          CountJoinModel.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        _countJoin = countmember.countJoin;
        print(imagemember.length);
        load = false;
      });
    }
  }
  final _frmcomment = TextEditingController();

  Future getInfoActivity() {
    _rec_member = ModalRoute.of(context).settings.arguments;
    _joinId = _rec_member['j_id'];
    _acId = _rec_member['ac_id'];
    _facname = _rec_member['ac_name'];
    _factype = _rec_member['ac_type'];
    _factime = _rec_member['ac_time'];
    _facdate = _rec_member['ac_date'];
    _facldate = _rec_member['ac_ldate'];
    _facnamber = _rec_member['ac_number'];
    _facnumberjoin = _rec_member['ac_numberjoin'];
    _fachome = _rec_member['ac_home'];
    _facsub = _rec_member['ac_sub'];
    _facdistrict = _rec_member['ac_district'];
    _facprovince = _rec_member['ac_province'];
    _facdetel = _rec_member['ac_detel'];
    _lat = _rec_member['ac_la'];
    _lng = _rec_member['ac_long'];
    _funame = _rec_member['u_name'];
    _fulname = _rec_member['u_lname'];
    _femail = _rec_member['u_email'];
    _ftel = _rec_member['u_tel'];
    print(_acId);
    print(_joinId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAcImage();
    findLatLan();
    _countjoinMember();
    _getComment();
  }

  @override
  Widget build(BuildContext context) {
    getInfoActivity();
    getprefs();
    // getjoinnum();
    DateTime orDate = DateTime.parse(_facdate);
    DateTime orlDate = DateTime.parse(_facldate);
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
        // backgroundColor: Colors.black,
        
      ),
      backgroundColor: Theme.of(context).primaryColorDark,
      body: load ? ShowProgress() : buildCenter(),
      
    );
  }

  Widget _checkSendRepairImage(imageName) {
    Widget child;
    print('Imagename : $imageName');
    if (imageName != null) {
      child = Image.network('${Connectapi().imgmemberdomain}${imageName}',fit: BoxFit.cover,);
    } else {
      child = Image.asset('assets/images/noimg.jpg');
    }
    return new Container(child: child);
  }

  Widget _showber() {
    return Center(
      child: Flushbar(
        message: "ยกเลิกการเข้าร่วมแล้ว",
        icon: Icon(
          Icons.done,
          size: 28.0,
          color: Colors.white,
        ),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        duration: Duration(seconds: 1),
        // leftBarIndicatorColor: Colors.blue[300],
        backgroundColor: Colors.yellowAccent.shade700.withOpacity(0.8),
      )..show(context),
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
              // Expanded(
              //   flex: 0,
              //   child: Padding(
              //     padding:
              //         const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.end,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           "สมัครสมาชิก",
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 32,
              //             fontWeight: FontWeight.w500,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
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
                              left: 18, bottom: 18, right: 18, top: 10),
                          child: Center(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      height: 30,
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                        ),
                                        child: Text(
                                          'ดูรายงานจบกิจกรรม',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        color: Colors.greenAccent.shade700,
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, '/reporthistory',
                                              arguments: {
                                                '_acId': _acId,
                                                '_facname': _facname,
                                              });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
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
                                          color: Colors.black,
                                        )),
                                  ],
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  width: double.infinity,
                                  child: Swiper(
                                    autoplay: true,
                                    loop: true,
                                    pagination: SwiperPagination(
                                      margin: EdgeInsets.only(
                                       bottom: 5,
                                      ),
                                      builder: DotSwiperPaginationBuilder(
                                          color: Colors.white,activeColor: Colors.blue),
                                    ),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return
                                          // Container(
                                          //   child:
                                          ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        child: _checkSendRepairImage(
                                            imagemember[index].imImg),
                                      );
                                      // );
                                    },
                                    itemCount: imagemember.length,
                                    itemWidth: 300.0,
                                    layout: SwiperLayout.DEFAULT,
                                  ),
                                ),
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
                                    //     Border.all(color: Colors.black, width: 4),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade300,
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
                                              color: Colors.black,
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
                                              color: Colors.black,
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
                                        color: Colors.grey.shade300,
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
                                                  color:Colors.black,
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
                                                  color: Colors.black,
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
                                              color: Colors.black,
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
                                              color: Colors.black,
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
                                          //     return Container(
                                          //       margin: EdgeInsets.all(2),
                                          //       color: Colors.black45,
                                          //       height: 380,
                                          //       child: GoogleMap(
                                          //           markers: _markers,
                                          //           onMapCreated: _onMapCreated,
                                          //           initialCameraPosition:
                                          //               CameraPosition(
                                          //             target:
                                          //                 LatLng(_lat, _lng),
                                          //             zoom: 17,
                                          //           )),
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
                                            '${_lat},',
                                            // maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 11.0,
                                                color: Colors.grey),
                                          ),
                                          // SizedBox(width: 5,),
                                          Text(
                                            '${_lng}',
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
                                    Icon(Icons.person),
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
                                        color: Colors.grey.shade300,
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
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'คนเข้าร่วม : ',
                                            // maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            '${_countJoin.countJoin} คน',
                                            // maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      
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
                                            color: Colors.grey.shade300,
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
                                // Divider(
                                //   height: 20,
                                //   thickness: 1,
                                //   indent: 10,
                                //   endIndent: 10,
                                // ),
                                
                               
                                // Padding(
                                //   padding: EdgeInsets.only(
                                //     left: 20,
                                //     top: 5,
                                //   ),
                                //   child: Row(
                                //     children: [
                                //       Text(
                                //         'ความคิดเห็น',
                                //         style: TextStyle(
                                //             fontSize: 16.0,
                                //             color: Colors.black,
                                //             fontWeight: FontWeight.w500),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                // _commentShow(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
 

  Widget _commentShow() {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: commentmember.length,
      itemBuilder: (context, index) {
        DateTime orDate = DateTime.parse('${commentmember[index].comDate}');
        // DateTime orTime = DateTime.parse('${commentmember[index].comTime}');
        return Center(
          // widthFactor: 200,
          child: Padding(
            padding: EdgeInsets.all(3.0),
            child: Card(
              elevation: 2,
              color: Colors.grey.shade300,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(3),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon(
                          //   Icons.portrait,
                          //   size: 30,
                          // ),
                          CircleAvatar(
                            radius: 18,
                            child: ClipRRect(
                              child: Container(
                                color: Colors.yellow.shade50,
                                child: _checkSendRepairImageUser(
                                    '${commentmember[index].iuImg}'),
                                width: 150,
                                height: 150,
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          // CircleAvatar(
                          //   radius: 18,
                          //   child: ClipRRect(
                          //     child: Container(
                          //       color: Colors.white,
                          //       child: Image.asset('assets/images/person.png',color: Colors.black,),
                          //       width: 150,
                          //       height: 150,
                          //     ),
                          //     borderRadius: BorderRadius.circular(100),
                          //   ),
                          // ),
                          Text(
                            '  ${commentmember[index].uName}  ${commentmember[index].uLname}',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              // color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Text(
                            '${commentmember[index].comMessage}',
                            maxLines: 10,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontStyle: FontStyle.italic,
                              // fontWeight: FontWeight.w500,
                              color: Colors.black,
                              // color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_datefor.format(orDate)}',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey,
                              // color: Colors.black,
                            ),
                          ),
                          Text(
                            ' ${commentmember[index].comTime}',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey,
                              // color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
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

}
