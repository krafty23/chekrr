import 'package:chekrr/screens/add_task.dart';
import "package:flutter/material.dart";
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:io';
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
    try {
      //http.Response response = await http.post(
      // "https://***************.000webhostapp.com/*************.php",
      // );
      Map<String, dynamic> requestbody = {
        //'uid': globals.uid.toString(),
        'uid': "23",
      };
      var url = Uri.parse(globals.globalProtocol +
          globals.globalURL +
          '/api/index.php/task/list');
      print(url);
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
      print(response.body);
      /*String jsonString = '''
      [{"id":1,"name":"PAKISTANI","status":0},{"id":3,"name":"INDIAN","status":0},{"id":4,"name":"abc","status":0},{"id":5,"name":"def","status":0},{"id":6,"name":"hi","status":0}]
      ''';*/
      //http.Response response = http.Response(jsonString, 200);

      //print('getCategory Response: ${response.body}');
      if (response.statusCode == 200) {
        return TaskFromJson(response.body);
      } else {
        return <Task>[];
      }
    } catch (e) {
      return <Task>[]; // return an empty list on exception/error
    }
  }

  @override
  void initState() {
    _future = getTask();
    super.initState();
  }

  Widget build(BuildContext context) {
    //final TaskController taskController = Get.put(TaskController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Můj Plán"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        child: Icon(Icons.add),
        onPressed: () {
          Get.toNamed('/add_task');
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
                          Get.showSnackbar(
                            GetSnackBar(
                              title: 'Gratulace!',
                              message: 'Výzva splněna',
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
                          Get.showSnackbar(
                            GetSnackBar(
                              title: 'Příště to vyjde!',
                              message: 'Výzva nesplněna',
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
                        Get.showSnackbar(
                          GetSnackBar(
                            title: 'Hovno!',
                            message: 'Ser na to',
                            icon: const Icon(
                              Icons.percent,
                              color: Colors.green,
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
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
