import 'dart:convert';
import '../globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:chekrr/drawer.dart';
import '../bottomtab.dart';
import '../models/user.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    _scaffoldKey = GlobalKey();
    super.initState();
    _future = getUserFull();
  }

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    bool LoggedIn = box.read('isloggedin') ?? false;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        title: Text("Profil"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: DrawerDraw(),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 100, 0, 90),
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
                  return Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: ListView.builder(
                            //scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.zero,
                            key: _scaffoldKey,
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) => Card(
                              elevation: 5,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                                child: Column(
                                  children: <Widget>[
                                    Image(
                                      image: NetworkImage(
                                        globals.globalProtocol +
                                            globals.globalURL +
                                            '/images/users/' +
                                            snapshot.data![index].foto_filename,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data![index].name.toString() +
                                          ' ' +
                                          snapshot.data![index].surname
                                              .toString(),
                                    ),
                                    Text(
                                      '( ' +
                                          snapshot.data![index].username
                                              .toString() +
                                          ' )',
                                    ),
                                    Text(
                                      snapshot.data![index].email_personal
                                          .toString(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
            }
          },
        ),
      ),
      bottomNavigationBar: BottomTabs(),
    );
  }
}
