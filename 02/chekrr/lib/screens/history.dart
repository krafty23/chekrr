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
  late Future<List<PastTask>> _future;
  late Future<List<yxnType>> _future2;
  late Future<List<HistoryTask>> _future3;
  Future<List<PastTask>> getTask() async {
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
        return PastTaskFromJson(response.body);
      } else {
        return <PastTask>[];
      }
    } catch (e) {
      return <PastTask>[]; // return an empty list on exception/error
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

  Future<List<HistoryTask>> getHistory() async {
    final box = GetStorage();
    var uid = box.read('uid');
    try {
      Map<String, dynamic> requestbody = {
        //'uid': globals.uid.toString(),
        'uid': uid.toString(),
      };
      http.Response response = await http.post(
          Uri.parse(globals.globalProtocol +
              globals.globalURL +
              '/api/index.php/stats/history'),
          headers: <String, String>{
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            //'Content-Type': 'application/json; charset=UTF-8',
          },
          body: requestbody);
      if (response.statusCode == 200) {
        return HistoryTaskFromJson(response.body);
      } else {
        return <HistoryTask>[];
      }
    } catch (e) {
      return <HistoryTask>[]; // return an empty list on exception/error
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
    _future3 = getHistory();
  }

  static const List<String> listek = <String>[
    'Poslední týden',
    'Poslední měsíc',
    'Poslední rok'
  ];
  String selectedTime = "1";
  String dropdownValue = listek.first;
  Widget build(BuildContext context) {
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
            image: AssetImage("images/chekrr_bg.png"),
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
                            child: (snapshot.data![0].y > 0 ||
                                    snapshot.data![1].y > 0)
                                ? SfCircularChart(
                                    series: <CircularSeries>[
                                      // Render pie chart
                                      PieSeries<ChartData2, String>(
                                        explode: true,
                                        explodeIndex: 1,
                                        dataSource: chartData12,
                                        pointColorMapper:
                                            (ChartData2 data, _) => data.color,
                                        xValueMapper: (ChartData2 data, _) =>
                                            data.x,
                                        yValueMapper: (ChartData2 data, _) =>
                                            data.y,
                                        dataLabelMapper: (ChartData2 data, _) =>
                                            data.text,
                                        dataLabelSettings: DataLabelSettings(
                                          isVisible: true,
                                          labelPosition:
                                              ChartDataLabelPosition.outside,
                                          useSeriesColor: true,
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                          );
                        }
                    }
                  },
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: FutureBuilder(
                  future: _future3,
                  builder:
                      (context, AsyncSnapshot<List<HistoryTask>> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return Text('Chyba pripojeni');
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
                          //print(snapshot.data?.length.toString());
                          return Container(
                            child: snapshot.data!.isNotEmpty
                                ? SfCartesianChart(
                                    tooltipBehavior: _tooltipBehavior,
                                    primaryXAxis: CategoryAxis(),
                                    series: <ChartSeries>[
                                      // Renders line chart
                                      SplineSeries<HistoryTask, String>(
                                          name: 'Nesplněno',
                                          dataSource: snapshot.data!,
                                          color: Colors.red,
                                          markerSettings: MarkerSettings(
                                            isVisible: false,
                                            shape: DataMarkerType.circle,
                                            width: 6,
                                            height: 6,
                                          ),
                                          xValueMapper: (HistoryTask data, _) =>
                                              data.date,
                                          yValueMapper: (HistoryTask data, _) =>
                                              data.canceled),
                                      SplineSeries<HistoryTask, String>(
                                          name: 'Splněno',
                                          dataSource: snapshot.data!,
                                          color:
                                              Color.fromARGB(207, 51, 201, 14),
                                          markerSettings: MarkerSettings(
                                            isVisible: false,
                                            shape: DataMarkerType.circle,
                                            width: 6,
                                            height: 6,
                                          ),
                                          xValueMapper: (HistoryTask data, _) =>
                                              data.date,
                                          yValueMapper: (HistoryTask data, _) =>
                                              data.done),
                                    ],
                                  )
                                : Center(
                                    child: Text('Žádná data nenalezena'),
                                  ),
                          );
                        }
                    }
                  },
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: FutureBuilder(
                future: _future,
                builder: (context, AsyncSnapshot<List<PastTask>> snapshot) {
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
                            padding: EdgeInsets.zero,
                            //separatorBuilder: (_, __) => Divider(),
                            //itemCount: taskController.tasks.length,
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) => Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 5),
                              decoration: BoxDecoration(
                                color: (snapshot.data![index].status == 1)
                                    ? Color.fromARGB(45, 76, 175, 79)
                                    : Color.fromARGB(25, 244, 67, 54),
                              ),
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
                                          : Icons.close,
                                      color: (snapshot.data![index].status == 1)
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ],
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      snapshot.data![index].date,
                                      style: TextStyle(
                                        color: Color.fromRGBO(
                                            255, 255, 255, 0.562),
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data![index].time,
                                      style: TextStyle(
                                        color: Color.fromRGBO(
                                            255, 255, 255, 0.562),
                                        fontSize: 12,
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
            ),
          ],
        ),
      ),
    );
  }
}
