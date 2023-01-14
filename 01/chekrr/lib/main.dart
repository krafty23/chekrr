import 'package:flutter/material.dart';
import 'home.dart';
import 'profile.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(156, 23, 245, 0.451),
      appBar: AppBar(
        title: const Text('Chekrr'),
        backgroundColor: Colors.transparent,
      ),
      drawer: Drawer(
        backgroundColor: Color.fromRGBO(239, 216, 255, 0.932),
        child: ListView(
          padding: EdgeInsets.zero,
          children: const <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(55, 0, 92, 0.941),
              ),
              child: Text(
                'Chekrr',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Výzvy'),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profil'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Nastavení'),
            ),
          ],
        ),
      ),
      body: Homescreen(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.check,
              size: 50.0,
            ),
            label: 'Můj Plán',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
              size: 50.0,
            ),
            label: 'Výzvy',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              size: 50.0,
            ),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Color.fromRGBO(203, 135, 235, 1),
        backgroundColor: Color.fromRGBO(156, 23, 245, 0.151),
        onTap: _onItemTapped,
      ),
    );
  }
}
