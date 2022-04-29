import 'package:another_flushbar/flushbar.dart';
// import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userproject/nologin/NoFreeAc.dart';
import 'package:userproject/user/login.dart';


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // void _showbar() {
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     content: Text(
  //       '\u2611 ออกจากระบบสำเร็จ !',
  //       style: TextStyle(
  //         color: Colors.black,
  //         fontFamily: 'Kanit',
  //       ),
  //     ),
  //     backgroundColor: Colors.redAccent.shade400,
  //   ));
  // }

  @override
  Future _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => NoFreeAc()),
        (Route<dynamic> route) => false);
    _showber();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(35),
            ),
          ),
          centerTitle: true,
          title: Text(
            'จัดการข้อมูลส่วนตัว',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // SizedBox(height: 190),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: FlatButton(
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  Navigator.pushNamed(context, '/edit');
                }, // onPress
                child: Row(
                  children: [
                    Icon(
                      Icons.account_box,
                      color: Theme.of(context).canvasColor,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'ข้อมูลส่วนตัว', // "บัญชีผู้ใช้",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Theme.of(context).canvasColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).canvasColor,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
            // SizedBox(height: 0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: FlatButton(
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  Navigator.pushNamed(context, '/usacpage');
                }, // onPress
                child: Row(
                  children: [
                    Icon(
                      Icons.local_activity,
                      color: Theme.of(context).canvasColor,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'กิจกรรมของฉัน',
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Theme.of(context).canvasColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).canvasColor,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
            // SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: FlatButton(
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  Navigator.pushNamed(context, '/followac');
                }, // onPress
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.heart_fill,
                      color: Theme.of(context).canvasColor,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'กิจกรรมที่ถูกใจ',
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Theme.of(context).canvasColor,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).canvasColor,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),

            
            // SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: FlatButton(
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  Navigator.pushNamed(context, '/historypage');
                }, // onPress
                child: Row(
                  children: [
                    Icon(
                      Icons.menu_book,
                      color: Theme.of(context).canvasColor,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'ประวัติการเข้าร่วมกิจกรรม',
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Theme.of(context).canvasColor,
                            fontWeight: FontWeight.w500), 
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).canvasColor,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: FlatButton(
                padding: EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                color: Colors.red,
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                        title: Row(
                          children: [
                            Icon(
                              Icons.cancel_sharp,
                              size: 30,
                              color: Colors.red,
                            ),
                            SizedBox(width: 5,),
                            Expanded(
                              child: Text('คุณต้องการออกจากระบบ !!!'),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text(
                              'ใช่',
                              style: TextStyle(fontSize: 16),
                            ),
                            onPressed: () {
                             _logOut();
                            },
                          ),
                          TextButton(
                            child: Text(
                              'ไม่ใช่',
                              style: TextStyle(fontSize: 16),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      )), // onPress
                child: Row(
                  children: [
                    Icon(
                  Icons.exit_to_app,
                  size: 20,
                  color: Theme.of(context).canvasColor,
                ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'ออกจากระบบ',
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Theme.of(context).canvasColor,
                            fontWeight: FontWeight.w500), 
                      ),
                    ),
                    
                  ],
                ),
              ),
            ),
            // SizedBox(
            //   width: 355,
            //   height: 55,
            //   child: RaisedButton.icon(
            //     onPressed: () => showDialog(
            //       context: context,
            //       builder: (_) => AlertDialog(
            //             title: Row(
            //               children: [
            //                 Icon(
            //                   Icons.cancel_sharp,
            //                   size: 30,
            //                   color: Colors.red,
            //                 ),
            //                 SizedBox(width: 5,),
            //                 Expanded(
            //                   child: Text('คุณต้องการออกจากระบบ !!!'),
            //                 ),
            //               ],
            //             ),
            //             actions: <Widget>[
            //               TextButton(
            //                 child: Text(
            //                   'ใช่',
            //                   style: TextStyle(fontSize: 16),
            //                 ),
            //                 onPressed: () {
            //                  _logOut();
            //                 },
            //               ),
            //               TextButton(
            //                 child: Text(
            //                   'ไม่ใช่',
            //                   style: TextStyle(fontSize: 16),
            //                 ),
            //                 onPressed: () => Navigator.pop(context),
            //               ),
            //             ],
            //           )),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.all(
            //         Radius.circular(10),
            //       ),
            //     ),
            //     label: Text(
            //       'ออกจากระบบ',
            //       style: TextStyle(
            //           fontSize: 16.0,
            //           color: Theme.of(context).canvasColor,
            //           fontWeight: FontWeight.w500),
            //     ),
            //     icon: Icon(
            //       Icons.exit_to_app,
            //       size: 20,
            //       color: Theme.of(context).canvasColor,
            //     ),
            //     splashColor: Colors.white,
            //     color: Colors.red,
            //     // elevation: 10,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
  Widget _showber() {
     return Center(
      child: Flushbar(
        message: "ออกจากระบบสำเร็จแล้ว !!",
        icon: Icon(
          Icons.done,
          size: 28.0,
          color: Colors.white,
        ),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        duration: Duration(seconds: 2),
        // leftBarIndicatorColor: Colors.blue[300],
        backgroundColor: Colors.red.withOpacity(0.8),
      )..show(context),
    );
  }
}
