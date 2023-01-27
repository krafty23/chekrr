import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/challenge.dart';
import 'package:get_storage/get_storage.dart';
import '../globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
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
                                    Text(
                                      'Počet výzev: ' +
                                          snapshot.data![index].challenge_count
                                              .toString(),
                                      style: TextStyle(
                                        color: Color.fromRGBO(
                                            255, 255, 255, 0.801),
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
