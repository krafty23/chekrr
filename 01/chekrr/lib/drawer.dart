import 'package:chekrr/home.dart';
import 'globals.dart' as globals;
import 'package:flutter/material.dart';

class DrawerDraw extends StatefulWidget {
  const DrawerDraw({Key? key}) : super(key: key);
  @override
  _DrawerDrawState createState() => _DrawerDrawState();
}

class _DrawerDrawState extends State<DrawerDraw> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      //backgroundColor: Color.fromRGBO(239, 216, 255, 0.932),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.185),
            ),
            child: CircleAvatar(
              radius: 58,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: Image.network(
                  globals.globalProtocol +
                      globals.globalURL +
                      '/images/users/tn/' +
                      globals.foto_filename,
                  fit: BoxFit.fitWidth,
                ),
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
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Odhlásit'),
            onTap: () {
              setState(() {
                globals.isLoggedIn = false;
                globals.fullname = '';
                globals.uid = 0;
              });
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
