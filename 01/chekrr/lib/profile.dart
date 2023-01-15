import 'package:flutter/material.dart';

class MyStatefulWidget2 extends StatefulWidget {
  const MyStatefulWidget2({super.key});

  @override
  State<MyStatefulWidget2> createState() => _MyStatefulWidgetState2();
}

class _MyStatefulWidgetState2 extends State<MyStatefulWidget2> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped2(int index) {
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
                child: Text(
                  'Hovno',
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
                      'Hovno',
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
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              size: 40.0,
            ),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Color.fromRGBO(203, 135, 235, 1),
        backgroundColor: Color.fromRGBO(156, 23, 245, 0.151),
        onTap: _onItemTapped2,
      ),
    );
  }
}
