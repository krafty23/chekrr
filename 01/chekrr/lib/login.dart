import 'dart:convert';
import 'globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
//import http package manually

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
        globals.globalProtocol + globals.globalURL + '/api/login.php'; //api url
    //dont use http://localhost , because emulator don't get that address
    //insted use your local IP address or use live URL
    //hit "ipconfig" in windows or "ip a" in linux to get you local IP
    //print(username);

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
            globals.isLoggedIn = true;
            globals.uid = jsondata["uid"];
            globals.fullname = jsondata["fullname"];
            globals.foto_filename = jsondata["foto_filename"];
          });
          //save the data returned from server
          //and navigate to home page
          int uid = jsondata["uid"];
          String fullname = jsondata["fullname"];
          Navigator.pushReplacementNamed(context, '/myplan');
          //user shared preference to save data
        } else {
          showprogress = false; //don't show progress indicator
          error = true;
          errormsg = "Something went wrong.";
        }
      }
    } else {
      setState(() {
        showprogress = false; //don't show progress indicator
        error = true;
        errormsg = "Error during connecting to server.";
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
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent
            //color set to transperent or set your own color
            ));
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height
                  //set minimum height equal to 100% of VH
                  ),
          width: MediaQuery.of(context).size.width,
          //make width of outer wrapper to 100%
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromRGBO(48, 48, 48, 1),
                Color.fromRGBO(150, 150, 150, 1),
              ],
            ),
          ), //show linear gradient background of page

          padding: EdgeInsets.all(20),
          child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 80),
              child: Text(
                "V??tejte",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ), //title text
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                "P??ihla??te se do syst??mu",
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
                  label: "Username",
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
                  label: "Password",
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
              margin: EdgeInsets.only(top: 20),
              child: SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      //show progress indicator on click
                      showprogress = true;
                    });
                    startLogin();
                  },
                  child: showprogress
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
                          "LOGIN NOW",
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
            Container(
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
            )
          ]),
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
              color: (Color.fromRGBO(194, 194, 194, 1))!,
              width: 1)), //default border of input

      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
              color: (Color.fromRGBO(207, 207, 207, 1))!,
              width: 1)), //focus border

      fillColor: Color.fromRGBO(167, 167, 167, 0.342),
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
          color: Color.fromRGBO(244, 67, 54, 0.507),
          border: Border.all(
              color: (Color.fromRGBO(231, 50, 50, 0.575))!, width: 2)),
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
