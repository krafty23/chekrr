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

class HistoryScreen extends StatefulWidget {
  HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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
          '/api/index.php/task/history');
      http.Response response = await http.post(url,
          headers: <String, String>{
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            //'Content-Type': 'application/json; charset=UTF-8',
          },
          body: requestbody);
      //print(response.body);
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

  late GlobalKey<ScaffoldState> _scaffoldKey;
  @override
  void initState() {
    _scaffoldKey = GlobalKey();
    super.initState();
    _future = getTask();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Historie & Statistiky"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Text('ddd'),
          ),
          Expanded(
            flex: 1,
            child: FutureBuilder(
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
                                children: [
                                  Icon(
                                    (snapshot.data![index].status == 1)
                                        ? Icons.check
                                        : Icons.cancel,
                                    color: (snapshot.data![index].status == 1)
                                        ? Colors.green
                                        : Colors.red,
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
          ),
        ],
      ),
    );
  }
}
