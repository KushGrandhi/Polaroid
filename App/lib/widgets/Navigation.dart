import 'package:flutter/material.dart';
import 'package:polaroid/screens/Dashboard.dart';
import 'package:polaroid/screens/dowloads.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final List<Widget> _pages=[
    DashBoard(),
    Downloads(),
  ];
  int _selectedPageIndex=0;

  void _selectpage(int index){
    setState(() {
      _selectedPageIndex=index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color.fromRGBO(255, 188, 117, 1).withOpacity(0.5),
          selectedItemColor: Color.fromRGBO(215, 117, 255, 1),
          unselectedItemColor: Colors.white60,
          currentIndex: _selectedPageIndex,
          onTap:_selectpage,
          items: [

            BottomNavigationBarItem(icon: Icon(Icons.dashboard),title: Text("DashBoard")),
            BottomNavigationBarItem(icon: Icon(Icons.textsms),title: Text("Downloads")),
          ]
      ),
      body: _pages[_selectedPageIndex],
    );
  }
}