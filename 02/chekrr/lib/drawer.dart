import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DrawerDraw extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
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
            leading: Icon(Icons.check),
            title: Text('Můj plán dne'),
            onTap: () {
              //Navigator.pushReplacementNamed(context, '/settings');
              Get.toNamed('/home');
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Výzvy'),
            onTap: () {
              Get.toNamed('/challenges');
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Lidé'),
            onTap: () {
              Get.toNamed('/history');
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profil'),
            onTap: () {
              //Navigator.pushReplacementNamed(context, '/settings');
              Get.toNamed('/profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Historie'),
            onTap: () {
              Get.toNamed('/history');
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
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Odhlásit'),
            onTap: () {
              box.write('isloggedin', false);
              Get.offAllNamed('/login');
            },
          ),
        ],
      ),
    );
  }
}
