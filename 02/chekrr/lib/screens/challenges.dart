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
        //title: Text("Programy"),
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
        padding: EdgeInsets.fromLTRB(0, 0, 0, 55),
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
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: ClipRRect(
                                  child: ShaderMask(
                                    shaderCallback: (rect) {
                                      return LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black,
                                        ],
                                      ).createShader(
                                          Rect.fromLTRB(0, 0, rect.width, 0));
                                    },
                                    blendMode: BlendMode.dstIn,
                                    child: ShaderMask(
                                      shaderCallback: (rect) {
                                        return LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.black,
                                            Colors.transparent
                                          ],
                                        ).createShader(Rect.fromLTRB(
                                            0,
                                            rect.height - 150,
                                            rect.width,
                                            rect.height));
                                      },
                                      blendMode: BlendMode.dstIn,
                                      child: ListView.builder(
                                        //scrollDirection: Axis.horizontal,
                                        padding:
                                            EdgeInsets.fromLTRB(0, 95, 0, 65),
                                        key: _scaffoldKey,
                                        itemCount: snapshot.data?.length,
                                        itemBuilder: (context, index) =>
                                            Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 0, 0, 25),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              left: BorderSide(
                                                color: Colors.transparent,
                                              ),
                                              right: BorderSide(
                                                color: Colors.transparent,
                                              ),
                                              top: BorderSide(
                                                color: Colors.transparent,
                                              ),
                                              bottom: BorderSide(
                                                color: Colors.transparent,
                                              ),
                                            ),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              topRight: Radius.circular(30),
                                              bottomLeft: Radius.circular(30),
                                              bottomRight: Radius.circular(30),
                                            ),
                                            color: Color.fromARGB(
                                                22, 255, 255, 255),
                                            //borderRadius: BorderRadius.all(
                                            //    Radius.circular(3)),
                                          ),
                                          child: ListTile(
                                            onTap: () {
                                              Get.toNamed(
                                                '/challenge?id=' +
                                                    snapshot.data![index].id
                                                        .toString(),
                                              );
                                            },
                                            contentPadding:
                                                EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            visualDensity:
                                                VisualDensity(vertical: 0),
                                            title: Container(
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 0),
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
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(30),
                                                              topRight: Radius
                                                                  .circular(30),
                                                            ),
                                                            child: ShaderMask(
                                                              shaderCallback:
                                                                  (rect) {
                                                                return LinearGradient(
                                                                  begin: Alignment
                                                                      .topCenter,
                                                                  end: Alignment
                                                                      .bottomCenter,
                                                                  colors: [
                                                                    Colors
                                                                        .black,
                                                                    Colors
                                                                        .transparent
                                                                  ],
                                                                ).createShader(Rect.fromLTRB(
                                                                    0,
                                                                    rect.height -
                                                                        100,
                                                                    rect.width,
                                                                    rect.height));
                                                              },
                                                              blendMode:
                                                                  BlendMode
                                                                      .dstIn,
                                                              child: Image(
                                                                image:
                                                                    NetworkImage(
                                                                  globals.globalProtocol +
                                                                      globals
                                                                          .globalURL +
                                                                      '/images/chekrr/folders/' +
                                                                      snapshot
                                                                          .data![
                                                                              index]
                                                                          .image_filename,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 12, 10, 5),
                                                          child: snapshot
                                                              .data![index]
                                                              .icon,
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 12, 0, 10),
                                                          child: Text(
                                                            snapshot
                                                                .data![index]
                                                                .name,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      0.637),
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
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
                                                                  5, 2, 0, 4),
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
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  20, 0, 0, 4),
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
                                                                  5, 2, 0, 4),
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
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              25, 10, 25, 15),
                                                      child: Text(
                                                        snapshot
                                                            .data![index].perex,
                                                        style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              255,
                                                              255,
                                                              255,
                                                              0.603),
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w200,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                25, 10, 25, 15),
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            foregroundColor:
                                                                Color.fromARGB(
                                                                    255,
                                                                    57,
                                                                    21,
                                                                    119),
                                                            backgroundColor:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    0.562),
                                                            minimumSize: const Size
                                                                .fromHeight(40),
                                                          ),
                                                          onPressed: () {
                                                            Get.toNamed(
                                                              '/challenge?id=' +
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .id
                                                                      .toString(),
                                                            );
                                                          },
                                                          child: Text(
                                                            'ZJISTIT V??CE',
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        )),
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
                                  ),
                                ),
                              ),
                            )
                          : Expanded(
                              flex: 1,
                              child: Center(
                                child: Text(
                                    '????dn?? dal???? programy nejsou k dispozici'),
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
