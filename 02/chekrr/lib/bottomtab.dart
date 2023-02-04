import 'package:chekrr/screens/HomeScreen.dart';
import 'package:chekrr/screens/add_task.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomTabs extends StatefulWidget {
  @override
  _BottomTabsState createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    dynamic cesta = ModalRoute.of(context)?.settings.name;
    if (cesta == '/home') {
      setState(() {
        _selectedIndex = 0;
      });
    }
    if (cesta == '/challenges') {
      setState(() {
        _selectedIndex = 1;
      });
    }
    if (cesta == '/profile') {
      setState(() {
        _selectedIndex = 2;
      });
    }
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
        if (index == 0) {
          //Navigator.pushReplacementNamed(context, '/myplan');
          Get.toNamed('/home');
        }
        if (index == 1) {
          Get.toNamed('/challenges');
          //Navigator.pushReplacementNamed(context, '/challenges');
        }
        if (index == 2) {
          Get.toNamed('/profile');
          //Navigator.pushReplacementNamed(context, '/challenges');
        }
      });
    }

    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.check,
            size: 45.0,
          ),
          label: 'Můj Plán',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.list,
            size: 45.0,
          ),
          label: 'Výzvy',
          //label: '$cesta',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            size: 45.0,
          ),
          label: 'Profil',
          //label: '$cesta',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Color.fromARGB(255, 212, 124, 9),
      unselectedItemColor: Color.fromARGB(255, 214, 214, 214),
      backgroundColor: Colors.transparent,
      onTap: _onItemTapped,
      elevation: 0,
    );
  }
}
