import 'package:http/http.dart' as http;
import 'dart:convert';
import "package:flutter/material.dart";

List<yxnType> yxnTypeFromJson(String str) =>
    List<yxnType>.from(json.decode(str).map((x) => yxnType.fromJson(x)));

String yxnTypeToJson(List<yxnType> data) =>
    json.encode(List<yxnType>.from(data.map((x) => x.toJson())));

class ChartData {
  ChartData(this.x, this.y, this.z);
  final String x;
  final double y;
  final double z;
}

class ChartData2 {
  final String x;
  final int y;
  final Color color;
  final String text;
  ChartData2(this.x, this.y, this.color, this.text);
}

class yxnType {
  String x;
  int y;
  String color;
  String text;

  yxnType({this.x = '', this.y = 0, this.color = '', this.text = ''});
  factory yxnType.fromJson(Map<String, dynamic> json) => yxnType(
        x: json['x'] as String,
        y: int.tryParse(json['y']) as int,
        color: json['color'] as String,
        text: json['text'] as String,
      );

  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
        'color': color,
        'text': text,
      };
}

class HistoryTask {
  HistoryTask({
    required this.date,
    required this.done,
    required this.canceled,
  });

  String date;
  int done;
  int canceled;
  factory HistoryTask.fromJson(Map<String, dynamic> json) => HistoryTask(
        date: json['startdate_day'] + '.' + json['startdate_month'] + '.'
            as String,
        done: json['done'] != null
            ? int.parse(json['done']) as int
            : int.parse('0') as int,
        canceled: json['canceled'] != null
            ? int.parse(json['canceled']) as int
            : int.parse('0') as int,
      );
  Map<String, dynamic> toJson() => {
        'date': date,
        'done': done,
        'canceled': canceled,
      };
}

List<HistoryTask> HistoryTaskFromJson(String str) => List<HistoryTask>.from(
    json.decode(str).map((x) => HistoryTask.fromJson(x)));

String CalendarTaskToJson(List<HistoryTask> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
