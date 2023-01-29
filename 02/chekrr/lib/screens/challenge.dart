import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/challenge.dart';
import 'package:get_storage/get_storage.dart';
import '../globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'package:drop_shadow/drop_shadow.dart';

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
    _scaffoldKey = GlobalKey();
    super.initState();
    _future = getProgramFull();
  }

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    var uid = box.read('uid');
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(7.0, 6.0, 7.0, 6.0),
            child: ElevatedButton.icon(
              onPressed: () {
                AddProgram(
                  Get.parameters['id'],
                  uid,
                ).then((value) => Get.offAllNamed('/home'));
                Get.showSnackbar(
                  GetSnackBar(
                    title: 'Výzva přijata',
                    message: 'Výzva ',
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
                size: 30.0,
              ),
              label: Text('Přijmout výzvy'),
              style: ButtonStyle(
                /*shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),*/
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.8);
                    }
                    return null; // Use the component's default.
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    DropShadow(
                                      child: Image(
                                        image: NetworkImage(
                                          globals.globalProtocol +
                                              globals.globalURL +
                                              '/images/chekrr/folders/' +
                                              snapshot
                                                  .data![index].image_filename,
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
                                          snapshot.data![index].challenge_count
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
                );
              }
          }
        },
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
