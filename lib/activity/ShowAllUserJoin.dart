import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:userproject/model/AllJoinmember.dart';
import 'package:userproject/model/ConnectAPI.dart';

class ShowAllUserJoin extends StatefulWidget {
  @override
  _ShowAllUserJoinState createState() => _ShowAllUserJoinState();
}

class _ShowAllUserJoinState extends State<ShowAllUserJoin> {
  List<Showuseractivityjoinall> datamember = [];
  var token;
  var _acId;
  Map<String, dynamic> _rec_member;

  Future<Void> _getUserJoinAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // uId = prefs.getInt('id');
    // print('uId = $uId');
    print('token = $token');
    var url = '${Connectapi().domain}/showjoinuserall/$_acId';
    //conect
    var response = await http.get(url, headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    //check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      AllJoinmember members =
          AllJoinmember.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        datamember = members.showuseractivityjoinall;
        // load = false;
      });
    }
  }

  Future getInfo() {
    _rec_member = ModalRoute.of(context).settings.arguments;
    _acId = _rec_member['_acId'];
    print(_acId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //call _getAPI
    _getUserJoinAll();
  }

  // Future onGoBack(dynamic value) {
  //   setState(() {
  //     _getUserJoinAll();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    getInfo();
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
            'ผู้เข้าร่วมกิจกรรม',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          backgroundColor: Theme.of(context).primaryColorDark,
        ),
      ),
      body: Container(
        child: datamember.length <= 0
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Opacity(
                    //     opacity: 0.4,
                    //     child: Image.asset('assets/images/LoGo2.PNG')),
                    Text(
                      'ยังไม่มีคนเข้าร่วม',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black38,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: datamember.length,
                padding: const EdgeInsets.all(25),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    // onTap: () {
                    //   // Navigator.pushNamed(context, '/showdatauser', arguments: {
                    //   //   'u_id': datamember[index].uId,
                    //   //   'u_name': datamember[index].uName,
                    //   //   'u_lname': datamember[index].uLname,
                    //   //   'u_old': datamember[index].uOld,
                    //   //   'u_email': datamember[index].uEmail,
                    //   //   'u_tel': datamember[index].uTel,
                    //   //   'iu_img': datamember[index].iuImg,
                    //   // });
                    // },
                    child: Card(
                      elevation: 5,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // if you need this
                        side: BorderSide(
                          color: Colors.white70, //withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8, top: 8, bottom: 8, right: 8),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              child: ClipRRect(
                                child: Container(
                                  color: Colors.yellow.shade50,
                                  child: _checkSendRepairImageUser(
                                      '${datamember[index].iuImg}'),
                                  width: 150,
                                  height: 150,
                                ),
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Text(
                                      '${datamember[index].uName}  ',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      '${datamember[index].uLname}',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),

                                // Text(
                                //   '${datamember[index].uOld}',
                                //   style: TextStyle(
                                //     color: Theme.of(context).primaryColor,
                                //   ),
                                // ),

                                Text(
                                  'อายุ ${datamember[index].uOld} ปี',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            // Spacer(),
                            // Icon(
                            //   Icons.arrow_forward_ios_sharp,
                            //   size: 20,
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
