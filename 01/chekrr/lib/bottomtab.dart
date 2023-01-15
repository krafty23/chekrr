import 'package:flutter/material.dart';

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
        _selectedIndex = 1;
      });
    }
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
        if (index == 0) {
          Navigator.pushReplacementNamed(context, '/myplan');
        }
        if (index == 1) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      });
    }

    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.check,
            size: 40.0,
          ),
          label: 'Můj Plán',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.list,
            size: 40.0,
          ),
          label: 'Výzvy',
          //label: '$cesta',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Color.fromRGBO(203, 135, 235, 1),
      backgroundColor: Color.fromRGBO(156, 23, 245, 0.151),
      onTap: _onItemTapped,
    );
  }
}
