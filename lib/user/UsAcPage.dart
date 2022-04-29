import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:userproject/model/ActivityMember.dart';
import 'package:userproject/model/ConnectAPI.dart';

class UsAcPage extends StatefulWidget {
  // const UsAcPage({Key key}) : super(key: key);

  @override
  _UsAcPageState createState() => _UsAcPageState();
}

class _UsAcPageState extends State<UsAcPage> {
  List<Rows> datamember = [];
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
    var url = '${Connectapi().domain}/useractivity/$uId';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      ActivityMember member =
          ActivityMember.fromJson(convert.jsonDecode(response.body));

      setState(() {
        datamember = member.rows;
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
            'กิจกรรมของฉัน',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          backgroundColor: Theme.of(context).primaryColorDark,
        ),
      ),
      backgroundColor: Colors.blue.shade50,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/frmactivity');
        },
        child: Icon(CupertinoIcons.add),
        tooltip: 'เพิ่มกิจกรรม',
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      body: Container(
        child: datamember.length <= 0 ?
        Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Opacity(
                    //     opacity: 0.4,
                    //     child: Image.asset('assets/images/LoGo2.PNG')),
                    Text(
                      'ไม่มีกิจกรรมของคุณ',
                      style: TextStyle(fontSize: 18, color: Colors.black38,fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ):
         GridView.builder(
            itemCount: datamember.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: width / (height / 1.30)),
            // crossAxisCount: (GridView == Orientation.portrait) ? 2 : 2),
            itemBuilder: (context, index) {
              DateTime orDate = DateTime.parse('${datamember[index].acDate}');
                     DateTime orlDate = DateTime.parse('${datamember[index].acLdate}');
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/showusac', arguments: {
                    'ac_id': datamember[index].acId,
                    'ac_name': datamember[index].acName,
                    'ac_type': datamember[index].acType,
                    'ac_time': datamember[index].acTime,
                    'ac_date': datamember[index].acDate,
                    'ac_ldate': datamember[index].acLdate,
                    'ac_number': datamember[index].acNumber,
                    // 'ac_numberjoin': datamember[index].acNumberjoin,
                    'ac_home': datamember[index].acHome,
                    'ac_sub': datamember[index].acSub,
                    'ac_district': datamember[index].acDistrict,
                    'ac_province': datamember[index].acProvince,
                    'ac_detel': datamember[index].acDetel,
                    'ac_la': datamember[index].acLa,
                    'ac_long': datamember[index].acLong,
                  }).then((onGoBack));
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
                        // Padding(
                        //   padding: EdgeInsets.all(5.0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     children: [
                        //       Text(
                        //         '"${datamember[index].acName}"',
                        //         style: GoogleFonts.kanit(
                        //             fontSize: 16.0,
                        //             color: Theme.of(context).primaryColor,
                        //             fontWeight: FontWeight.w700),
                        //       ),
                        //       SizedBox(
                        //         width: 5,
                        //       ),
                        //       Text(
                        //         '(${datamember[index].acType})',
                        //         style: GoogleFonts.kanit(
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
                            '${datamember[index].acName}',
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w800),
                          ),
                          subtitle: Text(
                            '(${datamember[index].acType})',
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
                            child: _checkImage('${datamember[index].imacImg}')),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            '   ${datamember[index].acDetel}',
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
              //           color: Theme.of(context).primaryColorLight,
              //           // color: Colors.black,
              //         ),
              //       ),
              //       Text(
              //         '${datamember[index].acNumber} คน',
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
                                '${datamember[index].acProvince}',
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
                                '${datamember[index].acTime}น.',
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
                          padding:
                              EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
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
                                  fontSize: 11.0,
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
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
