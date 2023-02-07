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
  String username;
  String foto_filename;
  String email_personal;
  int id;
  int finished_folder_count;
  int finished_item_count;
  int achievement_count;
  List<UserFull> UserFullFromJson(String str) =>
      List<UserFull>.from(json.decode(str).map((x) => UserFull.fromJson(x)));

  String UserFullToJson(List<UserFull> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  UserFull({
    this.name = '',
    this.surname = '',
    this.username = '',
    this.foto_filename = '',
    this.email_personal = '',
    this.id = 0,
    this.finished_folder_count = 0,
    this.finished_item_count = 0,
    this.achievement_count = 0,
  });
  factory UserFull.fromJson(Map<String, dynamic> json) => UserFull(
        name: json['name'] as String,
        surname: json['surname'] as String,
        username: json['username'] as String,
        foto_filename: json['foto_filename'] as String,
        email_personal: json['email_personal'] as String,
        id: int.tryParse(json['id']) as int,
        finished_folder_count:
            int.tryParse(json['finished_folder_count']) as int,
        finished_item_count: int.tryParse(json['finished_item_count']) as int,
        achievement_count: int.tryParse(json['achievement_count']) as int,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'surname': surname,
        'username': username,
        'foto_filename': foto_filename,
        'email_personal': email_personal,
        'id': id,
        'finished_folder_count': finished_folder_count,
        'finished_item_count': finished_item_count,
        'achievement_count': achievement_count,
      };
}
