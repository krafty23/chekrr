import 'package:http/http.dart' as http;
import 'dart:convert';

List<Program> ProgramFromJson(String str) =>
    List<Program>.from(json.decode(str).map((x) => Program.fromJson(x)));

String ProgramToJson(List<Program> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Program {
  String name;
  String perex;
  String image_filename;
  int challenge_count;
  int id;
  List<Program> ProgramFromJson(String str) =>
      List<Program>.from(json.decode(str).map((x) => Program.fromJson(x)));

  String ProgramToJson(List<Program> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  Program(
      {this.name = '',
      this.perex = '',
      this.image_filename = '',
      this.challenge_count = 0,
      this.id = 0});
  factory Program.fromJson(Map<String, dynamic> json) => Program(
        name: json['name'] as String,
        perex: json['perex'] as String,
        image_filename: json['image_filename'] as String,
        challenge_count: int.tryParse(json['challenge_count']) as int,
        id: int.tryParse(json['id']) as int,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'perex': perex,
        'image_filename': image_filename,
        'challenge_count': challenge_count,
        'id': id,
      };
}
