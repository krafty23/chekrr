import 'dart:convert';
import '../globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:chekrr/screens/HomeScreen.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    bool LoggedIn = box.read('isloggedin') ?? false;
    return Container(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/abstract_background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                //navigator.pushReplacementNamed(context, '/');
                if (LoggedIn == true) {
                  Get.offAllNamed('/home');
                } else {
                  Get.offAllNamed('/login');
                }
              },
              child: Text('Let\'s fucking GO'),
            ),
          ),
        ),
      ),
    );
  }
}
