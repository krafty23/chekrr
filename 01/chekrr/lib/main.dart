import 'package:flutter/material.dart';

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
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

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
        child: ListView(
          padding: EdgeInsets.zero,
          children: const <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
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
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: CircleAvatar(
                  radius: 20.0,
                  backgroundImage: AssetImage('images/clown.jpg'),
                ),
              ),
            ),
            Flexible(
              flex: 3,
              fit: FlexFit.tight,
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Jaroslav Kraft',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Nothing',
                          fontSize: 45.0,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(6.0, 6.0),
                              blurRadius: 7.0,
                              color: Color.fromRGBO(15, 1, 24, 1),
                            ),
                          ],
                          color: Color.fromRGBO(203, 135, 235, 1)),
                    ),
                    Text(
                      'Level 6',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 45.0,
                          color: Color.fromRGBO(143, 85, 168, 1)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
