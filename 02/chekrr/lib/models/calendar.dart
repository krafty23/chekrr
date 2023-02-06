import "package:flutter/material.dart";
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'dart:convert';

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class CalendarTask {
  CalendarTask(
      {required this.id,
      required this.eventName,
      required this.from,
      required this.to,
      required this.background,
      required this.isAllDay});

  int id;
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;

  /*DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;*/

  factory CalendarTask.fromJson(Map<String, dynamic> json) => CalendarTask(
        id: int.tryParse(json['id']) as int,
        eventName: json['name'] as String,
        from: DateTime(
          int.parse(json['startdate_year']),
          int.parse(json['startdate_month']),
          int.parse(json['startdate_day']),
          int.parse(json['startdate_hour']),
          int.parse(json['startdate_minute']),
          int.parse(json['startdate_second']),
        ) as DateTime,
        to: DateTime(
          int.parse(json['startdate_year']),
          int.parse(json['startdate_month']),
          int.parse(json['startdate_day']),
          23,
          59,
          59,
        ) as DateTime,
        //to: int.tryParse(json['id']) as int,
        background: int.parse(json['status']) == 0
            ? Color.fromARGB(111, 96, 125, 139)
            : int.parse(json['status']) == 1
                ? Color.fromARGB(111, 51, 201, 14)
                : Color.fromARGB(111, 242, 44, 41),
        isAllDay: true as bool,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'eventName': eventName,
        'from': from,
        'to': to,
        'background': background,
        'isAllDay': isAllDay,
      };
}

class CalendarTaskDataSource extends CalendarDataSource {
  CalendarTaskDataSource(List<CalendarTask> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

List<CalendarTask> CalendarTaskFromJson(String str) => List<CalendarTask>.from(
    json.decode(str).map((x) => CalendarTask.fromJson(x)));

String CalendarTaskToJson(List<CalendarTask> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
