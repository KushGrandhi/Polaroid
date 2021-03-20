import 'package:flutter/material.dart';
import 'package:polaroid/screens/Dashboard.dart';
import 'package:polaroid/screens/dowloads.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  final List<Widget> _pages=[
    Downloads(),
    DashBoard()
  ];
  int _selectedPageIndex=1;

  void _selectpage(int index){
    setState(() {
      _selectedPageIndex=index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.lightBlueAccent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          currentIndex: _selectedPageIndex,
          onTap:_selectpage,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.textsms),title: Text("Downloads")),
            BottomNavigationBarItem(icon: Icon(Icons.dashboard),title: Text("DashBoard")),
          ]
      ),
      body: _pages[_selectedPageIndex],
    );
  }
}