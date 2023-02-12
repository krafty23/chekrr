import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "package:flutter/material.dart";

List<Program> ProgramFromJson(String str) =>
    List<Program>.from(json.decode(str).map((x) => Program.fromJson(x)));

String ProgramToJson(List<Program> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<ProgramInfo> ProgramInfoFromJson(String str) => List<ProgramInfo>.from(
    json.decode(str).map((x) => ProgramInfo.fromJson(x)));

String ProgramInfoInfoToJson(List<ProgramInfo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<ProgramFull> ProgramFullFromJson(String str) => List<ProgramFull>.from(
    json.decode(str).map((x) => ProgramFull.fromJson(x)));

String ProgramFullToJson(List<ProgramFull> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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
