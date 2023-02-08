import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/challenge.dart';
import 'package:get_storage/get_storage.dart';
import '../globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'package:drop_shadow/drop_shadow.dart';
import 'package:flutter/services.dart';

class ChallengeScreen extends StatefulWidget {
  ChallengeScreen({super.key});

  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  late Future<List<ProgramFull>> _future;
  Future<List<ProgramFull>> getProgramFull() async {
    final box = GetStorage();
    var uid = box.read('uid');
    try {
      Map<String, dynamic> requestbody = {
        //'uid': globals.uid.toString(),
        'uid': uid.toString(),
        'id': Get.parameters['id'].toString(),
      };
      var url = Uri.parse(globals.globalProtocol +
          globals.globalURL +
          '/api/index.php/challenge/detail');
      http.Response response = await http.post(
          Uri.parse(globals.globalProtocol +
              globals.globalURL +
              '/api/index.php/challenge/detail/' +
              Get.parameters['id'].toString()),
          headers: <String, String>{
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            //'Content-Type': 'application/json; charset=UTF-8',
          },
          body: requestbody);
      if (response.statusCode == 200) {
        return ProgramFullFromJson(response.body);
      } else {
        return <ProgramFull>[];
      }
    } catch (e) {
      return <ProgramFull>[]; // return an empty list on exception/error
    }
  }

  late GlobalKey<ScaffoldState> _scaffoldKey;
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
      ),
    );
    _scaffoldKey = GlobalKey();
    super.initState();
    _future = getProgramFull();
  }

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    var uid = box.read('uid');
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(7.0, 6.0, 7.0, 6.0),
            child: ElevatedButton.icon(
              onPressed: () {
                AddProgram(
                  Get.parameters['id'],
                  uid,
                ).then((value) => Get.offAllNamed('/home'));
                showDialog(
                    // The user CANNOT close this dialog  by pressing outsite it
                    barrierDismissible: false,
                    context: context,
                    builder: (_) {
                      return Dialog(
                        backgroundColor: Color.fromARGB(20, 0, 0, 0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                        /*
            put a CircularProgressIndicator() here
            */
                      );
                    });
                Get.showSnackbar(
                  GetSnackBar(
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Color.fromARGB(200, 0, 0, 0),
                    title: 'Výzva přijata',
                    message: 'Jdi do toho!',
                    icon: const Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              icon: Icon(
                // <-- Icon
                Icons.add,
                size: 25.0,
              ),
              label: Text('Přijmout výzvy'),
              style: ButtonStyle(
                /*shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),*/
                foregroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 214, 214, 214)),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(100, 57, 21, 119)),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/chekrr_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
        child: FutureBuilder(
          future: _future,
          builder: (context, AsyncSnapshot<List<ProgramFull>> snapshot) {
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
                                margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
                                child: ListView.builder(
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
                                      visualDensity: VisualDensity(vertical: 3),
                                      title: Container(
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: Image(
                                                  image: NetworkImage(
                                                    globals.globalProtocol +
                                                        globals.globalURL +
                                                        '/images/chekrr/folders/' +
                                                        snapshot.data![index]
                                                            .image_filename,
                                                  ),
                                                ),
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
                                                            0, 15, 10, 5),
                                                    child: snapshot
                                                        .data![index].icon,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 15, 0, 10),
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
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 1, 10, 5),
                                                    child: Icon(
                                                      Icons.checklist,
                                                      size: 25,
                                                      color: Color.fromRGBO(
                                                          255, 255, 255, 0.685),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 5, 0, 10),
                                                    child: Text(
                                                      snapshot.data![index]
                                                              .challenge_count
                                                              .toString() +
                                                          ' výzev',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            255,
                                                            255,
                                                            255,
                                                            0.575),
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      ),
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
                                                            0, 1, 10, 5),
                                                    child: Icon(
                                                      Icons.calendar_month,
                                                      size: 25,
                                                      color: Color.fromRGBO(
                                                          255, 255, 255, 0.685),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 5, 0, 10),
                                                    child: Text(
                                                      snapshot.data![index]
                                                              .day_count
                                                              .toString() +
                                                          ' dnů',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            255,
                                                            255,
                                                            255,
                                                            0.575),
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Html(
                                                data:
                                                    snapshot.data![index].text,
                                              ),
                                            ],
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
                                    'Žádné další programy nejsou k dispozici'),
                              ),
                            ),
                    ],
                  );
                  /*return Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                          //scrollDirection: Axis.horizontal,
                          key: _scaffoldKey,
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) => Dismissible(
                            key: UniqueKey(),
                            child: ListTile(
                              onTap: () {
                                /*Get.toNamed(
                                '/challenge?id=' +
                                    snapshot.data![index].id.toString(),
                              );*/
                              },
                              visualDensity: VisualDensity(vertical: 1),
                              title: Card(
                                elevation: 5,
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      DropShadow(
                                        child: Image(
                                          image: NetworkImage(
                                            globals.globalProtocol +
                                                globals.globalURL +
                                                '/images/chekrr/folders/' +
                                                snapshot.data![index]
                                                    .image_filename,
                                          ),
                                        ),
                                        blurRadius: 3,
                                        opacity: 0.9,
                                        spread: 0.3,
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 12, 0, 10),
                                        child: Text(
                                          snapshot.data![index].name,
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 0.801),
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Počet výzev: ' +
                                            snapshot
                                                .data![index].challenge_count
                                                .toString(),
                                        style: TextStyle(
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.801),
                                          fontSize: 17,
                                        ),
                                      ),
                                      Text(
                                        'Délka programu: ' +
                                            snapshot.data![index].day_count
                                                .toString() +
                                            ' dnů',
                                        style: TextStyle(
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.801),
                                          fontSize: 17,
                                        ),
                                      ),
                                      Html(
                                        data: snapshot.data![index].text,
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
                  );*/
                }
            }
          },
        ),
      ),
    );
  }
}

Future<http.Response> AddProgram(
  var pid,
  var uid,
) async {
  //var conn = await MySqlConnection.connect(globals.dbSettings);
  final program = ProgramDetails(pid, uid);
  Map<String, dynamic> body = {
    'pid': pid.toString(),
    'uid': uid.toString(),
  };
  final response =
      await http.post(Uri.parse('https://chekrr.cz/api/add_program.php'),
          headers: <String, String>{
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
          },
          body: body);
  if (response.statusCode == 200) {
  } else {
    throw Exception('Failed to create program - ' +
        response.body +
        ' / ' +
        response.statusCode.toString());
  }
  return response;
}
