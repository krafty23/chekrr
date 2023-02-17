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

  Future<void> _dialogConfirmer(BuildContext context, int data) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(213, 131, 1, 1),
          title: Text(
            'Opravdu zrušit program?',
            style: TextStyle(
              color: Color.fromRGBO(255, 255, 255, 0.692),
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Text(
                  'Opravdu si přejete zrušit program?',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.459),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 214, 214, 214)),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 255, 0, 0)),
              ),
              child: const Text('Ano'),
              onPressed: () {
                HapticFeedback.heavyImpact();
                DeleteProgram(data).then((value) => Get.toNamed(
                      '/home',
                    ));
                Get.showSnackbar(
                  GetSnackBar(
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Color.fromARGB(200, 0, 0, 0),
                    title: 'Program zrušen',
                    message: 'Příště to vyjde',
                    icon: const Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 255, 255, 255)),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(126, 0, 0, 0)),
              ),
              child: const Text('Ne'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
    if (Get.parameters['is_accepted'] == null) {
      Get.parameters['is_accepted'] = '0';
    }
    final box = GetStorage();
    var uid = box.read('uid');
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        title: Text(''),
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
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                padding: EdgeInsets.zero,
                                child: ListView.builder(
                                  padding: EdgeInsets.all(0),
                                  key: _scaffoldKey,
                                  itemCount: snapshot.data?.length,
                                  itemBuilder: (context, index) => Container(
                                    padding: EdgeInsets.all(0),
                                    margin: EdgeInsets.all(0),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(0)),
                                    ),
                                    child: ListTile(
                                      minVerticalPadding: 0,
                                      contentPadding:
                                          EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      visualDensity: VisualDensity(
                                          horizontal: 0, vertical: -4),
                                      title: Container(
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              ClipRRect(
                                                child: ShaderMask(
                                                  shaderCallback: (rect) {
                                                    return LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        Colors.black,
                                                        Colors.transparent
                                                      ],
                                                    ).createShader(
                                                        Rect.fromLTRB(
                                                            0,
                                                            rect.height - 100,
                                                            rect.width,
                                                            rect.height));
                                                  },
                                                  blendMode: BlendMode.dstIn,
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
                                              ),
                                              Transform.translate(
                                                offset: Offset(0, -16),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 10, 0),
                                                      child: snapshot
                                                          .data![index].icon,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 0, 5),
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
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 0, 5, 5),
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
                                                            0, 4, 0, 10),
                                                    child: Text(
                                                      snapshot.data![index]
                                                          .challenge_count
                                                          .toString(),
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
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            20, 0, 5, 5),
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
                                                            0, 4, 0, 10),
                                                    child: Text(
                                                      snapshot.data![index]
                                                          .day_count
                                                          .toString(),
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
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    15, 1, 15, 0),
                                                child: Html(
                                                  data: snapshot
                                                      .data![index].text,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    15, 0, 15, 20),
                                                child: Center(
                                                  child: Text(
                                                    'Co získáš?',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          244, 157, 55, 0.575),
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    15, 0, 15, 20),
                                                child: Center(
                                                  child: Text(
                                                    snapshot.data![index]
                                                            .challenge_count
                                                            .toString() +
                                                        ' VÝZEV NA ' +
                                                        snapshot.data![index]
                                                            .day_count
                                                            .toString() +
                                                        ' DNÍ',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          255, 255, 255, 0.575),
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 90),
                                              )
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
                }
            }
          },
        ),
      ),
      persistentFooterButtons: [
        Padding(
          padding: EdgeInsets.fromLTRB(7.0, 6.0, 7.0, 6.0),
          child: int.parse(Get.parameters['is_accepted']!) > 0
              ? ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    _dialogConfirmer(context, int.parse(Get.parameters['id']!));
                  },
                  icon: Icon(
                    // <-- Icon
                    Icons.cancel,
                    size: 25.0,
                  ),
                  label: Text('Zrušit program...'),
                  style: ButtonStyle(
                    /*shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),*/
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(15)),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 214, 214, 214)),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 119, 21, 21)),
                  ),
                )
              : ElevatedButton.icon(
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
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(15)),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 214, 214, 214)),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 75, 21, 119)),
                  ),
                ),
        ),
      ],
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

Future<http.Response> DeleteProgram(int id) async {
  final task = id;
  final box = GetStorage();
  var uid = box.read('uid');
  Map<String, dynamic> body = {
    'id': id.toString(),
    'is_accepted': '1',
    'uid': uid.toString(),
  };
  final response = await http.post(
      Uri.parse(globals.globalProtocol +
          globals.globalURL +
          '/api/delete_program.php'),
      headers: <String, String>{
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        //'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body);
  if (response.statusCode == 200) {
    //print(response.body);
  } else {
    throw Exception('Chyba: nepodařilo se označit výzvu jako zrušenou - ' +
        response.body +
        ' / ' +
        response.statusCode.toString());
  }
  return response;
}
