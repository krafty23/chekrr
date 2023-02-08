import "package:flutter/material.dart";
import '../globals.dart' as globals;
import '../models/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String errormsg = '';
  bool error = false, showprogress = false;
  String name = '', surname = '', email_personal = '', birthday = '';
  int gender = 1;
  var _name = TextEditingController();
  var _email_personal = TextEditingController();
  var _surname = TextEditingController();
  var _gender = TextEditingController();
  late Future<List<UserFull>> _future;
  Future<List<UserFull>> getUserFull() async {
    final box = GetStorage();
    var uid = box.read('uid');
    try {
      Map<String, dynamic> requestbody = {
        //'uid': globals.uid.toString(),
        'uid': uid.toString(),
      };
      http.Response response = await http.post(
          Uri.parse(globals.globalProtocol +
              globals.globalURL +
              '/api/index.php/user/detail'),
          headers: <String, String>{
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            //'Content-Type': 'application/json; charset=UTF-8',
          },
          body: requestbody);
      if (response.statusCode == 200) {
        return UserFullFromJson(response.body);
      } else {
        return <UserFull>[];
      }
    } catch (e) {
      return <UserFull>[]; // return an empty list on exception/error
    }
  }

  late GlobalKey<ScaffoldState> _scaffoldKey;
  @override
  void initState() {
    name = "";
    surname = "";
    email_personal = "";
    birthday = "";
    errormsg = "";
    error = false;
    showprogress = false;
    _scaffoldKey = GlobalKey();
    _future = getUserFull();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        title: Text("Editovat profil"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/chekrr_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder(
          future: _future,
          builder: (context, AsyncSnapshot<List<UserFull>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text('none');
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.active:
                return Text('');
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Text(
                    '${snapshot.error}',
                    style: TextStyle(color: Colors.red),
                  );
                } else {
                  _email_personal.value =
                      TextEditingValue(text: snapshot.data![0].email_personal);
                  _name.value = TextEditingValue(text: snapshot.data![0].name);
                  _surname.value =
                      TextEditingValue(text: snapshot.data![0].surname);
                  return Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                                globals.globalProtocol +
                                    globals.globalURL +
                                    '/images/users/' +
                                    snapshot.data![0].foto_filename),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 0, 15, 0),
                                      child: Text(
                                        'E-mail',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 0, 15, 10),
                                      margin: EdgeInsets.only(top: 10),
                                      child: TextField(
                                        controller:
                                            _email_personal, //set username controller
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 216, 216, 216),
                                            fontSize: 20),
                                        decoration: myInputDecoration(
                                          label: "E-mail",
                                          icon: Icons.mail,
                                        ),
                                        onChanged: (value) {
                                          //set username  text on change
                                          name = value;
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 0, 15, 0),
                                      child: Text(
                                        'Jméno',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 0, 15, 10),
                                      margin: EdgeInsets.only(top: 10),
                                      child: TextField(
                                        controller:
                                            _name, //set username controller
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 216, 216, 216),
                                            fontSize: 20),
                                        decoration: myInputDecoration(
                                          label: "Jméno",
                                          icon: Icons.person,
                                        ),
                                        onChanged: (value) {
                                          //set username  text on change
                                          name = value;
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 0, 15, 0),
                                      child: Text(
                                        'Příjmení',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 0, 15, 10),
                                      margin: EdgeInsets.only(top: 10),
                                      child: TextField(
                                        controller:
                                            _surname, //set username controller
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 216, 216, 216),
                                            fontSize: 20),
                                        decoration: myInputDecoration(
                                          label: "Příjmení",
                                          icon: Icons.person_outline,
                                        ),
                                        onChanged: (value) {
                                          //set username  text on change
                                          surname = value;
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 0, 15, 0),
                                      child: Text(
                                        'Pohlaví',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
            }
          },
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

      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(
          color: (Color.fromRGBO(255, 255, 255, 0.219))!,
          width: 1,
        ),
      ), //default border of input

      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
              color: (Color.fromRGBO(207, 207, 207, 1))!,
              width: 1)), //focus border

      fillColor: Color.fromRGBO(0, 0, 0, 0.26),
      filled: true, //set true if you want to show input background
    );
  }
}
