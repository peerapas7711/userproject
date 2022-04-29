import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:another_flushbar/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:userproject/MymenuButon.dart';
import 'package:userproject/model/LoginProvider.dart';

// import 'package:flushbar/flushbar.dart';

class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  bool statusRedEye = true;
  TextEditingController _ctrlUsername = TextEditingController();
  TextEditingController _ctrlPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  LoginProvider loginProvider = LoginProvider();
//loginuser
  Future dologin() async {
    if (_formKey.currentState.validate()) {
      try {
        var rs =
            await loginProvider.doLogin(_ctrlUsername.text, _ctrlPassword.text);
        if (rs.statusCode == 200) {
          print(rs.body);
          var jsonRes = json.decode(rs.body);

          if (jsonRes['ok']) {
            String token = jsonRes['token'];
            var id = jsonRes['id'];
            print(token);
            print(id);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', token);

            await prefs.setInt('id', id);

            //re
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => MymenuButon()));
            _showber();
          } else {
            print(jsonRes['error']);
            _showbererror();
          }
        } else {
          print('connect error');
        }
      } catch (error) {
        print(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                  Colors.blueAccent.shade200,
                  Theme.of(context).primaryColorDark
                ])),
          ),
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.vertical(
          //     bottom: Radius.circular(35),
          //   ),
          // ),
          centerTitle: true,
          // title: Text(
          //   'กิจกรรมที่ถูกใจ',
          //   style: TextStyle(
          //     fontSize: 18.0,
          //     color: Colors.white,
          //   ),
          // ),

          backgroundColor: Theme.of(context).primaryColorDark,
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipPath(
                    clipper: WaveClipper2(),
                    child: Container(
                      child: Column(),
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.blue.shade100, Colors.white])),
                    ),
                  ),
                  ClipPath(
                    clipper: WaveClipper3(),
                    child: Container(
                      child: Column(),
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                        Colors.blue.shade200,
                        Colors.blue.shade200
                      ])),
                    ),
                  ),
                  ClipPath(
                    clipper: WaveClipper1(),
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 30,
                          ),
                          CircleAvatar(
                            radius: 85,
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                AssetImage('assets/images/LoGo2.PNG'),
                          ),
                        ],
                      ),
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                        Colors.blueAccent.shade200,
                        Theme.of(context).primaryColorDark
                      ])),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              // frmp1(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Material(
                  elevation: 2.0,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return '\u26A0 กรุณากรอกชื่อผู้ใช้';
                      }
                    },
                    controller: _ctrlUsername,
                    // onChanged: (String value) {},
                    cursorColor: Theme.of(context).primaryColorDark,
                    decoration: InputDecoration(
                        hintText: "ชื่อผู้ใช้",
                        prefixIcon: Material(
                          elevation: 0,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: Icon(Icons.person,
                              color: Theme.of(context).primaryColorDark),
                        ),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // frmp2(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Material(
                  elevation: 2.0,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  child: TextFormField(
                    obscureText: statusRedEye,
                    // obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return '\u26A0 กรุณากรอกรหัสผ่าน';
                      }
                    },
                    controller: _ctrlPassword,
                    // onChanged: (String value) {},
                    cursorColor: Theme.of(context).primaryColorDark,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    statusRedEye = !statusRedEye;
                  });
                },
                icon: statusRedEye
                    ? Icon(
                        Icons.remove_red_eye,
                        color: Colors.grey,
                      )
                    : Icon(
                        Icons.remove_red_eye_outlined,
                        color: Theme.of(context).primaryColorDark,
                      ),
              ),
                        hintText: "รหัสผ่าน",
                        prefixIcon: Material(
                          elevation: 0,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: Icon(Icons.lock,
                              color: Theme.of(context).primaryColorDark),
                        ),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              // frmp3(),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 100),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: Theme.of(context).primaryColorDark),
                    child: FlatButton(
                      child: Text(
                        "เข้าสู่ระบบ",
                        style: TextStyle(
                            color: Colors.white,
                            // fontWeight: FontWeight.w700,
                            fontSize: 18),
                      ),
                      onPressed: () => dologin(),
                    ),
                  )),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "คุณยังไม่เป็นสมาชิกใช่หรือไม่ ?",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  ),
                  TextButton(
                    child: Text(
                      "สมัครสมาชิก",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          decoration: TextDecoration.underline),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/regis');
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     // title: Text('login'),
    //     backgroundColor: Colors.white,
    //   ),
    //   backgroundColor: Colors.white,
    //   body: Center(
    //     child: Container(
    //       // decoration: BoxDecoration(
    //       //     gradient: LinearGradient(
    //       //   begin: Alignment.topRight,
    //       //   end: Alignment.bottomLeft,
    //       //   colors: [
    //       //     Colors.blue,
    //       //     Colors.red,
    //       //   ],
    //       // )),
    //       child: Form(
    //         key: _formKey,
    //         child: SingleChildScrollView(
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: <Widget>[
    //               CircleAvatar(
    //                 radius: 120,
    //                 backgroundColor: Colors.transparent,
    //                 backgroundImage: AssetImage('assets/images/LoGo2.PNG',),
    //               ),
    //               // Text(
    //               //   'Login',
    //               //   style: TextStyle(
    //               //     fontSize: 48.0,
    //               //     fontWeight: FontWeight.bold,
    //               //     color: Colors.deepPurple,
    //               //   ),
    //               // ),
    //               SizedBox(height: 15),
    //               frmp1(),
    //               SizedBox(height: 12),
    //               frmp2(),
    //               SizedBox(height: 10),
    //               frmp3(),
    //               SizedBox(height: 10),
    //               frmp4(),
    //               SizedBox(height: 10),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  Widget frmp1() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 0.0),
      child: TextFormField(
        // cursorColor: Colors.greenAccent,
        validator: (value) {
          if (value.isEmpty) {
            return '\u26A0 กรุณากรอกชื่อผู้ใช้';
          }
        },
        controller: _ctrlUsername,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(10.0, 16.5, 10.0, 16.5),
            fillColor: Colors.black12,
            filled: true,
            labelText: 'ชื่อผู้ใช้',
            icon: Icon(
              Icons.person,
              size: 35,
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
      ),
    );
  }

  Widget frmp2() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 0.0),
      child: TextFormField(
        obscureText: true,
        controller: _ctrlPassword,
        validator: (value) {
          if (value.isEmpty) {
            return '\u26A0 กรุณากรอกรหัสผ่าน';
          }
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(10.0, 16.5, 10.0, 16.5),
            fillColor: Colors.black12,
            filled: true,
            labelText: 'รหัสผ่าน',
            icon: Icon(
              Icons.vpn_key_rounded,
              size: 35,
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
      ),
    );
  }

  Widget frmp3() {
    return Padding(
      padding: EdgeInsets.only(left: 130.0, right: 130.0, top: 10.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: RaisedButton(
              color: Colors.greenAccent.shade400,
              textColor: Colors.white,
              onPressed: () => dologin(),
              child: Text(
                'เข้าสู่ระบบ',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget frmp4() {
    return TextButton(
      child: Text('สมัครสมาชิก',
          style: TextStyle(
            color: Colors.orangeAccent,
            fontSize: 15,
            decoration: TextDecoration.underline,
          )),
      onPressed: () {
        Navigator.pushNamed(context, '/regis');
      },
    );
  }

  Widget _showber() {
    return Center(
      child: Flushbar(
        message: "เข้าสู่ระบบสำเร็จแล้ว",
        icon: Icon(
          Icons.done,
          size: 28.0,
          color: Colors.white,
        ),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        duration: Duration(seconds: 1),
        // leftBarIndicatorColor: Colors.blue[300],
        backgroundColor: Colors.greenAccent.shade700.withOpacity(0.8),
      )..show(context),
    );
  }

  Widget _showbererror() {
    return Center(
      child: Flushbar(
        message: "ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง",
        icon: Icon(
          Icons.clear,
          size: 28.0,
          color: Colors.white,
        ),
        margin: EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        duration: Duration(seconds: 1),
        // leftBarIndicatorColor: Colors.blue[300],
        backgroundColor: Colors.red.withOpacity(0.8),
      )..show(context),
    );
  }
}

class WaveClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 29 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 60);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 15 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 40);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * .7, size.height - 40);
    var firstControlPoint = Offset(size.width * .25, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 45);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
