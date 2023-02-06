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
              image: AssetImage("images/chekrr_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: ElevatedButton(
              style: ButtonStyle(
                textStyle: MaterialStateProperty.resolveWith(
                  (states) {
                    // If the button is pressed, return size 40, otherwise 20
                    if (states.contains(MaterialState.pressed)) {
                      return TextStyle(
                        fontSize: 32,
                        fontFamily: 'Roboto',
                      );
                    }
                    return TextStyle(
                      fontSize: 30,
                      fontFamily: 'Roboto',
                    );
                  },
                ),
                padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
                  return RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Color.fromARGB(60, 57, 21, 119)),
                  );
                }),
                foregroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 214, 214, 214)),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(75, 57, 21, 119)),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered))
                      return Colors.blue.withOpacity(0.04);
                    if (states.contains(MaterialState.focused) ||
                        states.contains(MaterialState.pressed))
                      return Color.fromARGB(50, 244, 157, 55);
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
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
