import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:get/get.dart';

class DrawerDraw extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.185),
            ),
            /*child: CircleAvatar(
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
            ),*/
            child: Center(
              child: Text('Chekrr'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Výzvy'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Nastavení'),
            onTap: () {
              //Navigator.pushReplacementNamed(context, '/settings');
              Get.toNamed('/settings');
            },
          ),
        ],
      ),
    );
  }
}
