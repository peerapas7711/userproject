import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:date_field/date_field.dart';

import 'dart:convert' as convert;

import 'package:userproject/model/ConnectAPI.dart';



class LongDo extends StatefulWidget {
  @override
  _LongDoState createState() => _LongDoState();
}

class _LongDoState extends State<LongDo> {
  final _uid = GlobalKey<FormState>();
  final _uuser = TextEditingController();
  final _upass = TextEditingController();
  final _uname = TextEditingController();
  final _ulname = TextEditingController();
  final _upho = TextEditingController();
  final _uemail = TextEditingController();
  // final _ubday = TextEditingController();
  // final _uage = TextEditingController();
  // final _uimg = TextEditingController();

  String _choseGender;
  // DateTime selectedData;
  DateTime _date;

  void register(Map<String, dynamic> values) async {
    // var url = 'http://192.168.0.8:8888/register';
    String url = '${Connectapi().domain}/register';
    var response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: convert.jsonEncode(values));

    if (response.statusCode == 200) {
      print('Register Success');

      // Navigator.pop(context, true);
    } else {
      print('Register not Success!!');
      print(response.body);
    }
  }

  bool isObscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text('สมัครสมาชิก'),
          ),
      body: Container(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 0,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "สมัครสมาชิก",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                // shrinkWrap: true,
                flex: 6,
                child: Form(
                  key: _uid,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        // color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: ListView(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // usernameField(),
                          // SizedBox(height: 15),
                          // passwordField(),
                          // SizedBox(height: 15),
                          // btnLogin(),
                          SizedBox(height: 30),
                          usernameForm(),
                          SizedBox(height: 15),
                          passwordForm(true),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // ImageIcon(
                              //   new AssetImage('assets/icons/name-tag.png'),
                              //   color: Theme.of(context).primaryColor,
                              //   // size: 30,
                              // ),
                              SizedBox(width: 15),
                              nameForm(),
                              SizedBox(width: 15),
                              lastnameForm(),
                              // dateForm(),
                            ],
                          ),
                          // nameForm(),
                          // SizedBox(height: 15),
                          // lastnameForm(),
                          SizedBox(height: 15),
                          phoneForm(),
                          SizedBox(height: 15),
                          emailForm(),
                          SizedBox(height: 15),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // ImageIcon(
                              //   new AssetImage('assets/icons/gender.png'),
                              //   color: Theme.of(context).primaryColor,
                              //   // size: 30,
                              // ),
                              SizedBox(width: 15),
                              genderForm(),
                              SizedBox(width: 20),
                              // ImageIcon(
                              //   new AssetImage('assets/icons/calendar.png'),
                              //   color: Theme.of(context).primaryColor,
                              //   // size: 30,
                              // ),
                              SizedBox(width: 15),
                              // dateForm(),
                              // dateForm(),
                            ],
                          ),
                          SizedBox(height: 10),

                          // dateForm(),
                          SizedBox(height: 25),
                          btnSubmit(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget usernameForm() {
    return TextFormField(
      controller: _uuser,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        hintText: 'กรอกชื่อผู้ใช้',
        focusColor: Theme.of(context).primaryColor,
        hintStyle: TextStyle(
          fontSize: 16,
          color: Theme.of(context).primaryColor,
        ),
        // icon: ImageIcon(
        //   new AssetImage('assets/icons/user.png'),
        //   color: Theme.of(context).primaryColor,
        //   // size: 30,
        // ),
      ),
    );
  }

  Widget passwordForm(bool isPasswordTextField) {
    return TextFormField(
      controller: _upass,
      obscureText: isPasswordTextField ? isObscurePassword : false,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        hintText: 'กรอกรหัสผ่าน',
        focusColor: Theme.of(context).primaryColor,
        hintStyle: TextStyle(
          fontSize: 16,
          color: Theme.of(context).primaryColor,
        ),
        // icon: ImageIcon(
        //   new AssetImage('assets/icons/lock.png'),
        //   color: Theme.of(context).primaryColor,
        //   // size: 30,
        // ),
      ),
    );
  }

  Widget nameForm() {
    return Container(
      width: 178,
      height: 65,
      child: TextFormField(
        controller: _uname,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          hintText: 'กรอกชื่อ',
          focusColor: Theme.of(context).primaryColor,
          hintStyle: TextStyle(
            fontSize: 16,
            color: Theme.of(context).primaryColor,
          ),
          // icon: ImageIcon(
          //   new AssetImage('assets/icons/name-tag.png'),
          //   color: Theme.of(context).primaryColor,
          //   // size: 30,
          // ),
        ),
      ),
    );
  }

  Widget lastnameForm() {
    return Container(
      width: 178,
      height: 65,
      child: TextFormField(
        controller: _ulname,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          hintText: 'กรอกนามสกุล',
          focusColor: Theme.of(context).primaryColor,
          hintStyle: TextStyle(
            fontSize: 16,
            color: Theme.of(context).primaryColor,
          ),
          // icon: ImageIcon(
          //   new AssetImage('assets/icons/name-tag.png'),
          //   color: Theme.of(context).primaryColor,
          //   // size: 30,
          // ),
        ),
      ),
    );
  }

  Widget phoneForm() {
    return TextFormField(
      controller: _upho,
      keyboardType: TextInputType.number,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        hintText: 'กรอกเบอร์โทรศัพท์',
        focusColor: Theme.of(context).primaryColor,
        hintStyle: TextStyle(
          fontSize: 16,
          color: Theme.of(context).primaryColor,
        ),
        // icon: ImageIcon(
        //   new AssetImage('assets/icons/phone.png'),
        //   color: Theme.of(context).primaryColor,
        //   // size: 30,
        // ),
      ),
    );
  }

  Widget emailForm() {
    return TextFormField(
      controller: _uemail,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        hintText: 'กรอก Email',
        focusColor: Theme.of(context).primaryColor,
        hintStyle: TextStyle(
          fontSize: 16,
          color: Theme.of(context).primaryColor,
        ),
        // icon: ImageIcon(
        //   new AssetImage('assets/icons/mail.png'),
        //   color: Theme.of(context).primaryColor,
        //   // size: 30,
        // ),
      ),
    );
  }

  Widget genderForm() {
    return DropdownButtonHideUnderline(
      child: Container(
        width: 110,
        height: 65,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border.all(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
        child: DropdownButton<String>(
          value: _choseGender,
          // elevation: 5,
          // style: GoogleFonts.kanit(color: Colors.black),
          items: <String>[
            'ชาย',
            'หญิง',
            'อื่นๆ',
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          style: TextStyle(
            fontFamily: 'Mitr',
            color: Theme.of(context).primaryColor,
            fontSize: 16,
          ),
          hint: Text(
            "เลือกเพศ",
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).primaryColor,
            ),
          ),
          dropdownColor: Theme.of(context).backgroundColor,
          onChanged: (String value) {
            setState(() {
              _choseGender = value;
            });
          },
        ),
      ),
    );
  }

  

  Widget btnSubmit() {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'เสร็จสิ้น',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        onPressed: () {
          // Navigator.pop(context, '/LoginPage');

          if (_uid.currentState.validate()) {
            Map<String, dynamic> valuse = Map();
            valuse['user_username'] = _uuser.text;
            valuse['user_password'] = _upass.text;
            valuse['user_name'] = _uname.text;
            valuse['user_lastname'] = _ulname.text;
            valuse['user_phone'] = _upho.text;
            valuse['user_email'] = _uemail.text;
            // valuse['user_gender'] = _ugender.text;
            // valuse['user_age'] = _uage.text;
            valuse['user_gender'] = _choseGender.toString();
            valuse['user_bday'] = _date.toString();

            print(_uuser.text);
            print(_upass.text);
            print(_uname.text);
            print(_ulname.text);
            print(_upho.text);
            print(_uemail.text);
            // print(_ugender.text);
            // print(_uage.text);
            print(_choseGender.toString());
            print(_date.toString());

            register(valuse);
          }
        },
      ),
    );
  }
}
