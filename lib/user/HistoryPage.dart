import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:userproject/model/ConnectAPI.dart';
import 'dart:convert' as convert;

import 'package:userproject/model/ShowAcJoinMember.dart';

class HistoryPage extends StatefulWidget {
  // const HistoryPage({Key key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Showactivityjoin> activitymember = [];
  var uId;
  var token;
  var _format = DateFormat('dd/MM/y');
  // var acId;

  Future<Void> _getUsAc() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    uId = prefs.getInt('id');
    // acId = prefs.getInt('ac_id');
    print('uId = $uId');
    print('token = $token');
    // print('acId = $acId');
    var url = '${Connectapi().domain}/joinuseractivity/$uId';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      ShowAcJoinMember member =
          ShowAcJoinMember.fromJson(convert.jsonDecode(response.body));

      setState(() {
        activitymember = member.showactivityjoin;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getUsAc();
  }

  Future onGoBack(dynamic value) {
    setState(() {
      _getUsAc();
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
            'ประวัติการเข้าร่วมกิจกรรม',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          backgroundColor: Theme.of(context).primaryColorDark,
        ),
      ),
      // backgroundColor: Colors.blue.shade50,
      body: Container(
        child: activitymember.length <= 0 ?
        Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Opacity(
                    //     opacity: 0.4,
                    //     child: Image.asset('assets/images/LoGo2.PNG')),
                    Text(
                      'ไม่มีประวัติที่เข้าร่วมกิจกรรม',
                      style: TextStyle(fontSize: 18, color: Colors.black38,fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ):
         GridView.builder(
            itemCount: activitymember.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: width / (height / 1.38)),
            // crossAxisCount: (GridView == Orientation.portrait) ? 2 : 2),
            itemBuilder: (context, index) {
              DateTime orDate = DateTime.parse('${activitymember[index].acDate}');
              DateTime orlDate =
                  DateTime.parse('${activitymember[index].acLdate}');
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/showhis', arguments: {
                    'j_id': activitymember[index].jId,
                    'ac_id': activitymember[index].acId,
                    'ac_name': activitymember[index].acName,
                    'ac_type': activitymember[index].acType,
                    'ac_time': activitymember[index].acTime,
                    'ac_date': activitymember[index].acDate,
                    'ac_ldate': activitymember[index].acLdate,
                    'ac_number': activitymember[index].acNumber,
                    // 'ac_numberjoin': activitymember[index].acNumberjoin,
                    'ac_home': activitymember[index].acHome,
                    'ac_sub': activitymember[index].acSub,
                    'ac_district': activitymember[index].acDistrict,
                    'ac_province': activitymember[index].acProvince,
                    'ac_detel': activitymember[index].acDetel,
                    'ac_la': activitymember[index].acLa,
                    'ac_long': activitymember[index].acLong,
                    'u_name': activitymember[index].uName,
                    'u_lname': activitymember[index].uLname,
                    'u_email': activitymember[index].uEmail,
                    'u_tel': activitymember[index].uTel,
                  }).then((onGoBack));
                  // .then((onGoBack));
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    elevation: 10,
                    color: Theme.of(context).cardColor,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          // leading: Icon(Icons.arrow_drop_down_circle),
                          title: Text(
                            '${activitymember[index].acName}',
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w800),
                          ),
                          subtitle: Text(
                            '(${activitymember[index].acType})',
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
                            child: _checkImage('${activitymember[index].imacImg}')),
                        ),

                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            '   ${activitymember[index].acDetel}',
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 12.0,
                              // fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor,
                              // color: Colors.black,
                            ),
                          ),
                        ),
              //         Padding(
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
              //           color: Colors.grey,
              //           // color: Colors.black,
              //         ),
              //       ),
              //       Text(
              //         '${activitymember[index].acNumber} คน',
              //         style: TextStyle(
              //           fontSize: 12.0,
              //           color: Colors.grey,
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
                                '${activitymember[index].acProvince}',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey,
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
                                  color: Colors.grey,
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
                                '${activitymember[index].acTime}น.',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey,
                                  // color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding:
                        //       EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     children: [
                        //       Text(
                        //         'วันสุดท้ายในการเข้าร่วม ',
                        //         style: TextStyle(
                        //           fontSize: 11.0,
                        //           color: Colors.grey,
                        //           fontStyle: FontStyle.italic,
                        //           // color: Colors.black,
                        //         ),
                        //       ),
                        //       Text(
                        //         '${_format.format(orlDate)}',
                        //         style: TextStyle(
                        //           fontSize: 11.0,
                        //           color: Colors.grey,
                        //           fontStyle: FontStyle.italic,
                        //           // color: Colors.black,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              );
            }),
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
