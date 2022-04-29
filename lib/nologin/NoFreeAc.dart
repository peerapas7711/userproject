import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:userproject/model/ActivityMember.dart';
import 'dart:convert' as convert;

import 'package:userproject/model/ConnectAPI.dart';

class NoFreeAc extends StatefulWidget {
  const NoFreeAc({Key key}) : super(key: key);

  @override
  _NoFreeAcState createState() => _NoFreeAcState();
}

class _NoFreeAcState extends State<NoFreeAc> {
  List<Rows> datamember = [];
  List<Rows> _dataacti = [];
  // var uId;
  var token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IjEiLCJpYXQiOjE2MzQ2MDYwNzAsImV4cCI6MTYzNDY5MjQ3MH0.Xsqgs0Pxkb4WgaI1qxBHpnBXKaqHjct6cAmuE9GhKAo';
  var _format = DateFormat('dd/MM/y');

  //connect server api
  Future<Void> _getProfile() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // token = prefs.getString('token');
    // uId = prefs.getInt('id');
    // print('uId = $uId');
    print('token = $token');
    var url = '${Connectapi().domain}/showactivity';
    //conect
    var response = await http.get(url, headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    //check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      ActivityMember members =
          ActivityMember.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        datamember = members.rows;
        _dataacti = datamember;
        // print(_dataacti);
        // load = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //call _getAPI
    _getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.0),
        child: AppBar(
          // elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(35),
            ),
          ),
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 30, left: 15),
            child: Container(
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 30,
                  ),
                  // SizedBox(
                  //   width: 5,
                  // ),
                  _search(),
                  SizedBox(
                    width: 100,
                    height: 40,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      child: Text('เข้าสู่ระบบ',
                          style: TextStyle(color: Colors.white)),
                      color: Colors.greenAccent.shade700,
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          backgroundColor: Theme.of(context).primaryColorDark,
        ),
      ),
      body: buildCenter(),
    );
  }

  Center buildCenter() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
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
                      fontSize: 15.0,
                      color: Colors.red,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              top: 5,
            ),
            child: Row(
              children: [
                Text(
                  'กิจกรรมทั้งหมด',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          // _search(),
          Expanded(
            child: GridView.builder(
                itemCount: _dataacti.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    // crossAxisSpacing: 1,
                    // mainAxisSpacing: 2,
                    childAspectRatio: width / (height / 1.30)),
                // crossAxisCount: (GridView == Orientation.portrait) ? 2 : 2),
                itemBuilder: (context, index) {
                  return _listActivity(index);
                }),
          ),
        ],
      ),
    );
  }

  _search() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: SizedBox(
        width: 240,
        height: 60,
        child: TextField(
          style: TextStyle(color: Colors.white),
          // textAlign: TextAlign.start,
          cursorColor: Colors.white,
          decoration: InputDecoration(
            // hintMaxLines: 5,
            fillColor: Colors.white12,
            enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: Colors.white,
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(
                  color: Colors.white,
                )),
            hintText: 'ค้นหากิจกรรม',
            hintStyle: TextStyle(fontSize: 16.0, color: Colors.white),
            // labelStyle: TextStyle(color: Colors.white),
          ),
          onChanged: (text) {
            text = text.toLowerCase();
            setState(() {
              _dataacti = datamember.where((note) {
                var noteAc = note.acName.toLowerCase();
                return noteAc.contains(text);
              }).toList();
            });
          },
        ),
      ),
    );
  }

  _listActivity(index) {
    DateTime orDate = DateTime.parse('${_dataacti[index].acDate}');
    DateTime orlDate = DateTime.parse('${_dataacti[index].acLdate}');
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/nologshow', arguments: {
          'ac_id': _dataacti[index].acId,
          'ac_name': _dataacti[index].acName,
          'ac_type': _dataacti[index].acType,
          'ac_time': _dataacti[index].acTime,
          'ac_date': _dataacti[index].acDate,
          'ac_ldate': _dataacti[index].acLdate,
          'ac_number': _dataacti[index].acNumber,
          // 'ac_numberjoin': _dataacti[index].acNumberjoin,
          'ac_home': _dataacti[index].acHome,
          'ac_sub': _dataacti[index].acSub,
          'ac_district': _dataacti[index].acDistrict,
          'ac_province': _dataacti[index].acProvince,
          'ac_detel': _dataacti[index].acDetel,
          'ac_la': _dataacti[index].acLa,
          'ac_long': _dataacti[index].acLong,
          'u_name': _dataacti[index].uName,
          'u_lname': _dataacti[index].uLname,
          'u_email': _dataacti[index].uEmail,
          'u_tel': _dataacti[index].uTel,
          // 'u_img': _dataacti[index].uImg,
        });
      },
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Card(
          elevation: 7,
          color: Theme.of(context).cardColor,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              // Padding(
              //   padding: EdgeInsets.all(5.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       Text(
              //         '"${_dataacti[index].acName}"',
              //         style: TextStyle(
              //             fontSize: 16.0,
              //             color: Theme.of(context).primaryColor,
              //             fontWeight: FontWeight.w700),
              //       ),
              //       SizedBox(
              //         width: 5,
              //       ),
              //       Text(
              //         '(${_dataacti[index].acType})',
              //         style: TextStyle(
              //           fontSize: 14.0,
              //           color: Theme.of(context).primaryColor,
              //           //  color: Colors.black,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              ListTile(
                // leading: Icon(Icons.arrow_drop_down_circle),
                title: Text(
                  '${_dataacti[index].acName}',
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  '(${_dataacti[index].acType})',
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              // Image.asset(
              //   'assets/images/123.png',
              //   // color: Theme.of(context).primaryColor,
              //   width: 120,
              //   height: 100,
              // ),

              Container(
                width: 160,
                height: 100,
                child: ClipRRect(
                   borderRadius: BorderRadius.circular(8.0),
                  child: _checkImage('${_dataacti[index].imacImg}')),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  '   ${_dataacti[index].acDetel}',
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 12.0,
                    // fontStyle: FontStyle.italic,
                    // fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor,
                    // color: Colors.black,
                  ),
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(right: 5.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       Text(
              //         'คนเข้าร่วม : ',
              //         style: TextStyle(
              //           fontSize: 12.0,
              //           color: Theme.of(context).primaryColor,
              //           // color: Colors.black,
              //         ),
              //       ),
              //       Text(
              //         '0 / ',
              //         style: TextStyle(
              //           fontSize: 12.0,
              //           color: Theme.of(context).primaryColorLight,
              //           // color: Colors.black,
              //         ),
              //       ),
              //       Text(
              //         '${_dataacti[index].acNumber} คน',
              //         style: TextStyle(
              //           fontSize: 12.0,
              //           color: Theme.of(context).primaryColorLight,
              //           // color: Colors.black,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.only(right: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'จังหวัด ',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Theme.of(context).primaryColor,
                        // color: Colors.black,
                      ),
                    ),
                    Text(
                      '${_dataacti[index].acProvince}',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Theme.of(context).primaryColorLight,
                        // color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: 5.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'วันที่ ',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Theme.of(context).primaryColor,
                        // color: Colors.black,
                      ),
                    ),
                    Text(
                      '${_format.format(orDate)}',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Theme.of(context).primaryColorLight,
                        // color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'เวลา ',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Theme.of(context).primaryColor,
                        // color: Colors.black,
                      ),
                    ),
                    Text(
                      '${_dataacti[index].acTime}น.',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Theme.of(context).primaryColorLight,
                        // color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: 5.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'วันสุดท้ายในการเข้าร่วม ',
                      style: TextStyle(
                        fontSize: 11.0,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                        // color: Colors.black,
                      ),
                    ),
                    Text(
                      '${_format.format(orlDate)}',
                      style: TextStyle(
                        fontSize: 10.0,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                        // color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       Text(
              //         'เข้าร่วมได้',
              //         style: TextStyle(
              //             fontSize: 11.0, color: Colors.greenAccent.shade700
              //             // color: Colors.black,
              //             ),
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget _checkImage(imageName) {
    Widget child;
    print('Imagename : $imageName');
    if (imageName != null || imageName == '') {
      child = Image.network('${Connectapi().activityprofile}$imageName',fit: BoxFit.cover,);
      // load = false;
    } else {
      child = Image.asset('assets/images/noimg.png');
    }
    return new Container(child: child);
  }
}
