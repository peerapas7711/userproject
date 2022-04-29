import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userproject/model/ConnectAPI.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:userproject/model/ReportImgMember.dart';
import 'package:userproject/model/ReportMember.dart';
import 'package:userproject/mywidget/Show_progress.dart';

class ReportHistoryPage extends StatefulWidget {
  @override
  _ReportHistoryPageState createState() => _ReportHistoryPageState();
}

class _ReportHistoryPageState extends State<ReportHistoryPage> {
  var acId;
  var token;
  var _facname;
  bool load = true;

  List<Reportinfo> reportactivitymember;

  Future<Void> _getUsAc() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // acId = prefs.getInt('id');
    // acId = prefs.getInt('ac_id');
    // print('acId = $acId');
    print('token = $token');
    // print('acId = $acId');
    var url = '${Connectapi().domain}/getreportactivity/$acId';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      ReportMember member =
          ReportMember.fromJson(convert.jsonDecode(response.body));

      setState(() {
        reportactivitymember = member.reportinfo;
        load = false;
      });
    }
  }

  List<Showreportactivitimg> reportimagemember = [];

  Future<void> _getAcImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // acId = prefs.getInt('id');
    // print('acId = $acId');
    print('token = $token');
    var url = '${Connectapi().domain}/showreportactivitimg/$acId';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    //check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      ReportImgMember images =
          ReportImgMember.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        reportimagemember = images.showreportactivitimg;
        print(reportimagemember.length);
        // load = false;
      });
    }
  }

  Map<String, dynamic> _rec_member;
  Future getInfoActivity() {
    _rec_member = ModalRoute.of(context).settings.arguments;
    acId = _rec_member['_acId'];
    _facname = _rec_member['_facname'];
    // _fuimg = _rec_member['u_img'];
    print(acId);
  }

  @override
  void initState() {
    super.initState();
    _getUsAc();
    _getAcImage();
  }

  Future onGoBack(dynamic value) {
    setState(() {
      _getUsAc();
      _getAcImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    getInfoActivity();
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
            'รายงานจบกิจกรรม',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          backgroundColor: Theme.of(context).primaryColorDark,
        ),
      ),
      body: load ? ShowProgress() : buildCenter(),
      
    );
  }

  Center buildCenter() {
    return Center(
      child: Container(
        child: reportactivitymember.length <= 0
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Opacity(
                    //     opacity: 0.4,
                    //     child: Image.asset('assets/images/LoGo2.PNG')),
                    Text(
                      'ยังไม่มีรายงานจบกิจกรรม',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black38,
                          fontWeight: FontWeight.w600),
                    ),
                    
                  ],
                ),
              )
            : 
            ListView.builder(
                itemCount: reportactivitymember.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Column(
                          children: [
                            Text(
                              '$_facname',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                          Row(
                            children: [
                              Text(
                                'รูปภาพการทำกิจกรรม : ',
                                style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          SizedBox(height: 3,),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: double.infinity,
                            child: Swiper(
                              autoplay: true,
                              loop: true,
                              pagination: SwiperPagination(
                                margin: EdgeInsets.only(
                                  bottom: 5,
                                ),
                                builder: DotSwiperPaginationBuilder(
                                    color: Colors.white, activeColor: Colors.blue),
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return
                                    // Container(
                                    //   child:
                                    ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: _checkImage(
                                      reportimagemember[index].reimgImg),
                                );
                                // );
                              },
                              itemCount: reportimagemember.length,
                              itemWidth: 300.0,
                              layout: SwiperLayout.DEFAULT,
                            ),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Text(
                                'รายละเอียด : ',
                                style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '${reportactivitymember[index].reDetel}',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  
                },
              ),
      ),
    );
  }

  Widget _checkImage(imageName) {
    Widget child;
    print('Imagename : $imageName');
    if (imageName != null || imageName == '') {
      child = Image.network(
        '${Connectapi().activityreport}$imageName',
        fit: BoxFit.cover,
      );
      // load = false;
    } else {
      child = Image.asset('assets/images/noimg.png');
    }
    return new Container(child: child);
  }
}
