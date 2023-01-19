import 'package:chekrr/screens/HomeScreen.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../globals.dart' as globals;
import '../controllers/TaskController.dart';
import '../models/task.dart';
import 'package:mysql1/mysql1.dart';

class AddTaskScreen extends StatefulWidget {
  AddTaskScreen({super.key, this.restorationId});
  @override
  final String? restorationId;
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskController taskController = Get.find();
  static const List<String> timecount = <String>[
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
  ];
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("dnů"), value: "1"),
      DropdownMenuItem(child: Text("týdnů"), value: "2"),
      DropdownMenuItem(child: Text("měsíců"), value: "3"),
      DropdownMenuItem(child: Text("let"), value: "4"),
    ];
    return menuItems;
  }

  String selectedValue = "1";
  static const List<String> list = <String>['dnů', 'týdnů', 'měsíců', 'let'];
  String dropdownValue2 = timecount.first;
  String dropdownValue = list.first;
  String errormsg = '';
  bool isChecked = true;
  bool isChecked2 = true;
  bool isChecked3 = true;
  bool isChecked4 = true;
  bool isChecked5 = true;
  bool isChecked6 = true;
  bool isChecked7 = true;
  /*final int index;
  AddTaskScreen({this.index});*/
  @override
  TextEditingController textEditingController = TextEditingController();
  Widget build(BuildContext context) {
    String name = '';
    /*if (!this.index.isNull) {
      name = taskController.tasks[index].name;
    }*/

    return Scaffold(
      appBar: AppBar(
        title: Text('Vložit výzvu'),
      ),
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: textEditingController,
                autofocus: true,
                decoration: InputDecoration(
                    hintText: 'Jaká bude Vaše další výzva?',
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none),
                style: TextStyle(
                  fontSize: 25.0,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 100,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              margin: EdgeInsets.only(top: 10),
              child: Center(
                child: Text('Naplanovat na dalších'),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              margin: EdgeInsets.only(top: 0, bottom: 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: DropdownButton<String>(
                      value: dropdownValue2,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(
                        color: Color.fromRGBO(179, 179, 179, 1),
                        fontSize: 25.0,
                      ),
                      underline: SizedBox(),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValue2 = value!;
                        });
                      },
                      items: timecount
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: DropdownButton<String>(
                      items: dropdownItems,
                      value: selectedValue,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(
                          color: Color.fromRGBO(179, 179, 179, 1),
                          fontSize: 25.0),
                      /*underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),*/
                      underline: SizedBox(),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          selectedValue = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'P',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          Checkbox(
                            checkColor: Colors.white,
                            //fillColor: MaterialStateProperty.resolveWith(getColor),
                            //value: Get.find<TaskController>().isChecked,
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'U',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          Checkbox(
                            checkColor: Colors.white,
                            //fillColor: MaterialStateProperty.resolveWith(getColor),
                            value: isChecked2,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked2 = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'S',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          Checkbox(
                            checkColor: Colors.white,
                            //fillColor: MaterialStateProperty.resolveWith(getColor),
                            value: isChecked3,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked3 = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Č',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          Checkbox(
                            checkColor: Colors.white,
                            //fillColor: MaterialStateProperty.resolveWith(getColor),
                            value: isChecked4,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked4 = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'P',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          Checkbox(
                            checkColor: Colors.white,
                            //fillColor: MaterialStateProperty.resolveWith(getColor),
                            value: isChecked5,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked5 = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'S',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          Checkbox(
                            checkColor: Colors.white,
                            //fillColor: MaterialStateProperty.resolveWith(getColor),
                            value: isChecked6,
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked6 = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'N',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          Checkbox(
                            checkColor: Colors.white,
                            //fillColor: MaterialStateProperty.resolveWith(getColor),
                            value: isChecked7,
                            onChanged: (bool? value) {
                              //isChecked.value = value!;
                              //taskController.checkDay(value!);
                              setState(() {
                                isChecked7 = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    child: Text('Vložit'),
                    //child: Text((this.index.isNull) ? 'Add' : 'Edit'),
                    onPressed: () {
                      /*if (this.index.isNull) {*/
                      taskController.tasks
                          .add(Task(name: textEditingController.text));
                      AddTask(
                        textEditingController.text,
                        dropdownValue2,
                        selectedValue,
                      );
                      /*
                    } else {
                      var editing = todoController.todos[index];
                      editing.text = textEditingController.text;
                      todoController.todos[index] = editing;
                    }*/

                      Get.back();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<http.Response> AddTask(
    String name, var schedule_count, var schedule_unit) async {
  var conn = await MySqlConnection.connect(globals.dbSettings);
  final task = TaskDetails(name, globals.uid, schedule_count, schedule_unit);
  /*Map<String, dynamic> body = {
    'name': name,
    'uid': 30,
    'homeTeam': json.encode(
      {'team': 'Team A'},
    ),
    'awayTeam': json.encode(
      {'team': 'Team B'},
    ),
  };*/
  Map<String, dynamic> body = {
    'name': name,
    //'uid': globals.uid.toString(),
    'uid': 23,
    'schedule_count': schedule_count,
    'schedule_unit': schedule_unit
  };
  //debugPrint(body.toString());
  //final response = await http.get(url);
  final response =
      await http.post(Uri.parse('https://chekrr.cz/api/add_task.php'),
          headers: <String, String>{
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            //'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body);
  if (response.statusCode == 200) {
    // if server response 200 / OK
    //return jsonDecode(response.body);
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create task - ' +
        response.body +
        ' / ' +
        response.statusCode.toString());
  }
  return response;
}
