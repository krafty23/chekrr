import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "package:flutter/material.dart";

List<Program> ProgramFromJson(String str) =>
    List<Program>.from(json.decode(str).map((x) => Program.fromJson(x)));

String ProgramToJson(List<Program> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
List<ProgramDone> ProgramDoneFromJson(String str) => List<ProgramDone>.from(
    json.decode(str).map((x) => ProgramDone.fromJson(x)));

String ProgramDoneToJson(List<ProgramDone> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<ProgramSubinfo> ProgramSubinfoFromJson(String str) =>
    List<ProgramSubinfo>.from(
        json.decode(str).map((x) => ProgramSubinfo.fromJson(x)));

String ProgramSubinfoToJson(List<ProgramSubinfo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<ProgramInfo> ProgramInfoFromJson(String str) => List<ProgramInfo>.from(
    json.decode(str).map((x) => ProgramInfo.fromJson(x)));

String ProgramInfoToJson(List<ProgramInfo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<ProgramFull> ProgramFullFromJson(String str) => List<ProgramFull>.from(
    json.decode(str).map((x) => ProgramFull.fromJson(x)));

String ProgramFullToJson(List<ProgramFull> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProgramSubinfo {
  String accepted_date;
  List<ProgramSubinfo> ProgramFromJson(String str) => List<ProgramSubinfo>.from(
      json.decode(str).map((x) => ProgramSubinfo.fromJson(x)));
  String ProgramSubinfoToJson(List<ProgramSubinfo> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
  ProgramSubinfo({
    this.accepted_date = '',
  });
  factory ProgramSubinfo.fromJson(Map<String, dynamic> json) =>
      ProgramSubinfo(accepted_date: json['accepted_date'] as String);
  Map<String, dynamic> toJson() => {
        'accepted_date': accepted_date,
      };
}

class ProgramInfo {
  String name;
  String perex;
  String image_filename;
  int challenge_count;
  int day_count;
  int current_day;
  int id;
  Icon icon;
  List<Program> ProgramFromJson(String str) =>
      List<Program>.from(json.decode(str).map((x) => Program.fromJson(x)));

  String ProgramToJson(List<Program> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
  ProgramInfo({
    this.name = '',
    this.perex = '',
    this.image_filename = '',
    this.challenge_count = 0,
    this.day_count = 0,
    this.current_day = 0,
    this.id = 0,
    this.icon = const Icon(Icons.home),
  });
  factory ProgramInfo.fromJson(Map<String, dynamic> json) => ProgramInfo(
        name: json['name'] as String,
        perex: json['perex'] as String,
        image_filename: json['image_filename'] as String,
        challenge_count: int.tryParse(json['challenge_count']) as int,
        day_count: int.tryParse(json['day_count']) as int,
        current_day: int.tryParse(json['current_day']) as int,
        id: int.tryParse(json['id']) as int,
        icon: Icon(
          IconData(
            int.parse(json['icon']),
            fontFamily: 'MaterialIcons',
          ),
          color: Color.fromRGBO(244, 157, 55, 1),
          size: 25,
        ),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'perex': perex,
        'image_filename': image_filename,
        'challenge_count': challenge_count,
        'day_count': day_count,
        'current_day': current_day,
        'id': id,
      };
}

class Program {
  String name;
  String perex;
  String image_filename;
  int challenge_count;
  int day_count;
  int id;
  Icon icon;
  List<Program> ProgramFromJson(String str) =>
      List<Program>.from(json.decode(str).map((x) => Program.fromJson(x)));

  String ProgramToJson(List<Program> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
  Program({
    this.name = '',
    this.perex = '',
    this.image_filename = '',
    this.challenge_count = 0,
    this.day_count = 0,
    this.id = 0,
    this.icon = const Icon(Icons.home),
  });
  factory Program.fromJson(Map<String, dynamic> json) => Program(
        name: json['name'] as String,
        perex: json['perex'] as String,
        image_filename: json['image_filename'] as String,
        challenge_count: int.tryParse(json['challenge_count']) as int,
        day_count: int.tryParse(json['day_count']) as int,
        id: int.tryParse(json['id']) as int,
        icon: Icon(
          IconData(
            int.parse(json['icon']),
            fontFamily: 'MaterialIcons',
          ),
          color: Color.fromRGBO(244, 157, 55, 1),
          size: 25,
        ),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'perex': perex,
        'image_filename': image_filename,
        'challenge_count': challenge_count,
        'day_count': day_count,
        'id': id,
      };
}

class ProgramDone {
  String name;
  String perex;
  String image_filename;
  int challenge_count;
  int day_count;
  int instance_id;
  int accepted_date_day;
  int accepted_date_month;
  int accepted_date_year;
  int finished_date_day;
  int finished_date_month;
  int finished_date_year;
  int id;
  Icon icon;
  List<ProgramDone> ProgramDoneFromJson(String str) => List<ProgramDone>.from(
      json.decode(str).map((x) => ProgramDone.fromJson(x)));

  String ProgramDoneToJson(List<ProgramDone> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
  ProgramDone({
    this.name = '',
    this.perex = '',
    this.image_filename = '',
    this.challenge_count = 0,
    this.day_count = 0,
    this.instance_id = 0,
    this.id = 0,
    this.accepted_date_day = 0,
    this.accepted_date_month = 0,
    this.accepted_date_year = 0,
    this.finished_date_day = 0,
    this.finished_date_month = 0,
    this.finished_date_year = 0,
    this.icon = const Icon(Icons.home),
  });
  factory ProgramDone.fromJson(Map<String, dynamic> json) => ProgramDone(
        name: json['name'] as String,
        perex: json['perex'] as String,
        image_filename: json['image_filename'] as String,
        challenge_count: int.tryParse(json['challenge_count']) as int,
        day_count: int.tryParse(json['day_count']) as int,
        instance_id: int.tryParse(json['instance_id']) as int,
        id: int.tryParse(json['id']) as int,
        accepted_date_day: int.tryParse(json['accepted_date_day']) as int,
        accepted_date_month: int.tryParse(json['accepted_date_month']) as int,
        accepted_date_year: int.tryParse(json['accepted_date_year']) as int,
        finished_date_day: int.tryParse(json['finished_date_day']) as int,
        finished_date_month: int.tryParse(json['finished_date_month']) as int,
        finished_date_year: int.tryParse(json['finished_date_year']) as int,
        icon: Icon(
          IconData(
            int.parse(json['icon']),
            fontFamily: 'MaterialIcons',
          ),
          color: Color.fromRGBO(244, 157, 55, 1),
          size: 25,
        ),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'perex': perex,
        'image_filename': image_filename,
        'challenge_count': challenge_count,
        'day_count': day_count,
        'instance_id': instance_id,
        'id': id,
        'accepted_date_day': accepted_date_day,
        'accepted_date_month': accepted_date_month,
        'accepted_date_year': accepted_date_year,
        'finished_date_day': finished_date_day,
        'finished_date_month': finished_date_month,
        'finished_date_year': finished_date_year,
      };
}

class ProgramFull {
  String name;
  String perex;
  String text;
  String image_filename;
  String color;
  String category_name;
  int challenge_count;
  int id;
  int use_color;
  int category_id;
  int day_count;
  int is_accepted;
  Icon icon;
  List<ProgramFull> ProgramFullFromJson(String str) => List<ProgramFull>.from(
      json.decode(str).map((x) => ProgramFull.fromJson(x)));

  String ProgramFullToJson(List<ProgramFull> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  ProgramFull(
      {this.name = '',
      this.perex = '',
      this.text = '',
      this.image_filename = '',
      this.category_name = '',
      this.color = '',
      this.challenge_count = 0,
      this.id = 0,
      this.use_color = 0,
      this.category_id = 0,
      this.day_count = 0,
      this.is_accepted = 0,
      this.icon = const Icon(Icons.home)});
  factory ProgramFull.fromJson(Map<String, dynamic> json) => ProgramFull(
        name: json['name'] as String,
        perex: json['perex'] as String,
        text: json['text'] as String,
        image_filename: json['image_filename'] as String,
        challenge_count: int.tryParse(json['challenge_count']) as int,
        id: int.tryParse(json['id']) as int,
        use_color: int.tryParse(json['use_color']) as int,
        color: json['color'] as String,
        category_id: int.tryParse(json['category_id']) as int,
        category_name: json['category_name'].toString() as String,
        day_count: int.tryParse(json['day_count']) as int,
        is_accepted: int.tryParse(json['is_accepted']) as int,
        icon: Icon(
          IconData(
            int.parse(json['icon']),
            fontFamily: 'MaterialIcons',
          ),
          color: Color.fromRGBO(244, 157, 55, 1),
          size: 25,
        ),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'perex': perex,
        'text': text,
        'image_filename': image_filename,
        'challenge_count': challenge_count,
        'id': id,
        'use_color': use_color,
        'color': color,
        'category_id': category_id,
        'category_name': category_name,
        'day_count': day_count,
        'is_accepted': is_accepted,
      };
}

class ProgramDetails {
  var pid;
  var uid;
  ProgramDetails(
    this.pid,
    this.uid,
  );

  @override
  String toString() {
    return '{ ${this.pid}, ${this.uid} }';
  }
}
