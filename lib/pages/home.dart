import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:nutritionapp/pages/profileSet.dart';
import 'package:nutritionapp/pages/settingspage.dart';
import 'home_page.dart';


class MyHomePage extends StatefulWidget {
  final int currentIndex;

  MyHomePage({required this.currentIndex});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  final List<Widget> _children = [
    Homepage(),
    ProfileScreen(),
    SettingsScreen(),
  ];

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.grey.shade200,
        animationDuration: Duration(milliseconds: 300),
        onTap: onTappedBar,
        items: const [
          Icon(Icons.home),
          Icon(Icons.person),
          Icon(Icons.settings),
        ],
      ),
    );
  }
}