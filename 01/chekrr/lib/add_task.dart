import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'globals.dart' as globals;
import 'package:mysql1/mysql1.dart';
import 'bottomtab.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
//import 'dart:developer'

class AddTaskScreen extends StatefulWidget {
  AddTaskScreen({super.key, this.restorationId});
  @override
  final String? restorationId;
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> with RestorationMixin {
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  String errormsg = '';
  bool isChecked = false;
  bool error = false, showprogress = false;
  String name = '', password = '';
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
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  @override
  String? get restorationId => widget.restorationId;
  final RestorableDateTimeN _startDate = RestorableDateTimeN(DateTime(2021));
  final RestorableDateTimeN _endDate =
      RestorableDateTimeN(DateTime(2021, 1, 5));
  late final RestorableRouteFuture<DateTimeRange?>
      _restorableDateRangePickerRouteFuture =
      RestorableRouteFuture<DateTimeRange?>(
    onComplete: _selectDateRange,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator
          .restorablePush(_dateRangePickerRoute, arguments: <String, dynamic>{
        'initialStartDate': _startDate.value?.millisecondsSinceEpoch,
        'initialEndDate': _endDate.value?.millisecondsSinceEpoch,
      });
    },
  );
  void _selectDateRange(DateTimeRange? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _startDate.value = newSelectedDate.start;
        _endDate.value = newSelectedDate.end;
      });
    }
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_startDate, 'start_date');
    registerForRestoration(_endDate, 'end_date');
    registerForRestoration(
        _restorableDateRangePickerRouteFuture, 'date_picker_route_future');
  }

  static Route<DateTimeRange?> _dateRangePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTimeRange?>(
      context: context,
      builder: (BuildContext context) {
        return DateRangePickerDialog(
          restorationId: 'date_picker_dialog',
          initialDateRange:
              _initialDateTimeRange(arguments! as Map<dynamic, dynamic>),
          firstDate: DateTime(2021),
          currentDate: DateTime(2021, 1, 25),
          lastDate: DateTime(2022),
        );
      },
    );
  }

  static DateTimeRange? _initialDateTimeRange(Map<dynamic, dynamic> arguments) {
    if (arguments['initialStartDate'] != null &&
        arguments['initialEndDate'] != null) {
      return DateTimeRange(
        start: DateTime.fromMillisecondsSinceEpoch(
            arguments['initialStartDate'] as int),
        end: DateTime.fromMillisecondsSinceEpoch(
            arguments['initialEndDate'] as int),
      );
    }

    return null;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final String test = 'Hovnajs';

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Přidat výzvu'),
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Uložit výzvu',
            onPressed: () {
              /*showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    // Retrieve the text the that user has entered by using the
                    // TextEditingController.
                    content: Text(myController.text),
                  );
                },
              );*/
              AddTask(myController.text, dropdownValue2, dropdownValue);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Výzva vložena'),
                  //content: Text(AddTask()),
                ),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            //show error message here
            margin: EdgeInsets.only(top: 0),
            padding: EdgeInsets.all(10),
            //child: error ? errmsg(errormsg) : Container(),
            //if error == true then show error message
            //else set empty container as child
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            margin: EdgeInsets.only(top: 0),
            child: TextField(
              controller: myController, //set username controller
              style: TextStyle(
                //color: Color.fromARGB(255, 216, 216, 216),
                fontSize: 20,
              ),
              decoration: myInputDecoration(
                label: "Text výzvy",
                icon: Icons.person,
              ),
              onChanged: (value) {
                //set username  text on change
                name = value;
              },
            ),
          ),
          Container(
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
              ],
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
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            margin: EdgeInsets.only(top: 10),
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
                    items:
                        timecount.map<DropdownMenuItem<String>>((String value) {
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
                        dropdownValue = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            margin: EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text('test'),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: OutlinedButton(
                      onPressed: () {
                        _restorableDateRangePickerRouteFuture.present();
                      },
                      child: const Text('Open Date Range Picker'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      //bottomNavigationBar: BottomTabs(),
    );
  }
}

InputDecoration myInputDecoration(
    {required String label, required IconData icon}) {
  return InputDecoration(
    hintText: label, //show label as placeholder
    hintStyle: TextStyle(
        color: Color.fromRGBO(255, 255, 255, 0.699),
        fontSize: 20), //hint text style
    prefixIcon: Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Icon(
        icon,
        color: Color.fromRGBO(255, 255, 255, 1),
      ),
      //padding and icon for prefix
    ),

    contentPadding: EdgeInsets.fromLTRB(30, 20, 30, 20),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide: BorderSide(
            color: (Color.fromRGBO(255, 255, 255, 0.103))!,
            width: 1)), //default border of input

    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(0),
        borderSide: BorderSide(
            color: (Color.fromRGBO(255, 255, 255, 0.103))!,
            width: 1)), //focus border

    fillColor: Color.fromARGB(33, 167, 167, 167),
    filled: true, //set true if you want to show input background
  );
}

class TaskDetails {
  String name;
  int uid;
  var schedule_count;
  var schedule_unit;

  TaskDetails(this.name, this.uid, this.schedule_count, this.schedule_unit);

  @override
  String toString() {
    return '{ ${this.name}, ${this.uid} }';
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
    'uid': globals.uid.toString(),
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
