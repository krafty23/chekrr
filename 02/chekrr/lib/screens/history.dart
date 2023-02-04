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
import 'package:http/http.dart' as http;
import '../models/task.dart';
import '../models/stats.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/services.dart';

late TooltipBehavior _tooltipBehavior;

class HistoryScreen extends StatefulWidget {
  HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<Task>> _future;
  late Future<List<yxnType>> _future2;
  Future<List<Task>> getTask() async {
    final box = GetStorage();
    var uid = box.read('uid');
    try {
      Map<String, dynamic> requestbody = {
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
      if (response.statusCode == 200) {
        return TaskFromJson(response.body);
      } else {
        return <Task>[];
      }
    } catch (e) {
      return <Task>[]; // return an empty list on exception/error
    }
  }

  Future<List<yxnType>> getYxn() async {
    final box = GetStorage();
    var uid = box.read('uid');
    try {
      Map<String, dynamic> requestbody = {
        'uid': uid.toString(),
      };
      var url = Uri.parse(globals.globalProtocol +
          globals.globalURL +
          '/api/index.php/stats/yxn');
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

  late GlobalKey<ScaffoldState> _scaffoldKey;
  @override
  void initState() {
    /*SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
      ),
    );*/
    _scaffoldKey = GlobalKey();
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      format: 'point.x - point.y',
    );
    super.initState();
    _future = getTask();
    _future2 = getYxn();
  }

  static const List<String> listek = <String>[
    'Poslední týden',
    'Poslední měsíc',
    'Poslední rok'
  ];
  String selectedTime = "1";
  String dropdownValue = listek.first;
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('20.1.', 5, 9),
      ChartData('21.1.', 10, 1),
      ChartData('22.1.', 2, 5),
      ChartData('23.1.', 4, 7),
      ChartData('24.1.', 10, 0),
      ChartData('25.1.', 10, 0),
      ChartData('26.1.', 8, 2),
      ChartData('27.1.', 5, 5),
      ChartData('28.1.', 2, 8),
      ChartData('29.1.', 4, 6),
      ChartData('30.1.', 7, 3),
      ChartData('31.1.', 10, 3),
      ChartData('1.2.', 8, 2),
      ChartData('2.2.', 5, 5),
      ChartData('3.2.', 4, 6),
      ChartData('4.2.', 7, 3),
      ChartData('5.2.', 8, 2),
      ChartData('6.2.', 10, 4),
      ChartData('7.2.', 3, 5),
      ChartData('8.2.', 5, 6),
      ChartData('9.2.', 7, 7),
      ChartData('10.2.', 1, 3)
    ];
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        title: Text("Historie & Statistiky"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 90, 0, 0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/abstract_background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.all(0),
                child: DropdownButton<String>(
                  value: dropdownValue,
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
                      dropdownValue = value!;
                    });
                  },
                  items: listek.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: /*Text(snapshot.data!.length
                          .toString()),*/
                  Center(
                child: FutureBuilder<List<yxnType>>(
                  future: getYxn(),
                  builder: (context, AsyncSnapshot<List<yxnType>> snapshot) {
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
                          Future<List<yxnType?>> statistika1 = getYxn();
                          final List<ChartData2> chartData12 = [
                            ChartData2(
                                snapshot.data![0].x,
                                snapshot.data![0].y,
                                Color.fromARGB(207, 51, 201, 14),
                                snapshot.data![0].text),
                            ChartData2(snapshot.data![1].x, snapshot.data![1].y,
                                Colors.red, snapshot.data![1].text),
                          ];
                          /*final List<ChartData2> chartData1 = [
                      ChartData2('Splněno', 65, Colors.blueGrey, 'Splněno 75%'),
                      ChartData2('Nesplněno', 35, Colors.red, 'Nesplněno 25%'),
                    ];*/
                          return Container(
                              child: SfCircularChart(series: <CircularSeries>[
                            // Render pie chart
                            PieSeries<ChartData2, String>(
                              explode: true,
                              explodeIndex: 1,
                              dataSource: chartData12,
                              pointColorMapper: (ChartData2 data, _) =>
                                  data.color,
                              xValueMapper: (ChartData2 data, _) => data.x,
                              yValueMapper: (ChartData2 data, _) => data.y,
                              dataLabelMapper: (ChartData2 data, _) =>
                                  data.text,
                              dataLabelSettings: DataLabelSettings(
                                isVisible: true,
                                labelPosition: ChartDataLabelPosition.outside,
                                useSeriesColor: true,
                              ),
                            ),
                          ]));
                        }
                    }
                  },
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Container(
                  child: SfCartesianChart(
                    tooltipBehavior: _tooltipBehavior,
                    primaryXAxis: CategoryAxis(),
                    series: <ChartSeries>[
                      // Renders line chart
                      SplineSeries<ChartData, String>(
                          name: 'Nesplněno',
                          dataSource: chartData,
                          color: Colors.red,
                          markerSettings: MarkerSettings(
                            isVisible: true,
                            shape: DataMarkerType.circle,
                            width: 6,
                            height: 6,
                          ),
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.z),
                      SplineSeries<ChartData, String>(
                          name: 'Splněno',
                          dataSource: chartData,
                          color: Color.fromARGB(207, 51, 201, 14),
                          markerSettings: MarkerSettings(
                            isVisible: true,
                            shape: DataMarkerType.circle,
                            width: 6,
                            height: 6,
                          ),
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
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
      ),
    );
  }
}
