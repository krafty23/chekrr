import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DrawerDraw extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    print(globals.foto_filename);
    return Drawer(
      backgroundColor: Color.fromRGBO(20, 15, 45, 0.76),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromRGBO(244, 156, 55, 0.178),
              image: DecorationImage(
                image: AssetImage("images/chekrr_icon.png"),
                fit: BoxFit.cover,
              ),
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
            child: Container(),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Můj plán dne'),
            onTap: () {
              //Navigator.pushReplacementNamed(context, '/settings');
              Get.toNamed('/home');
            },
          ),
          ListTile(
            leading: Icon(Icons.rocket_launch),
            title: Text('Programy'),
            onTap: () {
              Get.toNamed('/challenges');
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_month),
            title: Text('Kalendář'),
            onTap: () {
              Get.toNamed('/calendar');
            },
          ),
          /*ListTile(
            leading: Icon(Icons.people),
            title: Text('Lidé'),
            onTap: () {
              Get.toNamed('/history');
            },
          ),*/
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
          /*ListTile(
            leading: Icon(Icons.settings),
            title: Text('Nastavení'),
            onTap: () {
              //Navigator.pushReplacementNamed(context, '/settings');
              Get.toNamed('/settings');
            },
          ),*/
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
