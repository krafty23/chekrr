import 'package:flutter/material.dart';
import '../models/challenge.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../globals.dart' as globals;

class ChallengesDoneScreen extends StatefulWidget {
  @override
  _ChallengesDoneScreenState createState() => _ChallengesDoneScreenState();
}

class _ChallengesDoneScreenState extends State<ChallengesDoneScreen> {
  late Future<List<ProgramDone>> _future;
  Future<List<ProgramDone>> getProgram() async {
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
              '/api/index.php/challenge/listdone'),
          headers: <String, String>{
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            //'Content-Type': 'application/json; charset=UTF-8',
          },
          body: requestbody);
      if (response.statusCode == 200) {
        return ProgramDoneFromJson(response.body);
      } else {
        return <ProgramDone>[];
      }
    } catch (e) {
      return <ProgramDone>[]; // return an empty list on exception/error
    }
  }

  @override
  void initState() {
    _scaffoldKey = GlobalKey();
    super.initState();
    _future = getProgram();
  }

  late GlobalKey<ScaffoldState> _scaffoldKey;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          title: Text("Splněné programy"),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/chekrr_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.fromLTRB(0, 90, 0, 0),
          child: Center(
            child: FutureBuilder(
              future: _future,
              builder: (context, AsyncSnapshot<List<ProgramDone>> snapshot) {
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
                                    child: ClipRRect(
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
                                              rect.height - 100,
                                              rect.width,
                                              rect.height));
                                        },
                                        blendMode: BlendMode.dstIn,
                                        child: ListView.builder(
                                          //scrollDirection: Axis.horizontal,
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 95),
                                          key: _scaffoldKey,
                                          itemCount: snapshot.data?.length,
                                          itemBuilder: (context, index) =>
                                              Container(
                                            margin:
                                                EdgeInsets.fromLTRB(5, 5, 5, 5),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Color.fromARGB(
                                                    31, 240, 157, 55),
                                              ),
                                              color: Color.fromARGB(
                                                  188, 28, 15, 45),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(2)),
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
                                                  EdgeInsets.fromLTRB(
                                                      3, 0, 3, 2),
                                              visualDensity:
                                                  VisualDensity(vertical: 3),
                                              title: Container(
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              10, 10, 10, 10),
                                                      width: 100,
                                                      height: 100,
                                                      decoration:
                                                          new BoxDecoration(
                                                        shape:
                                                            BoxShape.rectangle,
                                                        image:
                                                            new DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
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
                                                    Expanded(
                                                      flex: 2,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                5, 5, 5, 5),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              snapshot
                                                                  .data![index]
                                                                  .name,
                                                              style: TextStyle(
                                                                color: Color
                                                                    .fromRGBO(
                                                                        255,
                                                                        255,
                                                                        255,
                                                                        0.692),
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                              ),
                                                            ),
                                                            Container(
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border:
                                                                            Border(
                                                                          bottom:
                                                                              BorderSide(
                                                                            color: Color.fromARGB(
                                                                                24,
                                                                                255,
                                                                                255,
                                                                                255),
                                                                          ),
                                                                          right:
                                                                              BorderSide(
                                                                            color: Color.fromARGB(
                                                                                24,
                                                                                255,
                                                                                255,
                                                                                255),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            20,
                                                                            5,
                                                                            20,
                                                                            15),
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              '12.12.2023',
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(
                                                                                fontSize: 16,
                                                                                color: Color.fromARGB(120, 255, 255, 255),
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              '-',
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(
                                                                                fontSize: 16,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              '12.12.2023',
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(
                                                                                fontSize: 16,
                                                                                color: Color.fromARGB(120, 255, 255, 255),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Get.toNamed(
                                                                            '/challenges_done');
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          border:
                                                                              Border(
                                                                            bottom:
                                                                                BorderSide(
                                                                              color: Color.fromARGB(24, 255, 255, 255),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding: EdgeInsets.fromLTRB(
                                                                              20,
                                                                              5,
                                                                              20,
                                                                              15),
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Text(
                                                                                'Přijato',
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(
                                                                                  fontSize: 15,
                                                                                  color: Color.fromARGB(120, 255, 255, 255),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '15.12.2023',
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight.bold,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
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
        ),
      ),
    );
  }
}
