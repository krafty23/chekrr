import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/challenge.dart';
import 'package:get_storage/get_storage.dart';
import '../globals.dart' as globals;
import '../models/stats.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'package:drop_shadow/drop_shadow.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ChallengeScreen extends StatefulWidget {
  ChallengeScreen({super.key});

  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  late Future<List<ProgramFull>> _future;
  late Future<List<yxnType>> _future2;
  late Future<List<ProgramSubinfo>> _futurex;
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

  Future<List<yxnType>> getYxn() async {
    final box = GetStorage();
    var uid = box.read('uid');
    try {
      Map<String, dynamic> requestbody = {
        'uid': uid.toString(),
        'id': Get.parameters['id'].toString(),
      };
      var url = Uri.parse(globals.globalProtocol +
          globals.globalURL +
          '/api/index.php/stats/challengeyxn');
      http.Response response = await http.post(url,
          headers: <String, String>{
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            //'Content-Type': 'application/json; charset=UTF-8',
          },
          body: requestbody);
      if (response.statusCode == 200) {
        return yxnTypeFromJson(response.body);
      } else {
        return <yxnType>[];
      }
    } catch (e) {
      return <yxnType>[]; // return an empty list on exception/error
    }
  }

  Future<List<ProgramSubinfo>> getProgramSubinfo() async {
    final box = GetStorage();
    var uid = box.read('uid');
    try {
      Map<String, dynamic> requestbody = {
        'uid': uid.toString(),
        'id': Get.parameters['id'].toString(),
        'instance_id': Get.parameters['instance_id'].toString(),
      };
      http.Response response = await http.post(
          Uri.parse(globals.globalProtocol +
              globals.globalURL +
              '/api/index.php/challenge/subinfo/'),
          headers: <String, String>{
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            //'Content-Type': 'application/json; charset=UTF-8',
          },
          body: requestbody);
      if (response.statusCode == 200) {
        return ProgramSubinfoFromJson(response.body);
      } else {
        return <ProgramSubinfo>[];
      }
    } catch (e) {
      return <ProgramSubinfo>[]; // return an empty list on exception/error
    }
  }

  Future<void> _dialogConfirmer(BuildContext context, int data) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(213, 131, 1, 1),
          title: Text(
            'Opravdu zru??it program?',
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
                  'Opravdu si p??ejete zru??it program?',
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
                    title: 'Program zru??en',
                    message: 'P??????t?? to vyjde',
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
    if (Get.parameters['instance_id'] != null) {
      //getProgramFull().whenComplete(() {
      _futurex = getProgramSubinfo();
      _future2 = getYxn();
      //});
    }
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
                                              if (Get.parameters[
                                                      'instance_id'] !=
                                                  null) ...[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0, 10, 0, 0),
                                                        child: Stack(
                                                          alignment:
                                                              AlignmentDirectional
                                                                  .center,
                                                          children: <Widget>[
                                                            Center(
                                                              child:
                                                                  new CircularPercentIndicator(
                                                                radius: 85,
                                                                animation: true,
                                                                animationDuration:
                                                                    600,
                                                                lineWidth: 10.0,
                                                                percent: 0.4,
                                                                center:
                                                                    new Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "den",
                                                                      style: new TextStyle(
                                                                          color: Color.fromARGB(
                                                                              80,
                                                                              255,
                                                                              255,
                                                                              255),
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              20.0),
                                                                    ),
                                                                    Text(
                                                                      "1 / 15",
                                                                      style: new TextStyle(
                                                                          color: Color.fromARGB(
                                                                              101,
                                                                              255,
                                                                              255,
                                                                              255),
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              27.0),
                                                                    ),
                                                                  ],
                                                                ),
                                                                circularStrokeCap:
                                                                    CircularStrokeCap
                                                                        .butt,
                                                                backgroundColor:
                                                                    Color
                                                                        .fromARGB(
                                                                            129,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                progressColor:
                                                                    Color.fromARGB(
                                                                        64,
                                                                        255,
                                                                        255,
                                                                        255),
                                                              ),
                                                            ),
                                                            Center(
                                                              child:
                                                                  new CircularPercentIndicator(
                                                                radius: 70,
                                                                animation: true,
                                                                animationDuration:
                                                                    900,
                                                                lineWidth: 12.0,
                                                                percent: 0.7,
                                                                center:
                                                                    Text(''),
                                                                circularStrokeCap:
                                                                    CircularStrokeCap
                                                                        .butt,
                                                                backgroundColor:
                                                                    Color
                                                                        .fromARGB(
                                                                            54,
                                                                            255,
                                                                            1,
                                                                            1),
                                                                progressColor:
                                                                    Color
                                                                        .fromARGB(
                                                                            69,
                                                                            0,
                                                                            255,
                                                                            64),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                FutureBuilder(
                                                  future: _futurex,
                                                  builder: (context,
                                                      AsyncSnapshot<
                                                              List<
                                                                  ProgramSubinfo>>
                                                          snapshotx) {
                                                    switch (snapshotx
                                                        .connectionState) {
                                                      case ConnectionState.none:
                                                        return Text('none');
                                                      case ConnectionState
                                                          .waiting:
                                                        return Center();
                                                      case ConnectionState
                                                          .active:
                                                        return Text('');
                                                      case ConnectionState.done:
                                                        if (snapshotx
                                                            .hasError) {
                                                          return Text(
                                                            '${snapshotx.error}',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          );
                                                        } else {
                                                          print(snapshotx
                                                              .data?.length);
                                                          return Center(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          10,
                                                                          10,
                                                                          0),
                                                              child: DataTable(
                                                                //headingRowHeight:
                                                                // 0,
                                                                columns: const <
                                                                    DataColumn>[
                                                                  DataColumn(
                                                                    label: Text(
                                                                        'V??zva'),
                                                                  ),
                                                                  DataColumn(
                                                                    label: Text(
                                                                        'Spln??no'),
                                                                  ),
                                                                ],
                                                                rows: List<
                                                                    DataRow>.generate(
                                                                  snapshotx
                                                                      .data!
                                                                      .length,
                                                                  (int index) =>
                                                                      DataRow(
                                                                    cells: <
                                                                        DataCell>[
                                                                      DataCell(Text(snapshotx
                                                                          .data![
                                                                              index]
                                                                          .name)),
                                                                      DataCell(
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              snapshotx.data![index].done_count.toString(),
                                                                              style: TextStyle(
                                                                                color: Color.fromRGBO(0, 243, 32, 0.69),
                                                                                fontSize: 22,
                                                                                fontWeight: FontWeight.w900,
                                                                              ),
                                                                            ),
                                                                            Text(' / '),
                                                                            Text(
                                                                              snapshotx.data![index].canceled_count.toString(),
                                                                              style: TextStyle(
                                                                                color: Color.fromRGBO(255, 0, 0, 0.686),
                                                                                fontSize: 22,
                                                                                fontWeight: FontWeight.w900,
                                                                              ),
                                                                            ),
                                                                            Text(' / '),
                                                                            Text(
                                                                              snapshotx.data![index].endday.toString(),
                                                                              style: TextStyle(
                                                                                color: Color.fromRGBO(255, 255, 255, 0.686),
                                                                                fontSize: 22,
                                                                                fontWeight: FontWeight.w900,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                    }
                                                  },
                                                ),
                                              ],
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
                                                    'Co z??sk?????',
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
                                                        ' V??ZEV NA ' +
                                                        snapshot.data![index]
                                                            .day_count
                                                            .toString() +
                                                        ' DN??',
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
                  label: Text('Zru??it program...'),
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
                        title: 'V??zva p??ijata',
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
                  label: Text('P??ijmout v??zvy'),
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
    throw Exception('Chyba: nepoda??ilo se ozna??it v??zvu jako zru??enou - ' +
        response.body +
        ' / ' +
        response.statusCode.toString());
  }
  return response;
}
