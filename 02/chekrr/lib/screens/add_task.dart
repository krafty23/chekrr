import 'package:chekrr/screens/HomeScreen.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';

class AddTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GetX Todo List'),
      ),
      body: Container(
        child: ElevatedButton(
          child: Text('data'),
          onPressed: () {
            Get.off(HomeScreen());
          },
        ),
      ),
    );
  }
}
