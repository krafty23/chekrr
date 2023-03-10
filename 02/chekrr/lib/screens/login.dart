import 'dart:convert';
import '../globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPage();
  }
}

class _LoginPage extends State<LoginPage> {
  String errormsg = '';
  bool error = false, showprogress = false;
  String username = '', password = '';

  var _username = TextEditingController();
  var _password = TextEditingController();

  startLogin() async {
    String apiurl =
        globals.globalProtocol + globals.globalURL + '/api/login.php';

    var response = await http.post(Uri.parse(apiurl), body: {
      'username': username, //get the username text
      'password': password //get password text
    });

    if (response.statusCode == 200) {
      var jsondata = json.decode(response.body);
      if (jsondata["error"]) {
        setState(() {
          showprogress = false; //don't show progress indicator
          error = true;
          errormsg = jsondata["message"];
        });
      } else {
        if (jsondata["success"]) {
          setState(() {
            error = false;
            showprogress = false;
          });
          final box = GetStorage();
          //var LoggedIn = box.read('isloggedin') ?? 0;
          //print(box.read('loggedin'));
          box.write('isloggedin', true);
          box.write('uid', jsondata["uid"]);
          box.write('fullname', jsondata["fullname"]);
          box.write('foto_filename', jsondata["foto_filename"]);
          int uid = jsondata["uid"];
          String fullname = jsondata["fullname"];
          Get.toNamed('/home');
        } else {
          showprogress = false; //don't show progress indicator
          error = true;
          errormsg = "Něco je špatně";
        }
      }
    } else {
      setState(() {
        showprogress = false; //don't show progress indicator
        error = true;
        errormsg = "Chyba připojení k serveru";
      });
    }
  }

  @override
  void initState() {
    username = "";
    password = "";
    errormsg = "";
    error = false;
    showprogress = false;

    //_username.text = "defaulttext";
    //_password.text = "defaultpassword";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/chekrr_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 80),
                child: Text(
                  "Vítejte",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ), //title text
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  "Přihlašte se do systému",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ), //subtitle text
              ),
              Container(
                //show error message here
                margin: EdgeInsets.only(top: 30),
                padding: EdgeInsets.all(10),
                child: error ? errmsg(errormsg) : Container(),
                //if error == true then show error message
                //else set empty container as child
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                margin: EdgeInsets.only(top: 10),
                child: TextField(
                  controller: _username, //set username controller
                  style: TextStyle(
                      color: Color.fromARGB(255, 216, 216, 216), fontSize: 20),
                  decoration: myInputDecoration(
                    label: "Uživatelské jméno",
                    icon: Icons.person,
                  ),
                  onChanged: (value) {
                    //set username  text on change
                    username = value;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: _password, //set password controller
                  style: TextStyle(
                      color: Color.fromRGBO(218, 218, 218, 1), fontSize: 20),
                  obscureText: true,
                  decoration: myInputDecoration(
                    label: "Heslo",
                    icon: Icons.lock,
                  ),
                  onChanged: (value) {
                    // change password text
                    password = value;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 10),
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.login,
                      size: 25.0,
                    ),
                    style: ButtonStyle(
                      /*shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),*/
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 214, 214, 214)),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(122, 57, 21, 119)),
                    ),
                    onPressed: () {
                      setState(() {
                        //show progress indicator on click
                        showprogress = true;
                      });
                      startLogin();
                    },
                    label: showprogress
                        ? SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              backgroundColor:
                                  Color.fromRGBO(194, 194, 194, 0.658),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color.fromRGBO(95, 95, 95, 1)),
                            ),
                          )
                        : Text(
                            "Přihlásit",
                            style: TextStyle(fontSize: 20),
                          ),
                    // if showprogress == true then show progress indicator
                    // else show "LOGIN NOW" text
                    //colorBrightness: Brightness.dark,
                    //color: Colors.orange,
                    /*shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)
                    //button corner radius
                    ),*/
                  ),
                ),
              ),
              /*Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 20),
                child: InkResponse(
                  onTap: () {
                    //action on tap
                  },
                  child: Text(
                    "Forgot Password? Troubleshoot",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              )*/
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration myInputDecoration(
      {required String label, required IconData icon}) {
    return InputDecoration(
      hintText: label, //show label as placeholder
      hintStyle: TextStyle(
          color: Color.fromRGBO(196, 196, 196, 1),
          fontSize: 20), //hint text style
      prefixIcon: Padding(
          padding: EdgeInsets.only(left: 20, right: 10),
          child: Icon(
            icon,
            color: Color.fromRGBO(255, 255, 255, 1),
          )
          //padding and icon for prefix
          ),

      contentPadding: EdgeInsets.fromLTRB(30, 20, 30, 20),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
              color: (Color.fromRGBO(255, 255, 255, 0.219))!,
              width: 1)), //default border of input

      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
              color: (Color.fromRGBO(207, 207, 207, 1))!,
              width: 1)), //focus border

      fillColor: Color.fromRGBO(0, 0, 0, 0.26),
      filled: true, //set true if you want to show input background
    );
  }

  Widget errmsg(String text) {
    //error message widget.
    return Container(
      padding: EdgeInsets.all(15.00),
      margin: EdgeInsets.only(bottom: 10.00),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromRGBO(244, 67, 54, 0.288),
          border: Border.all(
              color: (Color.fromRGBO(231, 50, 50, 0.315))!, width: 2)),
      child: Row(children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 6.00),
          child: Icon(Icons.info, color: Colors.white),
        ), // icon for error message

        Text(text, style: TextStyle(color: Colors.white, fontSize: 18)),
        //show error message text
      ]),
    );
  }
}
