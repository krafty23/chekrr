import 'package:http/http.dart' as http;
import 'dart:convert';

List<UserFull> UserFullFromJson(String str) =>
    List<UserFull>.from(json.decode(str).map((x) => UserFull.fromJson(x)));

String UserFullToJson(List<UserFull> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  User({this.name = '', this.foto_filename = '', this.uid = 0});
  String name;
  String foto_filename;
  int uid;
}

class UserFull {
  String name;
  String surname;
  String foto_filename;
  int id;
  List<UserFull> UserFullFromJson(String str) =>
      List<UserFull>.from(json.decode(str).map((x) => UserFull.fromJson(x)));

  String UserFullToJson(List<UserFull> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  UserFull(
      {this.name = '',
      this.surname = '',
      this.foto_filename = '',
      this.id = 0});
  factory UserFull.fromJson(Map<String, dynamic> json) => UserFull(
        name: json['name'] as String,
        surname: json['surname'] as String,
        foto_filename: json['foto_filename'] as String,
        id: int.tryParse(json['id']) as int,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'surname': surname,
        'foto_filename': foto_filename,
        'id': id,
      };
}
