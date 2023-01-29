import 'package:chekrr/screens/add_task.dart';
import "package:flutter/material.dart";
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import '../globals.dart' as globals;
import '../controllers/TaskController.dart';
import 'package:chekrr/drawer.dart';
import 'package:http/http.dart' as http;
import '../models/task.dart';
import '../bottomtab.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
//class HomeScreen extends StatelessWidget {
  late Future<List<Task>> _future;
  Future<List<Task>> getTask() async {
    final box = GetStorage();
    var uid = box.read('uid');
    try {
      Map<String, dynamic> requestbody = {
        //'uid': globals.uid.toString(),
        'uid': uid.toString(),
      };
      var url = Uri.parse(globals.globalProtocol +
          globals.globalURL +
          '/api/index.php/task/list');
      http.Response response = await http.post(
          Uri.parse(globals.globalProtocol +
              globals.globalURL +
              '/api/index.php/task/list'),
          headers: <String, String>{
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            //'Content-Type': 'application/json; charset=UTF-8',
          },
          body: requestbody);
      if (response.statusCode == 200) {
        return TaskFromJson(response.body);
      } else {
        return <Task>[];
      }
    } catch (e) {
      return <Task>[]; // return an empty list on exception/error
    }
  }

  late GlobalKey<ScaffoldState> _scaffoldKey;
  @override
  void initState() {
    _scaffoldKey = GlobalKey();
    super.initState();
    _future = getTask();
  }

  @override
  /*void reassemble() {
    super.initState();
    _future = getTask();
    _scaffoldKey = GlobalKey();
    super.reassemble();
  }*/

  Widget build(BuildContext context) {
    //final TaskController taskController = Get.put(TaskController());

    return Scaffold(
      appBar: AppBar(
        title: Text("Můj Plán Dne"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        child: Icon(Icons.add),
        onPressed: () {
          Get.toNamed('/add_task')?.then((result) {
            _future = getTask();
          });
          ;
        },
      ),
      drawer: DrawerDraw(),
      body: FutureBuilder(
        future: _future,
        builder: (context, AsyncSnapshot<List<Task>> snapshot) {
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
                return Container(
                  child: ListView.builder(
                    key: _scaffoldKey,
                    //separatorBuilder: (_, __) => Divider(),
                    //itemCount: taskController.tasks.length,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) => Dismissible(
                      confirmDismiss: (direction) async {
                        bool delete = true;
                        if (direction == DismissDirection.startToEnd) {
                          /*setState(() {
                    flavors[index] =
                        flavor.copyWith(isFavorite: !flavor.isFavorite);
                  });*/
                          FinishTask(snapshot.data![index].id.toString());
                          Get.showSnackbar(
                            GetSnackBar(
                              title: 'Gratulace!',
                              message: 'Výzva ' +
                                  snapshot.data![index].name +
                                  ' splněna',
                              icon: const Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          return delete;
                        } else {
                          bool delete = true;
                          RejectTask(snapshot.data![index].id.toString());
                          Get.showSnackbar(
                            GetSnackBar(
                              title: 'Příště to vyjde!',
                              message: 'Výzva ' +
                                  snapshot.data![index].name +
                                  ' nesplněna',
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          return delete;
                        }
                      },
                      onDismissed: (_) {
                        /*Get.showSnackbar(
                          GetSnackBar(
                            title: 'Hovno!',
                            message: 'Ser na to',
                            icon: const Icon(
                              Icons.percent,
                              color: Colors.green,
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );*/
                      },
                      background: Container(
                        color: Colors.green,
                        child: Align(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Icon(Icons.check_circle),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                      secondaryBackground: Container(
                        color: Colors.red,
                        child: Align(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Icon(Icons.cancel),
                          ),
                          alignment: Alignment.centerRight,
                        ),
                      ),
                      key: UniqueKey(),
                      child: ListTile(
                        visualDensity: VisualDensity(vertical: 3),
                        title: Text(
                          //taskController.tasks[index].name,
                          snapshot.data![index].name,
                          style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 0.801),
                          ),
                        ),
                        onTap: () {
                          /*Get.to(AddTaskScreen(
                    index: index,
                  ));*/
                        },
                        onLongPress: () {
                          Get.showSnackbar(
                            GetSnackBar(
                              title: 'Klik!',
                              message: 'jde to',
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.blueGrey,
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.chevron_left,
                              color: Colors.red,
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.chevron_right,
                              color: Colors.green,
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
      bottomNavigationBar: BottomTabs(),
    );
  }
}

Future<http.Response> FinishTask(var id) async {
  //var conn = await MySqlConnection.connect(globals.dbSettings);
  final task = TaskId(id);
  Map<String, dynamic> body = {
    'id': id.toString(),
  };
  final response =
      await http.post(Uri.parse('https://chekrr.cz/api/finish_task.php'),
          headers: <String, String>{
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            //'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body);
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    throw Exception('Chyba: nepodařilo se označit výzvu jako dokončenou - ' +
        response.body +
        ' / ' +
        response.statusCode.toString());
  }
  return response;
}

Future<http.Response> RejectTask(var id) async {
  //var conn = await MySqlConnection.connect(globals.dbSettings);
  final task = TaskId(id);
  Map<String, dynamic> body = {
    'id': id.toString(),
  };
  final response =
      await http.post(Uri.parse('https://chekrr.cz/api/reject_task.php'),
          headers: <String, String>{
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            //'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body);
  if (response.statusCode == 200) {
    print(response.body);
  } else {
    throw Exception('Chyba: nepodařilo se označit výzvu jako zrušenou - ' +
        response.body +
        ' / ' +
        response.statusCode.toString());
  }
  return response;
}
