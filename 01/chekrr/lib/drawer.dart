import 'package:chekrr/home.dart';
import 'package:flutter/material.dart';

class DrawerDraw extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromRGBO(239, 216, 255, 0.932),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
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
            onTap: () {
              Navigator.pushReplacementNamed(context, '/myplan');
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profil'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Nastavení'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/settings');
            },
          ),
        ],
      ),
    );
  }
}
