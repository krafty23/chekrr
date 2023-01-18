import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'globals.dart' as globals;
import 'package:chekrr/drawer.dart';
import 'bottomtab.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class MyPlanScreen extends StatefulWidget {
  const MyPlanScreen({Key? key}) : super(key: key);
  @override
  _MyPlanScreenState createState() => _MyPlanScreenState();
}

class _MyPlanScreenState extends State<MyPlanScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  late EmployeeDataSource employeeDataSource;
  late List<GridColumn> _columns;
  Map<String, dynamic> body = {
    'uid': globals.uid.toString(),
  };
  Future<Object> generateEmployeeList() async {
    var url = Uri.parse(globals.globalProtocol +
        globals.globalURL +
        '/api/index.php/task/list');
    final response = await http.post(url,
        headers: <String, String>{
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          //'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);
    var list = json.decode(response.body);

    // Convert the JSON to List collection.
    List<Employee> _employees =
        await list.map<Employee>((json) => Employee.fromJson(json)).toList();
    employeeDataSource = EmployeeDataSource(_employees);
    return _employees;
  }

  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridColumn(
        columnName: 'id',
        width: 0,
        label: Container(
          padding: EdgeInsets.all(16.0),
          alignment: Alignment.centerLeft,
          child: Text(
            'ID',
          ),
        ),
      ),
      GridColumn(
        columnName: 'name',
        label: Container(
          padding: EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            'Name',
          ),
        ),
      ),
      GridColumn(
        columnName: 'status',
        width: 0,
        label: Container(
          padding: EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            'Status',
          ),
        ),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _columns = getColumns();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Můj Plán'),
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Show Snackbar',
            onPressed: () {
              Navigator.pushNamed(context, '/add_task');
            },
          ),
        ],
      ),
      drawer: DrawerDraw(),
      body: FutureBuilder<Object>(
        future: generateEmployeeList(),
        builder: (context, data) {
          return data.hasData
              ? SfDataGrid(
                  allowPullToRefresh: true,
                  allowSwiping: true,
                  swipeMaxOffset: 100.0,
                  startSwipeActionsBuilder:
                      (BuildContext context, DataGridRow row, int rowIndex) {
                    return GestureDetector(
                        onTap: () {
                          employeeDataSource._employeeDataGridRows
                              .removeAt(rowIndex);
                          employeeDataSource.updateDataGrid();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Označeno jako splněné'),
                            ),
                          );
                        },
                        child: Container(
                            color: Colors.green,
                            child: Center(
                              child: Icon(
                                Icons.check,
                              ),
                            )));
                  },
                  endSwipeActionsBuilder:
                      (BuildContext context, DataGridRow row, int rowIndex) {
                    return GestureDetector(
                        onTap: () {
                          employeeDataSource._employeeDataGridRows
                              .removeAt(rowIndex);
                          employeeDataSource.updateDataGrid();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Označeno jako nesplněné'),
                            ),
                          );
                        },
                        child: Container(
                            color: Colors.redAccent,
                            child: Center(
                              child: Icon(Icons.close),
                            )));
                  },
                  source: employeeDataSource,
                  columns: _columns,
                  columnWidthMode: ColumnWidthMode.fill)
              : Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: 0.8,
                  ),
                );
        },
      ),
      /*body: Center(
        child: ElevatedButton(
          onPressed: () {
            //Get the current location
          },
          child: Text('Challenges'),
        ),
      ),*/
      bottomNavigationBar: BottomTabs(),
    );
  }
}

class EmployeeDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  EmployeeDataSource(this.employees) {
    buildDataGridRow();
  }

  get dataGridRows => null;

  void buildDataGridRow() {
    _employeeDataGridRows = employees
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<int>(columnName: 'status', value: e.status),
            ]))
        .toList();
  }

  List<Employee> employees = [];

  List<DataGridRow> _employeeDataGridRows = [];

  @override
  List<DataGridRow> get rows => _employeeDataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }

  void updateDataGridSource({required RowColumnIndex rowColumnIndex}) {
    notifyDataSourceListeners(rowColumnIndex: rowColumnIndex);
  }

  Map<String, dynamic> body = {
    'uid': globals.uid.toString(),
  };
  void updateDataGrid() {
    notifyListeners();
  }
}

class Employee {
  int id;
  String name;
  int status;

  Employee({required this.id, required this.name, required this.status});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: int.parse(json['id']),
      name: json['name'] as String,
      status: int.parse(json['status']),
    );
  }
}

/*
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}*/
