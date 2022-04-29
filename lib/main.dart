import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:userproject/MapsPage.dart';
import 'package:userproject/MymenuButon.dart';
import 'package:userproject/NotificationsPage.dart';
import 'package:userproject/activity/ActivityFrom.dart';
import 'package:userproject/activity/ProfileActivityFrom.dart';
import 'package:userproject/activity/ShowActivityPage.dart';
import 'package:userproject/follow/FollowPage.dart';
import 'package:userproject/follow/ShowFollowPage.dart';
import 'package:userproject/activity/ShowAllUserJoin.dart';
import 'package:userproject/join/ShowJoinActivity.dart';
import 'package:userproject/nologin/NoFreeAc.dart';
import 'package:userproject/nologin/NoLogShowAc.dart';
import 'package:userproject/user/EditUsAc.dart';
import 'package:userproject/user/EditdataPage.dart';
import 'package:userproject/user/HistoryPage.dart';
import 'package:userproject/user/RegisterPage.dart';
import 'package:userproject/user/ReportAcPage.dart';
import 'package:userproject/user/ReportHistoryPage.dart';
import 'package:userproject/user/ShowDataUser.dart';
import 'package:userproject/user/ShowHistoryPage.dart';
import 'package:userproject/user/ShowReport.dart';
import 'package:userproject/user/ShowUsAc.dart';
import 'package:userproject/user/UploadImgUser.dart';
import 'package:userproject/user/UsAcPage.dart';
import 'package:userproject/user/login.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: mytheme(),
      routes: {
        '/': (context) => SplashScreen(),
        '/nologin': (context) => NoFreeAc(),
        '/nologshow': (context) => NoLogShowAc(),
        '/regis': (context) => RegisterPage(),
        '/login': (context) => login(),
        // '/': (context) => login(),
        '/home': (context) => MymenuButon(),
        '/edit': (context) => ShowDataUser(),
        '/eduser': (context) => EditdataPage(),
        '/frmactivity': (context) => ActivityFrom(),
        '/showac': (context) => ShowActivityPage(),
        '/googlemap': (context) => MapsPage(),
        '/usacpage': (context) => UsAcPage(),
        '/showusac': (context) => ShowUsAc(),
        '/editusac': (context) => EditUsAc(),
        '/showjoinac': (context) => ShowJoinActivity(),
        '/imguserupdate':(context) => UploadImgUsert(),
        '/followac': (context) => FollowPage(),
        '/showfollowac': (context) => ShowFollowPage(),
        // '/notifications': (context) => NotificationsPage(),
        '/profileactivity': (context) => ProfileActivityFrom(),
        '/historypage': (context) => HistoryPage(),
        '/showhis': (context) => ShowHistoryPage(),
        '/showuserjoinall' : (context) => ShowAllUserJoin(),
        '/showreport' : (context) => ShowReport(),
        '/report' : (context) => ReportAcPage(),
        '/reporthistory' : (context) => ReportHistoryPage(),
        
      },

      //?--------------------------Test
      // home: NoLogShowAc(),
      // home: SnackBarPage(),
      // home: ActivityFrom(),
      // home: NoLogActivityPage(),
      // home: ShowActivityPage(),
      //  home: MapsPage(),
      // home: HomePage(),
      // home: CartTest(),
      // home: TestUploedImage(),
      // home: LongDo(),
      // home: ActivityPage(),
      // home: LoginSevenPage(),
      // home: NoFreeAc(),
      // home: TravelNepalPage(),
      //?--------------------------Test
    );
  }

  ThemeData mytheme() {
    return ThemeData(
      primaryColor: HexColor('#22223b'),
      // primaryColor: HexColor('#f34dc3'),
      primaryColorLight: HexColor('#ff4800'),
      primaryColorDark: HexColor('#0d41e1'),
      // primaryColorDark: HexColor('#6930c3'),
      canvasColor: HexColor('#ffffff'),
      errorColor: HexColor('#ffff3f'),
      backgroundColor: HexColor('#1a1e22'),
      // scaffoldBackgroundColor: HexColor('#b7efc5'),
      scaffoldBackgroundColor: HexColor('#ffffff'),
      cardColor: HexColor('#fffcf9'),
      // cardColor: HexColor('#f5cb5c'),
      accentColor: HexColor('#0d41e1'),
      fontFamily: 'Kanit',

      appBarTheme: AppBarTheme(
        // centerTitle: true,
        // color: HexColor('#1a1e22'),
        color: HexColor('#ffffff'),
        elevation: 0,
        brightness: Brightness.light,
        iconTheme: IconThemeData(
          color: HexColor('#ffffff'),
        ),
        textTheme: TextTheme(
          headline6: TextStyle(
            fontFamily: 'Kanit',
            color: HexColor('#000000'),
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = Duration(seconds: 2);
    return Timer(duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/BG2021.png'), fit: BoxFit.cover),
          // gradient: LinearGradient(
          //     colors: [Colors.white, Colors.white],
          //     begin: Alignment.topCenter,
          //     end: Alignment.center)
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              CircleAvatar(
                radius: 120,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('assets/images/LoGo2.PNG'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 100,right: 100),
                child: Center(
                    child: LinearProgressIndicator(
                  backgroundColor: Colors.greenAccent.shade700,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                )),
              ),
              Text('ยินดีต้อนรับ',style: TextStyle(fontSize: 18,color: Colors.black45),),
            ],
          ),
        ),
      ),
    );
  }
}
