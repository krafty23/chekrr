import 'dart:convert';
import '../globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:chekrr/drawer.dart';
import '../bottomtab.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../models/user.dart';
import '../models/calendar.dart';
import '../models/stats.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

late TooltipBehavior _tooltipBehavior;

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<List<UserFull>> _future;
  late Future<List<CalendarTask>> _futurex;
  late Future<List<HistoryTask>> _future3;
  Future<List<UserFull>> getUserFull() async {
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
              '/api/index.php/user/detail'),
          headers: <String, String>{
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            //'Content-Type': 'application/json; charset=UTF-8',
          },
          body: requestbody);
      if (response.statusCode == 200) {
        return UserFullFromJson(response.body);
      } else {
        return <UserFull>[];
      }
    } catch (e) {
      return <UserFull>[]; // return an empty list on exception/error
    }
  }

  Future<List<CalendarTask>> getCalendar() async {
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
              '/api/index.php/calendar/listAll'),
          headers: <String, String>{
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            //'Content-Type': 'application/json; charset=UTF-8',
          },
          body: requestbody);
      if (response.statusCode == 200) {
        return CalendarTaskFromJson(response.body);
      } else {
        return <CalendarTask>[];
      }
    } catch (e) {
      return <CalendarTask>[]; // return an empty list on exception/error
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
    _scaffoldKey = GlobalKey();
    super.initState();
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      format: 'point.x - point.y',
    );
    _future = getUserFull();
    _futurex = getCalendar();
    _future3 = getHistory();
  }

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    bool LoggedIn = box.read('isloggedin') ?? false;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        title: Text("Profil"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: DrawerDraw(),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 100, 0, 65),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/chekrr_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder(
          future: _future,
          builder: (context, AsyncSnapshot<List<UserFull>> snapshot) {
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
                  return Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(
                                      globals.globalProtocol +
                                          globals.globalURL +
                                          '/images/users/' +
                                          snapshot.data![0].foto_filename),
                                ),
                                /*child: Image(
                                  image: NetworkImage(
                                    globals.globalProtocol +
                                        globals.globalURL +
                                        '/images/users/' +
                                        snapshot.data![0].foto_filename,
                                  ),
                                ),*/
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data![0].name.toString() +
                                          ' ' +
                                          snapshot.data![0].surname.toString(),
                                      style: TextStyle(
                                        fontSize: 24,
                                      ),
                                    ),
                                    Text(
                                      '' +
                                          snapshot.data![0].username
                                              .toString() +
                                          '',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color:
                                            Color.fromARGB(120, 255, 255, 255),
                                      ),
                                    ),
                                    OutlinedButton.icon(
                                      icon: Icon(Icons.edit),
                                      label: Text(
                                        'Upravit profil',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      onPressed: () {
                                        Get.toNamed(
                                          '/edit_profile?id=' +
                                              snapshot.data![0].id.toString(),
                                        );
                                      },
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty
                                            .resolveWith<OutlinedBorder>((_) {
                                          return RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            side: BorderSide(
                                                color: Color.fromARGB(
                                                    129, 255, 255, 255)),
                                          );
                                        }),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Color.fromARGB(
                                                    255, 214, 214, 214)),
                                      ),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  Get.toNamed('/history');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color:
                                            Color.fromARGB(24, 255, 255, 255),
                                      ),
                                      right: BorderSide(
                                        color:
                                            Color.fromARGB(24, 255, 255, 255),
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(20, 5, 20, 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          snapshot.data![0].finished_item_count
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'splněné\nvýzvy',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                120, 255, 255, 255),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  Get.toNamed('/challenges_done');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color:
                                            Color.fromARGB(24, 255, 255, 255),
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(20, 5, 20, 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          snapshot
                                              .data![0].finished_folder_count
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'splněné\nprogramy',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                120, 255, 255, 255),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  Get.toNamed('/achievements');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color:
                                            Color.fromARGB(24, 255, 255, 255),
                                      ),
                                      left: BorderSide(
                                        color:
                                            Color.fromARGB(24, 255, 255, 255),
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(20, 5, 20, 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          snapshot.data![0].achievement_count
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'získané odznaky',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                120, 255, 255, 255),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed('/calendar');
                                },
                                child: Text(
                                  'Kalendář',
                                  style: TextStyle(
                                    fontSize: 26,
                                    color: Color.fromARGB(120, 255, 255, 255),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed('/calendar');
                                },
                                child: Icon(
                                  Icons.chevron_right,
                                  size: 36,
                                  color: Color.fromARGB(120, 255, 255, 255),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: FutureBuilder(
                              future: _futurex,
                              builder: (context,
                                  AsyncSnapshot<List<CalendarTask>> snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                    return Text('Chyba pripojeni');
                                  case ConnectionState.waiting:
                                    return Center(
                                        child: CircularProgressIndicator());
                                  case ConnectionState.active:
                                    return Text('');
                                  case ConnectionState.done:
                                    if (snapshot.hasError) {
                                      return Text(
                                        '${snapshot.error}',
                                        style: TextStyle(color: Colors.red),
                                      );
                                    } else {
                                      return snapshot.data!.isNotEmpty
                                          ? Column(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    constraints: BoxConstraints(
                                                      minHeight:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .height,
                                                    ),
                                                    child: SfCalendar(
                                                      //initialSelectedDate: DateTime.now(),
                                                      onTap: (CalendarTapDetails
                                                          details) {
                                                        print(details.date);
                                                        Get.toNamed(
                                                          '/calendar',
                                                          arguments: {
                                                            'preselected':
                                                                details.date
                                                          },
                                                        );
                                                      },
                                                      showDatePickerButton:
                                                          true,
                                                      view: CalendarView.month,
                                                      todayHighlightColor:
                                                          Color.fromARGB(
                                                              59, 244, 156, 55),
                                                      selectionDecoration:
                                                          BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                                Color.fromARGB(
                                                                    54,
                                                                    244,
                                                                    156,
                                                                    55),
                                                            width: 2),
                                                      ),
                                                      dataSource:
                                                          CalendarTaskDataSource(
                                                              snapshot.data!),
                                                      firstDayOfWeek: 1,
                                                      monthViewSettings:
                                                          MonthViewSettings(
                                                        showAgenda: false,
                                                        numberOfWeeksInView: 1,
                                                        appointmentDisplayCount:
                                                            6,
                                                        appointmentDisplayMode:
                                                            MonthAppointmentDisplayMode
                                                                .indicator,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Column(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                        'Žádné výzvy nenalezeny'),
                                                  ),
                                                ),
                                              ],
                                            );
                                    }
                                }
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed('/history');
                                },
                                child: Text(
                                  'Statistiky',
                                  style: TextStyle(
                                    fontSize: 26,
                                    color: Color.fromARGB(120, 255, 255, 255),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed('/history');
                                },
                                child: Icon(
                                  Icons.chevron_right,
                                  size: 36,
                                  color: Color.fromARGB(120, 255, 255, 255),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: FutureBuilder(
                            future: _future3,
                            builder: (context,
                                AsyncSnapshot<List<HistoryTask>> snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                  return Text('Chyba pripojeni');
                                case ConnectionState.waiting:
                                  return Center(
                                      child: CircularProgressIndicator());
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
                                                SplineSeries<HistoryTask,
                                                        String>(
                                                    name: 'Nesplněno',
                                                    dataSource: snapshot.data!,
                                                    color: Colors.red,
                                                    markerSettings:
                                                        MarkerSettings(
                                                      isVisible: true,
                                                      shape:
                                                          DataMarkerType.circle,
                                                      width: 6,
                                                      height: 6,
                                                    ),
                                                    xValueMapper:
                                                        (HistoryTask data, _) =>
                                                            data.date,
                                                    yValueMapper:
                                                        (HistoryTask data, _) =>
                                                            data.canceled),
                                                SplineSeries<HistoryTask,
                                                        String>(
                                                    name: 'Splněno',
                                                    dataSource: snapshot.data!,
                                                    color: Color.fromARGB(
                                                        207, 51, 201, 14),
                                                    markerSettings:
                                                        MarkerSettings(
                                                      isVisible: true,
                                                      shape:
                                                          DataMarkerType.circle,
                                                      width: 6,
                                                      height: 6,
                                                    ),
                                                    xValueMapper:
                                                        (HistoryTask data, _) =>
                                                            data.date,
                                                    yValueMapper:
                                                        (HistoryTask data, _) =>
                                                            data.done),
                                              ],
                                            )
                                          : Center(
                                              child:
                                                  Text('Žádná data nenalezena'),
                                            ),
                                    );
                                  }
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  );
                }
            }
          },
        ),
      ),
      bottomNavigationBar: BottomTabs(),
    );
  }
}
