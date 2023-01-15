import 'package:flutter/material.dart';
import 'package:chekrr/drawer.dart';
import 'bottomtab.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
          child: Text('settings'),
        ),
      ),
      bottomNavigationBar: BottomTabs(),
    );
  }
}
