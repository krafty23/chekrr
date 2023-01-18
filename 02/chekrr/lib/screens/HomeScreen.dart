import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:chekrr/drawer.dart';
import '../bottomtab.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GetX | State Management"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        child: Icon(Icons.add),
        onPressed: () {
          Get.toNamed('/add_task');
        },
      ),
      drawer: DrawerDraw(),
      body: Text('sdf'),
      bottomNavigationBar: BottomTabs(),
    );
  }
}
