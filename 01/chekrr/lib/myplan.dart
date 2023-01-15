import 'package:flutter/material.dart';
import 'package:chekrr/drawer.dart';
import 'bottomtab.dart';

class MyPlanScreen extends StatefulWidget {
  @override
  _MyPlanScreenState createState() => _MyPlanScreenState();
}

class _MyPlanScreenState extends State<MyPlanScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  @override
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerDraw(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            //Get the current location
          },
          child: Text('myplan'),
        ),
      ),
      bottomNavigationBar: BottomTabs(),
    );
  }
}
