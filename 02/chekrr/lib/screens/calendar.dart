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
    /*SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
      ),
    );*/
  }

  Widget build(BuildContext context) {
    //final TaskController taskController = Get.put(TaskController());
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        title: Text("M??j Kalend????"),
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
                  dynamic args = Get.arguments;
                  return Column(
                    children: <Widget>[
                      Expanded(
                        child: snapshot.data!.isNotEmpty
                            ? SfCalendar(
                                initialDisplayDate: args != null
                                    ? args['preselected']
                                    //? DateTime.tryParse(args[0]['preselected'])
                                    : DateTime.now(),
                                initialSelectedDate: args != null
                                    ? args['preselected']
                                    //? DateTime.tryParse(args[0]['preselected'])
                                    : DateTime.now(),
                                view: CalendarView.month,
                                todayHighlightColor:
                                    Color.fromARGB(214, 63, 137, 197),
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
                                      child: Text('????dn?? v??zvy nenalezeny'),
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
