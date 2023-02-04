import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/calendar.dart';
import '../globals.dart' as globals;
import 'package:get_storage/get_storage.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class CalendarScreen extends StatefulWidget {
  CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

List<Meeting> _getDataSource() {
  final List<Meeting> meetings = <Meeting>[];
  final DateTime today = DateTime.now();
  final DateTime zitra = DateTime.utc(2023, 2, 6, 0, 0, 0);
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));
  final DateTime startTime2 =
      DateTime(zitra.year, zitra.month, zitra.day, 9, 0, 0);
  final DateTime endTime2 = startTime2.add(const Duration(hours: 2));
  meetings.add(Meeting('Nehulit', startTime, endTime, Colors.blueGrey, true));
  meetings.add(Meeting('Cvicit', startTime, endTime, Colors.blueGrey, true));
  meetings.add(Meeting('Mrdat', startTime, endTime, Colors.blueGrey, true));
  meetings.add(Meeting('Behat', startTime, endTime, Colors.blueGrey, true));
  meetings.add(Meeting('Nehulit', startTime2, endTime2, Colors.blueGrey, true));
  meetings.add(Meeting('Cvicit', startTime2, endTime2, Colors.blueGrey, true));
  return meetings;
}

class _CalendarScreenState extends State<CalendarScreen> {
  late Future<List<CalendarTask>> _future;
  Future<List<CalendarTask>> getTask() async {
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

  late GlobalKey<ScaffoldState> _scaffoldKey;
  @override
  void initState() {
    _scaffoldKey = GlobalKey();
    _future = getTask();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
      ),
    );
  }

  Widget build(BuildContext context) {
    //final TaskController taskController = Get.put(TaskController());
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        title: Text("Můj Kalendář"),
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
        child: FutureBuilder(
          future: _future,
          builder: (context, AsyncSnapshot<List<CalendarTask>> snapshot) {
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
                  return Column(
                    children: <Widget>[
                      Expanded(
                        child: snapshot.data!.isNotEmpty
                            ? SfCalendar(
                                initialSelectedDate: DateTime.now(),
                                view: CalendarView.month,
                                showDatePickerButton: true,
                                dataSource:
                                    CalendarTaskDataSource(snapshot.data!),
                                //dataSource: MeetingDataSource(_getDataSource()),
                                firstDayOfWeek: 1,
                                monthViewSettings: MonthViewSettings(
                                  showAgenda: true,
                                  agendaStyle: AgendaStyle(
                                    appointmentTextStyle: TextStyle(
                                      fontSize: 15,
                                      //fontStyle: FontStyle.italic,
                                      //color: Color(0xFF0ffcc00),
                                    ),
                                  ),
                                  agendaViewHeight: 400,
                                  agendaItemHeight: 35,
                                ),
                              )
                            : Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Center(
                                      child: Text('Žádné výzvy nenalezeny'),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  );
                }
            }
          },
        ),
      ),
      /*body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: SfCalendar(
              view: CalendarView.month,
              showDatePickerButton: true,
              dataSource: MeetingDataSource(_getDataSource()),
              firstDayOfWeek: 1,
              monthViewSettings: MonthViewSettings(
                showAgenda: true,
                agendaStyle: AgendaStyle(
                    /*appointmentTextStyle: TextStyle(
                    fontSize: 17,
                    //fontStyle: FontStyle.italic,
                    //color: Color(0xFF0ffcc00),
                  ),*/
                    ),
                agendaViewHeight: 400,
              ),
            ),
          ),
        ],
      ),*/
    );
  }
}
