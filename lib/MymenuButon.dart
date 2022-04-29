import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:userproject/NotificationsPage.dart';
import 'package:userproject/activity/HomePage.dart';
import 'package:userproject/join/ActivityPage.dart';
import 'package:userproject/user/ProfilePage.dart';

class MymenuButon extends StatefulWidget {
  @override
  _MymenuButonState createState() => _MymenuButonState();
}

class _MymenuButonState extends State<MymenuButon> {
  int _currenIndex = 0;
  List<Widget> _PageOption = [
    HomePage(),
    ActivityPage(),
    ProfilePage(),
    // NotificationsPage(),
  ];

  void _onItemTaped(int index) {
    setState(() {
      _currenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/frmactivity');
        },
        child: Icon(CupertinoIcons.add),
        tooltip: 'เพิ่มกิจกรรม',
        backgroundColor: Theme.of(context).primaryColorDark,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BubbleBottomBar(
        // backgroundColor: Colors.green.shade600,
        opacity: .2,
        currentIndex: _currenIndex,
        onTap: _onItemTaped,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        elevation: 8,
        fabLocation: BubbleBottomBarFabLocation.end, //new
        hasNotch: true,
        hasInk: true,
        inkColor: Colors.black12, //optional, uses theme color if not specified
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Colors.indigo,
              icon: Icon(
                Icons.home_outlined,
                color: Theme.of(context).primaryColorDark,
              ),
              activeIcon: Icon(
                Icons.home,
                color: Colors.indigo,
              ),
              title: Text(
                'หน้าหลัก',
              )),
          BubbleBottomBarItem(
              backgroundColor: Colors.indigo,
              icon: Icon(
                Icons.local_activity_outlined,
                color: Theme.of(context).primaryColorDark,
              ),
              activeIcon: Icon(
                Icons.local_activity,
                color: Colors.indigo,
              ),
              title: Text(
                'กิจกรรม',
              )),
              // BubbleBottomBarItem(
              // backgroundColor: Colors.indigo,
              // icon: Icon(
              //   Icons.notifications,
              //   color: Theme.of(context).primaryColorDark,
              // ),
              // activeIcon: Icon(
              //   Icons.notifications,
              //   color: Colors.indigo,
              // ),
              // title: Text(
              //   'แจ้งเตือน',
              // )),
          BubbleBottomBarItem(
              backgroundColor: Colors.indigo,
              icon: Icon(
                Icons.person_outlined,
                color: Theme.of(context).primaryColorDark,
              ),
              activeIcon: Icon(
                Icons.person,
                color: Colors.indigo,
              ),
              title: Text(
                'ฉัน',
              )),
        ],
      ),
      body: _PageOption.elementAt(_currenIndex),
    );
  }
}
