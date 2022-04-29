import 'package:flutter/material.dart';

class SnackBarPage extends StatefulWidget {

  @override
  _SnackBarPageState createState() => _SnackBarPageState();
}

class _SnackBarPageState extends State<SnackBarPage> {
  void _showbar() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("ล็อกอินสำเร็จ!"),
    ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kindacode.com'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            _showbar();
          },
          child: Text('เข้าสู่ระบบ'),
        ),
      ),
    );
  }
  }
