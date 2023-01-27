import "package:flutter/material.dart";
import '../models/challenge.dart';
import '../globals.dart' as globals;
import 'dart:io';
import 'package:chekrr/drawer.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import '../bottomtab.dart';
import 'package:get/get.dart';

class ChallengesScreen extends StatefulWidget {
  ChallengesScreen({super.key});

  @override
  _ChallengesScreenState createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  late Future<List<Program>> _future;
  Future<List<Program>> getProgram() async {
    final box = GetStorage();
    var uid = box.read('uid');
    try {
      Map<String, dynamic> requestbody = {
        //'uid': globals.uid.toString(),
        'uid': uid.toString(),
      };
      var url = Uri.parse(globals.globalProtocol +
          globals.globalURL +
          '/api/index.php/challenge/list');
      http.Response response = await http.post(
          Uri.parse(globals.globalProtocol +
              globals.globalURL +
              '/api/index.php/challenge/list'),
          headers: <String, String>{
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            //'Content-Type': 'application/json; charset=UTF-8',
          },
          body: requestbody);
      if (response.statusCode == 200) {
        return ProgramFromJson(response.body);
      } else {
        return <Program>[];
      }
    } catch (e) {
      return <Program>[]; // return an empty list on exception/error
    }
  }

  late GlobalKey<ScaffoldState> _scaffoldKey;
  @override
  void initState() {
    _scaffoldKey = GlobalKey();
    super.initState();
    _future = getProgram();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Výzvy"),
      ),
      drawer: DrawerDraw(),
      body: FutureBuilder(
        future: _future,
        builder: (context, AsyncSnapshot<List<Program>> snapshot) {
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
                return Column(
                  children: <Widget>[
                    /*Expanded(
                      flex: 1,
                      child: Text('d'),
                    ),*/
                    Expanded(
                      flex: 9,
                      child: ListView.builder(
                        //scrollDirection: Axis.horizontal,
                        key: _scaffoldKey,
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) => Dismissible(
                          key: UniqueKey(),
                          child: ListTile(
                            onTap: () {
                              Get.toNamed(
                                '/challenge?id=' +
                                    snapshot.data![index].id.toString(),
                              );
                            },
                            visualDensity: VisualDensity(vertical: 1),
                            title: Card(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  children: <Widget>[
                                    Image(
                                      image: NetworkImage(
                                        globals.globalProtocol +
                                            globals.globalURL +
                                            '/images/chekrr/folders/' +
                                            snapshot
                                                .data![index].image_filename,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data![index].name,
                                      style: TextStyle(
                                        color: Color.fromRGBO(
                                            255, 255, 255, 0.801),
                                      ),
                                    ),
                                    Text(
                                      snapshot.data![index].perex,
                                      style: TextStyle(
                                        color: Color.fromRGBO(
                                            255, 255, 255, 0.801),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            /*leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                              ],
                            ),*/
                          ),
                        ),
                      ),
                    ),
                  ],
                  /*
                    Expanded(
                      flex: 1,
                      child: ListView(
                        
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          Container(
                            //width: 200,
                            color: Colors.purple[600],
                            child: const Center(
                                child: Text(
                              'Item 1 sdfgfds gfg dfsg  dfs o jl;k j;kljk;lj ;kl j;lk j;klj ;kl',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            )),
                          ),
                          Container(
                            width: 200,
                            color: Colors.purple[500],
                            child: const Center(
                                child: Text(
                              'Item 2',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            )),
                          ),
                          Container(
                            width: 200,
                            color: Colors.purple[400],
                            child: const Center(
                                child: Text(
                              'Item 3',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            )),
                          ),
                          Container(
                            width: 200,
                            color: Colors.purple[300],
                            child: const Center(
                                child: Text(
                              'Item 4',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            )),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text('ddd'),
                    ),
                  ],*/
                );
                debugPrint(snapshot.data?.length.toString());
              }
          }
        },
      ),
      bottomNavigationBar: BottomTabs(),
    );
  }
}


/*
body: Column(
        children: [
          Expanded(
            flex: 1,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Container(
                  //width: 200,
                  color: Colors.purple[600],
                  child: const Center(
                      child: Text(
                    'Item 1 sdfgfds gfg dfsg  dfs o jl;k j;kljk;lj ;kl j;lk j;klj ;kl',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )),
                ),
                Container(
                  width: 200,
                  color: Colors.purple[500],
                  child: const Center(
                      child: Text(
                    'Item 2',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )),
                ),
                Container(
                  width: 200,
                  color: Colors.purple[400],
                  child: const Center(
                      child: Text(
                    'Item 3',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )),
                ),
                Container(
                  width: 200,
                  color: Colors.purple[300],
                  child: const Center(
                      child: Text(
                    'Item 4',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text('ddd'),
          ),
        ],
      ),
*/