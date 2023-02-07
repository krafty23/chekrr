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
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        title: Text("Programy"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: DrawerDraw(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/chekrr_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.fromLTRB(0, 100, 0, 90),
        child: FutureBuilder(
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      snapshot.data!.isNotEmpty
                          ? Expanded(
                              flex: 9,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: ListView.builder(
                                  //scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.zero,
                                  key: _scaffoldKey,
                                  itemCount: snapshot.data?.length,
                                  itemBuilder: (context, index) => Container(
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(129, 0, 0, 0),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    child: ListTile(
                                      onTap: () {
                                        Get.toNamed(
                                          '/challenge?id=' +
                                              snapshot.data![index].id
                                                  .toString(),
                                        );
                                      },
                                      visualDensity: VisualDensity(vertical: 3),
                                      title: Container(
                                        /*decoration: BoxDecoration(
                                        color: Color.fromARGB(129, 0, 0, 0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),*/
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      child: Image(
                                                        image: NetworkImage(
                                                          globals.globalProtocol +
                                                              globals
                                                                  .globalURL +
                                                              '/images/chekrr/folders/' +
                                                              snapshot
                                                                  .data![index]
                                                                  .image_filename,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  10, 0, 0, 4),
                                                          child: Icon(
                                                            Icons.checklist,
                                                            color:
                                                                Color.fromARGB(
                                                                    139,
                                                                    255,
                                                                    255,
                                                                    255),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  10, 0, 0, 10),
                                                          child: Text(
                                                            snapshot
                                                                .data![index]
                                                                .challenge_count
                                                                .toString(),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      139,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  10, 12, 0, 4),
                                                          child: Icon(
                                                            Icons
                                                                .calendar_month,
                                                            color:
                                                                Color.fromARGB(
                                                                    139,
                                                                    255,
                                                                    255,
                                                                    255),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  10, 0, 0, 10),
                                                          child: Text(
                                                            snapshot
                                                                .data![index]
                                                                .day_count
                                                                .toString(),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      139,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 12, 10, 5),
                                                    child: snapshot
                                                        .data![index].icon,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 12, 0, 10),
                                                    child: Text(
                                                      snapshot
                                                          .data![index].name,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            255,
                                                            255,
                                                            255,
                                                            0.801),
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    5, 5, 5, 10),
                                                child: Text(
                                                  snapshot.data![index].perex,
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 0.603),
                                                    fontSize: 17,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      /*title: Card(
                                    elevation: 5,
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          
                                          
                                          
                                        ],
                                      ),
                                    ),
                                  ),*/
                                      /*leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                              ],
                            ),*/
                                      /*trailing: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: Text('12'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),*/
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Expanded(
                              flex: 1,
                              child: Center(
                                child: Text(
                                    'Žádné další programy nejsou k dispozici'),
                              ),
                            ),
                    ],
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
